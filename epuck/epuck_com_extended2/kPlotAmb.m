function varargout = kPlotAmb(varargin)
% KPlOTAmb M-file for kPlotAmb.fig
%      KPLOTAMB, by itself, creates a new  KPLOTIR or raises the existing
%      singleton*.
%
%      H =  KPLOTAMB returns the handle to a new  KPLOTAMB or the handle to
%      the existing singleton*.
%
%      KPLOTAMB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in  KPLOTAMB.M with the given input arguments.
%
%      KPLOTAMB('Property','Value',...) creates a new KPLOTAMB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kPlotAmb_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kPlotAmb_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help khepProx

% Last Modified by GUIDE v2.5 25-Nov-2002 15:42:48

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @kPlotAmb_OpeningFcn, ...
                       'gui_OutputFcn',  @kPlotAmb_OutputFcn, ...
                       'gui_LayoutFcn',  [], ...
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

%--------------------------------------------------------------------------

% --- Executes just before kPlotAmb is made visible.
function kPlotAmb_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to kPlotAmb (see VARARGIN)
    global REF GO VELL VELR;
    global y1 y2 y3 y4 y5 y6 y7 y8;
    global vec1 vec2 vec3 vec4 vec5 vec6 vec7 vec8;
    % Choose default command line output for kPlotAmb
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);

    if (length(varargin)~= 0)
        errordlg('too many input arguments');
        return;
    elseif (length(varargin) == 0)
        set(hObject,'Color',[0.043 0.468 0.702]);
        guidata(hObject, handles);
        y1=ones(1,101);
        y2=2*y1;
        y3=3*y1;
        y4=4*y1;
        y5=5*y1;
        y6=6*y1;
        y7=7*y1;
        y8=8*y1;
        vec1=zeros(1,101);
        vec2=zeros(1,101);
        vec3=zeros(1,101);
        vec4=zeros(1,101);
        vec5=zeros(1,101);
        vec6=zeros(1,101);
        vec7=zeros(1,101);
        vec8=zeros(1,101);
        REF = kOpenPort;
    end
    % UIWAIT makes kPlotAmb wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

%----------------------------------------------------------------

% --- Outputs from this function are returned to the command line.
function varargout = kPlotAmb_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
% --- Executes on button press in plot_pushbutton.
function plot_pushbutton_Callback(hObject, eventdata, handles, varargin)
    % hObject    handle to plot_pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global REF GO;
    global y1 y2 y3 y4 y5 y6 y7 y8;
    global vec1 vec2 vec3 vec4 vec5 vec6 vec7 vec8;
    
    wert = 504;
    
    GO = 1;
    z=0:0.01:1;
    while(GO)
        %the function kAmbient.m gets the values of the ambient sensors
        sensVec=kAmbient(REF);
        vec1(1:100)=vec1(2:101);
        vec1(101)=sensVec(1)/wert;
        vec2(1:100)=vec2(2:101);
        vec2(101)=sensVec(2)/wert;
        vec3(1:100)=vec3(2:101);
        vec3(101)=sensVec(3)/wert;
        vec4(1:100)=vec4(2:101);
        vec4(101)=sensVec(4)/wert;
        vec5(1:100)=vec5(2:101);
        vec5(101)=sensVec(5)/wert;
        vec6(1:100)=vec6(2:101);
        vec6(101)=sensVec(6)/wert;
        vec7(1:100)=vec7(2:101);
        vec7(101)=sensVec(7)/wert;
        vec8(1:100)=vec8(2:101);
        vec8(101)=sensVec(8)/wert;
        drawnow;
        plot3(z,y1,vec1,z,y2,vec2,z,y3,vec3,z,y4,vec4,z,y5,vec5,z,y6,vec6,z,y7,vec7,z,y8,vec8);
        grid on;
        axis([0 1 0 8 0 1.1]);
        set(handles.axes1,'XTick',[]);
     end
   
%--------------------------------------------------------------------------

% --- Executes on button press in stop_pushbutton.
function stop_pushbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to stop_pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global REF GO;
    kDrive(0,0,REF);
    GO = 0;
  
%-----------------------------------------------------------------------

% --- Executes on button press in drive_pushbutton.
function drive_pushbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to drive_pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global REF VELL VELR;
    kDrive(VELL,VELR,REF);
    

%-----------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function velocity_left_popupmenu_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to velocity_left_popupmenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

%    set(hObject, 'Color', 'gray90');
%-------------------------------------------------------------------------

% --- Executes on selection change in velocity_left_popupmenu.
function velocity_left_popupmenu_Callback(hObject, eventdata, handles)
    % hObject    handle to velocity_left_popupmenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = get(hObject,'String') returns velocity_left_popupmenu contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from velocity_left_popupmenu
    global VELL;
    val = get(hObject,'Value');
    VELL = val-1;
    
%------------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function velocity_right_popupmenu_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to velocity_right_popupmenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

%    set(hObject, 'Color', 'gray90');
%--------------------------------------------------------------------------

% --- Executes on selection change in velocity_right_popupmenu.
function velocity_right_popupmenu_Callback(hObject, eventdata, handles)
    % hObject    handle to velocity_right_popupmenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hints: contents = get(hObject,'String') returns velocity_right_popupmenu contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from velocity_right_popupmenu
    global VELR;
    val = get(hObject,'Value');
    VELR = val-1;

%----------------------------------------------------------------------
    
% --- Executes on button press in close_pushbutton.
function close_pushbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to close_pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    global REF GO;
    GO=0;
    kDrive(0,0,REF);
    kclose(REF);
    delete(handles.figure1);
    
