function varargout = recognition_experiment(varargin)
% RECOGNITION_EXPERIMENT MATLAB code for recognition_experiment.fig
%      RECOGNITION_EXPERIMENT, by itself, creates a new RECOGNITION_EXPERIMENT or raises the existing
%      singleton*.
%
%      H = RECOGNITION_EXPERIMENT returns the handle to a new RECOGNITION_EXPERIMENT or the handle to
%      the existing singleton*.
%
%      RECOGNITION_EXPERIMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECOGNITION_EXPERIMENT.M with the given input arguments.
%
%      RECOGNITION_EXPERIMENT('Property','Value',...) creates a new RECOGNITION_EXPERIMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recognition_experiment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recognition_experiment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recognition_experiment

% Last Modified by GUIDE v2.5 30-Apr-2015 08:26:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recognition_experiment_OpeningFcn, ...
                   'gui_OutputFcn',  @recognition_experiment_OutputFcn, ...
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


% --- Executes just before recognition_experiment is made visible.
function recognitio n_experiment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recognition_experiment (see VARARGIN)

% Choose default command line output for recognition_experiment
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

testing_path = 'testing\';
testing_list =  dir([testing_path '*jpg']);
global n_images;


sketch_path = 'warped_images3\';
sketch_list = dir([sketch_path '*jpg']);

n_images = size(sketch_list, 1);

%Global variables
global testing_data; %synthesized sketches
testing_data = cell(100);

global sketch_data; %proper sketches
sketch_data = cell(n_images);

global counter;
counter = 1;

global score; 


global correct;
correct = randi(8,1,40);
if (counter ~=1)
    s = ['The final score is: ' num2str(score)];
    disp(s);
    clear;
else
    
    score = 0;
    for j=1:100
           j
           filename = [testing_path 'I_B_' num2str(j) '.jpg'];
           X = double(imread(filename))./255;
           testing_data{j} = X;
    end

    for j=1:n_images
           j
           filename = [sketch_path 'image_' num2str(j) '.jpg'];;
           X = double(imread(filename))./255;
           sketch_data{j} = X;
    end
    indices = generate_indices(n_images); 
    text = ['Image ' num2str(counter) ' of 10'];  
    set(handles.text2, 'String', text);

    imshow(testing_data{counter},'Parent', handles.axes1);
    imh1 = imshow(sketch_data{indices(1)},'Parent', handles.axes2);
    imh2 = imshow(sketch_data{indices(2)},'Parent', handles.axes3);
    imh3 = imshow(sketch_data{indices(3)},'Parent', handles.axes4);
    imh4 = imshow(sketch_data{indices(4)},'Parent', handles.axes5);
    imh5 = imshow(sketch_data{indices(5)},'Parent', handles.axes6);
    imh6 = imshow(sketch_data{indices(6)},'Parent', handles.axes7);
    imh7 = imshow(sketch_data{indices(7)},'Parent', handles.axes8);
    imh8 = imshow(sketch_data{indices(8)},'Parent', handles.axes9);

    set([imh1, imh2, imh3, imh4, imh5, imh6, imh7, imh8], 'buttondownfcn', @choose_image);
end

function index = generate_indices(n_images)
    index = randi(n_images,1,8);
    global correct;
    global counter;
    answer = correct(counter);
    
    while (length(unique(index))<8 || ismember(counter, index))
        index = randi(n_images,1,8);
    end
    index(answer) = counter;
    
function choose_image(hObject, eventdata)
  global sketch_data;
  global testing_data;
  global counter;
  global n_images;
  global correct;
  global score;
   
  correct_ans = correct(counter);
  
  counter = counter +1;
  
  handles = guidata(hObject);
  theaxes = ancestor(hObject,'axes');
  
  if theaxes == handles.axes2
    selected = 1;
  elseif theaxes == handles.axes3
    selected = 2;
  elseif theaxes == handles.axes4
    selected = 3;
  elseif theaxes == handles.axes5
    selected = 4;
  elseif theaxes == handles.axes6
    selected = 5;
  elseif theaxes == handles.axes7
    selected = 6;
  elseif theaxes == handles.axes8
    selected = 7;
  elseif theaxes == handles.axes9
    selected = 8;
  end
  
  if (selected == correct_ans)
      score = score +1;
      disp('score!');
  end
  
  indices = generate_indices(n_images); 
  text = ['Image ' num2str(counter) ' of 10'];  
  set(handles.text2, 'String', text);
  imshow(testing_data{counter},'Parent', handles.axes1);

  imh1 = imshow(sketch_data{indices(1)},'Parent', handles.axes2);
  imh2 = imshow(sketch_data{indices(2)},'Parent', handles.axes3);
  imh3 = imshow(sketch_data{indices(3)},'Parent', handles.axes4);
  imh4 = imshow(sketch_data{indices(4)},'Parent', handles.axes5);
  imh5 = imshow(sketch_data{indices(5)},'Parent', handles.axes6);
  imh6 = imshow(sketch_data{indices(6)},'Parent', handles.axes7);
  imh7 = imshow(sketch_data{indices(7)},'Parent', handles.axes8);
  imh8 = imshow(sketch_data{indices(8)},'Parent', handles.axes9);

  set([imh1, imh2, imh3, imh4, imh5, imh6, imh7, imh8], 'buttondownfcn', @choose_image);

  if (counter == 10)
    disp(num2str(score));
    close(recognition_experiment);
  end
    
   


% --- Outputs from this function are returned to the command line.
function varargout = recognition_experiment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes7_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes8_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes9_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
