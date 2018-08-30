function varargout = kPlotIR(varargin)
% KPlOTIR M-file for kPlotIR.fig
%      KPLOTIR, by itself, creates a new  KPLOTIR or raises the existing
%      singleton*.
%
%      H =  KPLOTIR returns the handle to a new  KPLOTIR or the handle to
%      the existing singleton*.
%
%      KPLOTIR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in  KPLOTIR.M with the given input arguments.
%
%      KPLOTIR('Property','Value',...) creates a new KPLOTIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kPlotIR_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kPlotIR_OpeningFcn via varargin.
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
                       'gui_OpeningFcn', @kPlotIR_OpeningFcn, ...
                       'gui_OutputFcn',  @kPlotIR_OutputFcn, ...
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

% --- Executes just before kPlotIR is made visible.
function kPlotIR_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to kPlotIR (see VARARGIN)
    global REF GO VELL VELR;
    global y1 y2 y3 y4 y5 y6 y7 y8;
    global vec1 vec2 vec3 vec4 vec5 vec6 vec7 vec8;
    % Choose default command line output for kPlotIR
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
    % UIWAIT makes kPlotIR wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

%----------------------------------------------------------------

% --- Outputs from this function are returned to the command line.
function varargout = kPlotIR_OutputFcn(hObject, eventdata, handles)
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
    
    
    GO = 1;
    z=0:0.01:1;
    while(GO)
        %the function kProximity.m gets the values of the proximity sensors
        sensVec=kProximity(REF);
        vec1(1:100)=vec1(2:101);
        vec1(101)=sensVec(1)/1023;
        vec2(1:100)=vec2(2:101);
        vec2(101)=sensVec(2)/1023;
        vec3(1:100)=vec3(2:101);
        vec3(101)=sensVec(3)/1023;
        vec4(1:100)=vec4(2:101);
        vec4(101)=sensVec(4)/1023;
        vec5(1:100)=vec5(2:101);
        vec5(101)=sensVec(5)/1023;
        vec6(1:100)=vec6(2:101);
        vec6(101)=sensVec(6)/1023;
        vec7(1:100)=vec7(2:101);
        vec7(101)=sensVec(7)/1023;
        vec8(1:100)=vec8(2:101);
        vec8(101)=sensVec(8)/1023;
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
    kSetSpeed(REF,0,0);
    GO = 0;
  
%-----------------------------------------------------------------------

% --- Executes on button press in drive_pushbutton.
function drive_pushbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to drive_pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global REF VELL VELR;
    kSetSpeed(REF,VELL,VELR);
    

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

    %set(hObject, 'Color', 'gray90');
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
    kSetSpeed(REF,0,0);
    kclose(REF);
    delete(handles.figure1);
    
