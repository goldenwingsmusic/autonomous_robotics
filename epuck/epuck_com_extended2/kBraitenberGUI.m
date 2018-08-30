function varargout = kBraitenberGUI(varargin)
% BRAITENBERGUI M-file for kBraitenberGUI.fig
%      KBRAITENBERGUI, by itself, creates a new KBRAITENBERGUI or raises the existing
%      singleton*.
%
%      H = KBRAITENBERGUI returns the handle to a new KBRAITENBERGUI or the handle to
%      the existing singleton*.
%
%      KBRAITENBERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KBRAITENBERGUI.M with the given input arguments.
%
%      KBRAITENBERGUI('Property','Value',...) creates a new KBRAITENBERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kBraitenberGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kBraitenberGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kBraitenberGUI

% Last Modified by GUIDE v2.5 23-Jul-2003 11:29:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kBraitenberGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @kBraitenberGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before kBraitenberGUI is made visible.
function kBraitenberGUI_OpeningFcn(hObject, eventdata, handles, varargin)
global amb_aktiv amb_steigung amb_y_achsen_abschnitt amb_kreuz ;
global ir_aktiv ir_steigung ir_y_achsen_abschnitt ir_kreuz ;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kBraitenberGUI (see VARARGIN)

% Choose default command line output for kBraitenberGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kBraitenberGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
defaultVal(handles);


function defaultVal(handles)
global amb_aktiv amb_steigung amb_y_achsen_abschnitt amb_kreuz ;
global ir_aktiv ir_steigung ir_y_achsen_abschnitt ir_kreuz ;
amb_steigung = 1;
amb_y_achsen_abschnitt = 1;
amb_kreuz = 0;
set(handles.amb_ungekreuzt_radiobutton,'Value',1);
set(handles.amb_aktiv_checkbox,'Value',1);
ir_steigung = 1;
ir_y_achsen_abschnitt = 1;
ir_kreuz = 0;
set(handles.ir_ungekreuzt_radiobutton,'Value',1);
set(handles.ir_aktiv_checkbox,'Value',0);

% --- Outputs from this function are returned to the command line.
function varargout = kBraitenberGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function amb_steigung_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amb_steigung_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function amb_steigung_edit_Callback(hObject, eventdata, handles)
global amb_steigung
% hObject    handle to amb_steigung_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amb_steigung_edit as text
%        str2double(get(hObject,'String')) returns contents of amb_steigung_edit as a double
amb_steigung = str2double(get(hObject,'String'));
amb_graph_zeichnen(handles);

% --- Executes during object creation, after setting all properties.
function amb_y_achsen_abschnitt_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amb_y_achsen_abschnitt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function amb_y_achsen_abschnitt_edit_Callback(hObject, eventdata, handles)
global amb_y_achsen_abschnitt
% hObject    handle to amb_y_achsen_abschnitt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amb_y_achsen_abschnitt_edit as text
amb_y_achsen_abschnitt = str2double(get(hObject,'String'));
amb_graph_zeichnen(handles);


% --- Executes on button press in start_pushbutton.
function start_pushbutton_Callback(hObject, eventdata, handles)
global amb_steigung amb_y_achsen_abschnitt amb_kreuz ;
global ir_steigung ir_y_achsen_abschnitt ir_kreuz ;
global amb_aktiv ir_aktiv RUN ;
global port;
% hObject    handle to start_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% port = kOpenPort;
RUN = 1;

if(amb_aktiv==1)
    if(ir_aktiv==1)
        kBraitenberg2(port,amb_steigung,amb_y_achsen_abschnitt,amb_kreuz,ir_steigung,ir_y_achsen_abschnitt,ir_kreuz);
    else
        kBraitenberg2(port,amb_steigung,amb_y_achsen_abschnitt,amb_kreuz,0,0,0);
    end;
else
    if(ir_aktiv==1)
        kBraitenberg2(port,0,0,0,ir_steigung,ir_y_achsen_abschnitt,ir_kreuz);
    else
        errordlg('Keine Sensoren aktiviert');
        return;
    end;
end;


% --- Executes on button press in stop_pushbutton.
function stop_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stop_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global RUN
global port
RUN = 0;
kStop(port);


function amb_graph_zeichnen(handles)
global amb_steigung amb_y_achsen_abschnitt
x1 = 0:0.5:10;
f1 = amb_steigung * x1 + amb_y_achsen_abschnitt;
axes(handles.amb_graph_uebertragungsfunktion);
plot(x1,f1);
xlabel('Lichtintensitaet');
ylabel('Motoraktivitaet');

function ir_graph_zeichnen(handles)
global ir_steigung ir_y_achsen_abschnitt
x2 = 0:0.5:10;
f2 = ir_steigung * x2 + ir_y_achsen_abschnitt;
axes(handles.ir_graph_uebertragungsfunktion);
plot(x2,f2);
xlabel('Lichtintensitaet');
ylabel('Motoraktivitaet');

% --- Executes on button press in amb_gekreuzt_radiobutton.
function amb_gekreuzt_radiobutton_Callback(hObject, eventdata, handles)
global amb_kreuz
% hObject    handle to amb_gekreuzt_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of amb_gekreuzt_radiobutton
amb_kreuz = get(hObject,'Value');
off = [handles.amb_ungekreuzt_radiobutton];
mutual_exclude(off)

% --- Executes on button press in amb_ungekreuzt_radiobutton.
function amb_ungekreuzt_radiobutton_Callback(hObject, eventdata, handles)
global amb_kreuz
% hObject    handle to amb_ungekreuzt_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of amb_ungekreuzt_radiobutton
amb_kreuz = 1 - get(hObject,'Value');
off = [handles.amb_gekreuzt_radiobutton];
mutual_exclude(off)

% --- Executes during object creation, after setting all properties.
function ir_steigung_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ir_steigung_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ir_steigung_edit_Callback(hObject, eventdata, handles)
global ir_steigung
% hObject    handle to ir_steigung_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ir_steigung_edit as text
%        str2double(get(hObject,'String')) returns contents of ir_steigung_edit as a double
ir_steigung = str2double(get(hObject,'String'));
ir_graph_zeichnen(handles);


% --- Executes during object creation, after setting all properties.
function ir_y_achsen_abschnitt_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ir_y_achsen_abschnitt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ir_y_achsen_abschnitt_edit_Callback(hObject, eventdata, handles)
global ir_y_achsen_abschnitt
% hObject    handle to ir_y_achsen_abschnitt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ir_y_achsen_abschnitt_edit as 
%        str2double(get(hObject,'String')) returns contents of ir_y_achsen_abschnitt_edit as a double
ir_y_achsen_abschnitt = str2double(get(hObject,'String'));
ir_graph_zeichnen(handles);

% --- Executes on button press in ir_gekreuzt_radiobutton.
function ir_gekreuzt_radiobutton_Callback(hObject, eventdata, handles)
global ir_kreuz
% hObject    handle to ir_gekreuzt_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ir_gekreuzt_radiobutton
ir_kreuz = get(hObject,'Value');
off = [handles.ir_ungekreuzt_radiobutton];
mutual_exclude(off)

% --- Executes on button press in ir_ungekreuzt_radiobutton.
function ir_ungekreuzt_radiobutton_Callback(hObject, eventdata, handles)
global ir_kreuz
% hObject    handle to ir_ungekreuzt_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ir_ungekreuzt_radiobutton
ir_kreuz = 1 - get(hObject,'Value');
off = [handles.ir_gekreuzt_radiobutton];
mutual_exclude(off)

% --- Executes on button press in amb_aktiv_checkbox.
function amb_aktiv_checkbox_Callback(hObject, eventdata, handles)
global amb_aktiv
% hObject    handle to amb_aktiv_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of amb_aktiv_checkbox
amb_aktiv = get(hObject,'Value');

% --- Executes on button press in ir_aktiv_checkbox.
function ir_aktiv_checkbox_Callback(hObject, eventdata, handles)
global ir_aktiv
% hObject    handle to ir_aktiv_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ir_aktiv_checkbox
ir_aktiv = get(hObject,'Value');


function mutual_exclude(off)
set(off,'Value',0)
