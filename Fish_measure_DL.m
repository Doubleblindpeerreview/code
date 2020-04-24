function varargout = Fish_measure_DL(varargin)
% FISH_MEASURE_DL MATLAB code for Fish_measure_DL.fig
%      
% Last Modified by GUIDE v2.5 23-Apr-2020 17:29:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fish_measure_DL_OpeningFcn, ...
                   'gui_OutputFcn',  @Fish_measure_DL_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT
end

% --- Executes just before Fish_measure_DL is made visible.
function Fish_measure_DL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Fish_measure_DL (see VARARGIN)

% Choose default command line output for Fish_measure_DL
handles.output = hObject;


Trainednetwork=load('trainingmask-crop-8-300.mat');
%Trainednetwork=load('trainingmask-8-100.mat');
net=Trainednetwork.net;
set(handles.Title,'userdata',net)

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Fish_measure_DL wait for user response (see UIRESUME)
% uiwait(handles.FM_background);
end

% --- Outputs from this function are returned to the command line.
function varargout = Fish_measure_DL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in openfile.

function openfile_Callback(hObject, eventdata, handles)
% hObject    handle to openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
video_file=uigetfile('*.avi'); 
I=VideoReader(video_file);
set(handles.n,'userdata',I); 
set(handles.filename,'String',video_file);

end

function n_Callback(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of n as text
%        str2double(get(hObject,'String')) returns contents of n as a double
I=get(handles.n,'userdata'); 
num=get(I,'numberOfFrames'); 
n=str2num(get(handles.n,'String'));


if n>num || n<1
    prompt=strcat('starting frame should be between 1-',num2str(num),',please re-enter');
    warndlg(prompt,'Warning');
    uiwait
end
a=read(I,n);
axes(handles.Crop_img)
imshow(a)
set(handles.crop_n,'String',get(handles.n,'String'))
end

% --- Executes on button press in nextfig.

function nextfig_Callback(hObject, eventdata, handles)
% hObject    handle to nextfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=get(handles.n,'userdata'); 
num=get(I,'numberOfFrames'); 
n=str2num(get(handles.crop_n,'String'));
n=n+1;
set(handles.crop_n,'String',num2str(n))

if n>num || n<1
    prompt=strcat('starting frame should be between 1-',num2str(num),',please re-enter');
    warndlg(prompt,'Warnig');
    uiwait
end

a=read(I,n);
axes(handles.Crop_img)
imshow(a)
end

% --- Executes on button press in lastfig.

function lastfig_Callback(hObject, eventdata, handles)
% hObject    handle to lastfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=get(handles.n,'userdata'); 
num=get(I,'numberOfFrames');
n=str2num(get(handles.crop_n,'String'));
n=n-1;
set(handles.crop_n,'String',num2str(n))

if n>num || n<1
    prompt=strcat('starting frame should be between 1-',num2str(num),',please re-enter');
    warndlg(prompt,'Warning');
    uiwait
end

a=read(I,n);
axes(handles.Crop_img)
imshow(a)
end

% --- Executes on button press in crop_button.

function crop_button_Callback(hObject, eventdata, handles)
% hObject    handle to crop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.current_n,'String',[]);

I=get(handles.n,'userdata'); 
num=get(I,'numberOfFrames'); 
n=str2num(get(handles.crop_n,'String'));


if n>num || n<1
    prompt=strcat('Please choose the frame between',num2str(num));
    warndlg(prompt,'Warning');
    uiwait
end

a=read(I,n);
figure(1);
[temp, rect] = imcrop(a);
close 1

set(handles.rec_Original,'String',strcat('[',num2str(rect(1)),',',num2str(rect(2)),']'));
set(handles.rec_Width,'String',num2str(rect(3)));
set(handles.rec_Height,'String',num2str(rect(4)));

set(handles.rec_Original,'userdata',temp);
set(handles.rec_Width,'userdata',rect);

axes(handles.Crop_img)
title('Original picture')
imshow(temp)
end


function bw_thre_Callback(hObject, eventdata, handles)
% hObject    handle to bw_thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of bw_thre as text
%        str2double(get(hObject,'String')) returns contents of bw_thre as a double
set(handles.bw_thre,'userdata',[]);
set(handles.show_thre,'String',get(handles.bw_thre,'value')); 
temp=get(handles.rec_Original,'userdata');
rect=get(handles.rec_Width,'userdata');

switch get(handles.method_choice,'value')
    case 1
    
        bw_thre=get(handles.bw_thre,'value');
        bw=abs(1-im2bw(temp,bw_thre));
        set(handles.bw_thre,'userdata',temp);
    case 2
    %Deep Learning
        ld_img=zeros(600,400,3);
%         ld_img=zeros(720,960,3);
        h=ceil((600-ceil(rect(4)))/2);
        w=ceil((400-ceil(rect(3)))/2);
%         h=ceil((720-ceil(rect(4)))/2);
%         w=ceil((960-ceil(rect(3)))/2);
        ld_img(h:h-1+ceil(rect(4)),w:w-1+ceil(rect(3)),:)=temp;
        temp=uint8(ld_img);
        set(handles.bw_thre,'userdata',temp);
        
        net=get(handles.Title,'userdata');
        C=semanticseg(temp,net);
        bw = (C=='foreground');
end

axes(handles.bw_img)
title('binary picture')
imshow(bw)

remove=str2num(get(handles.remove,'String'));
se=strel('disk',2);
openbw=imclose(bw,se);
% openbw=abs(1-openbw);
BW = bwareaopen(openbw,remove);

skeletonizedImage = bwmorph(BW, 'skel', inf);
remtimes=str2num(get(handles.remtimes,'String'));
BW1 = bwmorph(skeletonizedImage,'spur',remtimes); 
% BW2 = bwmorph(BW1,'diag'); 
[x11,y11]=find(BW1==1);

axes(handles.open_img)
imshow(BW)
hold on
plot(y11,x11,'r.') 
hold off
set(handles.bas_point,'userdata',[x11,y11]);

BW3 = bwmorph(BW1,'endpoint');
[x111,y111]=find(BW3==1);
axes(handles.Crop_img)
imshow(temp);
hold on
plot(y111,x111,'r.')
hold off
end

% --- Executes on button press in contitest_button.

function contitest_button_Callback(hObject, eventdata, handles)
% hObject    handle to contitest_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

bas_rate=str2num(get(handles.bas_point,'String'));
test_time=str2double(get(handles.test_time,'String'));
I=get(handles.n,'userdata');
n=str2num(get(handles.crop_n,'String'));
rec_Original=str2num(get(handles.rec_Original,'String'));


start_time=n/I.FrameRate;
if (test_time+start_time)>I.duration
    prompt=strcat('starting time',num2str(start_time),'s + testing duration > the total length of video',num2str(I.duration),'s, please re-enter');
    warndlg(prompt,'Warning');
    uiwait
end

test_frames=fix(test_time*I.FrameRate);


fir_pot=zeros(test_frames+1,2);
COM_pot=zeros(test_frames+1,2);
ang=zeros(test_frames+1,1);

rect=get(handles.rec_Width,'userdata'); %%
remove=str2num(get(handles.remove,'String'));
remtimes=str2num(get(handles.remtimes,'String'));

for i=n:n+test_frames
    set(handles.current_n,'String',num2str(i))
    a=read(I,i);
    temp=imcrop(a,rect);
    
    switch get(handles.method_choice,'value')
        case 1
            bw_thre=get(handles.bw_thre,'value');
            
            [fir_pot((i-n+1),1:2),basline]=calcu_distang(temp,bw_thre,remove,remtimes,bas_rate);
            
            x11=basline(:,1);
            y11=basline(:,2);
            bas_point=fix(0.01*bas_rate*size(basline,1));
            axes(handles.Crop_img)
            imshow(temp,[],'parent',gca)
            hold on
            plot(y11,x11,'r.')
            plot(y11(1:bas_point),x11(1:bas_point),'bx')
            plot(fir_pot(i-n+1,2),fir_pot(i-n+1,1),'yx')
            COM_pot(i-n+1,1:2)=ginput(1);
            plot(COM_pot(i-n+1,1),COM_pot(i-n+1,2),'gx')
            hold off
            ang(i-n+1)=atan((fir_pot(i-n+1,1)-COM_pot(i-n+1,2))/(fir_pot(i-n+1,2)-COM_pot(i-n+1,1)))*180/pi;
            ang(ang<0)=ang(ang<0)+180;
        case 2
            ld_img=zeros(600,400,3);
%             ld_img=zeros(720,960,3);
            h=ceil((600-ceil(rect(4)))/2);%
            w=ceil((400-ceil(rect(3)))/2);%
%             h=ceil((720-ceil(rect(4)))/2);%
%             w=ceil((960-ceil(rect(3)))/2);
            ld_img(h:h-1+ceil(rect(4)),w:w-1+ceil(rect(3)),:)=temp;
            temp=uint8(ld_img);
            net=get(handles.Title,'userdata');
            
            [pot1,basline]=calcu_distang_dl(temp,net,remove,remtimes,bas_rate);
            fir_pot((i-n+1),1:2)=pot1+fliplr(rec_Original);
           
            x11=basline(:,1);
            y11=basline(:,2);
            bas_point=fix(0.01*bas_rate*size(basline,1));
            axes(handles.Crop_img)
            imshow(temp,[],'parent',gca)
            hold on
            plot(y11,x11,'r.')
            plot(y11(1:bas_point),x11(1:bas_point),'bx')
            plot(pot1(2),pot1(1),'yx')
            COM_pot1=ginput(1); 
            plot(COM_pot1(1),COM_pot1(2),'gx')
            COM_pot(i-n+1,1:2)=COM_pot1+rec_Original;
            hold off
            ang(i-n+1)=atan((fir_pot(i-n+1,1)-COM_pot(i-n+1,2))/(fir_pot(i-n+1,2)-COM_pot(i-n+1,1)))*180/pi;
            ang(ang<0)=ang(ang<0)+180;
    end
    
end
COM_vel=sqrt(sum(diff(COM_pot).^2,2));

set(handles.filename,'userdata',COM_vel)
set(handles.show_thre,'userdata',ang)
set(handles.test_time,'userdata',COM_pot)
% set(handles.avel_s2_90,'userdata',TBamp_Nsum);
end

% --- Executes on button press in export_data.

function export_data_Callback(hObject, eventdata, handles)
% hObject    handle to export_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exp_name=string(inputdlg('Please enter the name of the export file','Name the export file',[1 50]));
xlstitle='COM'+string(['x';'y']);
COM_pot=get(handles.test_time,'userdata');
xlswrite(exp_name,xlstitle','COM coordinate','A1')
xlswrite(exp_name,COM_pot,'COM coordinate','A2')
xlstitle='COM'+string(['vel';'ang']);
COM_vel=get(handles.filename,'userdata');
COM_ang=get(handles.show_thre,'userdata');
xlswrite(exp_name,xlstitle','COM speed and angular speed','A1')
xlswrite(exp_name,COM_vel,'COM speed and angular speed','A2')
xlswrite(exp_name,COM_ang,'COM speed and angular speed','B2')
helpdlg('Data exported','Export completion reminder')
end

%-------------------------------------------------------------------------%

% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','grey');
end
end

% --- Executes on selection change in species.
function species_Callback(hObject, eventdata, handles)
% hObject    handle to species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns species contents as cell array
%        contents{get(hObject,'Value')} returns selected item from species
end

% --- Executes during object creation, after setting all properties.
function species_CreateFcn(hObject, eventdata, handles)
% hObject    handle to species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function bw_thre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw_thre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function bas_point_Callback(hObject, eventdata, handles)
% hObject    handle to bas_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of bas_point as text
%        str2double(get(hObject,'String')) returns contents of bas_point as a double
end

% --- Executes during object creation, after setting all properties.
function bas_point_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bas_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function test_time_Callback(hObject, eventdata, handles)
% hObject    handle to test_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of test_time as text
%        str2double(get(hObject,'String')) returns contents of test_time as a double
end

% --- Executes during object creation, after setting all properties.
function test_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of remtimes as text
%        str2double(get(hObject,'String')) returns contents of remtimes as a double
end

% --- Executes during object creation, after setting all properties.
function remove_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function remtimes_Callback(hObject, eventdata, handles)
% hObject    handle to remtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of remtimes as text
%        str2double(get(hObject,'String')) returns contents of remtimes as a double
end

% --- Executes during object creation, after setting all properties.
function remtimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function FM_background_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fishnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
end


% --- Executes on selection change in method_choice.
function method_choice_Callback(hObject, eventdata, handles)
% hObject    handle to method_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method_choice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method_choice
switch get(handles.method_choice,'value')
    case 1
        set(handles.bw_thre,'style','slider')
        set(handles.show_thre,'visible','on')
    case 2
        set(handles.bw_thre,'style','pushbutton')
        set(handles.bw_thre,'String','Process Preview')
        set(handles.show_thre,'visible','off')
end
end

% --- Executes during object creation, after setting all properties.
function method_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
