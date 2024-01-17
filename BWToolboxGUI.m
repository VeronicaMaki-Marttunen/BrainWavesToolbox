function createToolboxGUI()

addpath('\pathto\inpaint_nans')
addpath('\pathto\BWtoolbox')
addpath('\pathto\fieldtrip')

ft_defaults;

% Create the figure
fig = figure('Name', 'My Toolbox', 'NumberTitle', 'off', 'Position', [100, 100, 500, 400]);

% Initialize data structure
handles = struct;
guidata(fig, handles);

%% Principal gradient

% Add a text label
uicontrol('Style', 'text', 'String', 'Brain Waves Toolbox', ...
    'Position', [20, 380, 200, 20], 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');


% Button to load path to images in BIDS format
uicontrol('Style', 'pushbutton', 'String', 'Load Path to Files...', ...
    'Position', [20, 320, 100, 30], 'Callback', @loadImagesCallback);
% Button to load path to output
uicontrol('Style', 'pushbutton', 'String', 'Load Output Folder...', ...
    'Position', [150, 320, 100, 30], 'Callback', @loadOutputCallback);



%     % Dropdown menus
%     uicontrol('Style', 'popupmenu', 'String', {'Option1', 'Option2', 'Option3'}, ...
%         'Position', [140, 350, 100, 30]);
%     uicontrol('Style', 'popupmenu', 'String', {'OptionA', 'OptionB', 'OptionC'}, ...
%         'Position', [260, 350, 100, 30]);
%
%     % Numeric input fields
%     uicontrol('Style', 'edit', 'Position', [380, 350, 100, 30]);
%     uicontrol('Style', 'edit', 'Position', [380, 310, 100, 30]);

%     % Option buttons
%     uicontrol('Style', 'pushbutton', 'String', 'Option 1', ...
%         'Position', [20, 310, 100, 30], 'Callback', @option1Callback);
%     uicontrol('Style', 'pushbutton', 'String', 'Option 2', ...
%         'Position', [20, 270, 100, 30], 'Callback', @option2Callback);

% %     Add a text label
% uicontrol('Style', 'text', 'String', 'Principal Gradient', ...
%     'Position', [20, 280, 150, 20], 'FontSize', 10,  'HorizontalAlignment', 'left');%'FontAngle', 'italic',

% Editable Text Box
%uicontrol('Style', 'edit', 'Position', [20, 240, 150, 20], 'Tag', 'textInput');

% % Button to Process Text
% uicontrol('Style', 'pushbutton', 'String', 'Process Text', ...
%     'Position', [180, 240, 100, 30], 'Callback', @processTextCallback);
%
% % Editable Text Box for Number Input
% uicontrol('Style', 'edit', 'Position', [20, 210, 150, 20], 'Tag', 'numberInput');
%
% % Button to Process Number Input
% uicontrol('Style', 'pushbutton', 'String', 'Process Numbers', ...
%     'Position', [180, 210, 100, 30], 'Callback', @processNumberInputCallback);

% Add label and text box for "Number of Sessions"
uicontrol('Style', 'text', 'String', 'Number of Sessions:', ...
    'Position', [20, 260, 120, 20], 'HorizontalAlignment', 'right');
uicontrol('Style', 'edit', 'Position', [150, 260, 100, 20], 'Tag', 'numSessionsInput', 'Callback', @myCallbackFunction);


% Add label and text box for Task Input
uicontrol('Style', 'text', 'String', 'Tasks:', ...
    'Position', [20, 230, 120, 20], 'HorizontalAlignment', 'right');
uicontrol('Style', 'edit', 'Position', [150, 230, 100, 20], 'Tag', 'taskInput', 'Callback', @myCallbackFunction);

% Add label and text box for Vector Input (Subjects)
uicontrol('Style', 'text', 'String', 'Subjects number:', ...
    'Position', [20, 200, 120, 20], 'HorizontalAlignment', 'right');
uicontrol('Style', 'edit', 'Position', [150, 200, 100, 20], 'Tag', 'subjsInput', 'Callback', @myCallbackFunction);


% % Use folder path
%
% handles = guidata(fig); % 'fig' is the handle to your figure
% if isfield(handles, 'folder_path')
%     folder_path = handles.folder_path;
%     % Now you can use folder_path as needed
%     disp(folder_path)
% else
%     disp('Folder path not yet set.');
% end

uicontrol('Style', 'pushbutton', 'String', 'Run SVD', ...
    'Position', [300, 210, 80, 80], 'Callback', @callOtherFileFunction);


%% Brain Waves

%     Add a text label
%uicontrol('Style', 'text', 'String', 'Brain Waves', ...
%    'Position', [20, 150, 150, 20], 'FontSize', 10,  'HorizontalAlignment', 'left');%'FontAngle', 'italic',

% Add label and text box for Vector Input (Subjects)
uicontrol('Style', 'text', 'String', 'Number of bins:', ...
    'Position', [20, 90, 120, 20], 'HorizontalAlignment', 'right');
uicontrol('Style', 'edit', 'Position', [150, 90, 100, 20], 'Tag', 'binsInput', 'Callback', @myCallbackFunction);

uicontrol('Style', 'text', 'String', 'Output images?', ...
    'Position', [20, 60, 120, 20], 'HorizontalAlignment', 'right');
uicontrol('Style', 'popupmenu', 'String', {'N', 'Y'}, ...
    'Position', [150, 50, 100, 30], 'Callback', @dropdownCallback);

uicontrol('Style', 'pushbutton', 'String', 'Load Principal Gradient...', ...
    'Position', [150, 120, 120, 30], 'Callback', @loadPDCallback);

uicontrol('Style', 'pushbutton', 'String', 'Run Brain Waves', ...
    'Position', [300, 60, 80, 80], 'Callback', @callOtherFileFunction2);

%% Callback functions

    function loadImagesCallback(src, event)
        % Access handles structure
        handles = guidata(src);

        % Open folder selection dialog
        folder_path = uigetdir;

        % Check if the user selected a folder
        if folder_path == 0
            disp('User pressed cancel');
        else
            % Save the folder path in handles
            handles.folder_path = folder_path;
            guidata(src, handles);

            disp(['Selected folder path: ', folder_path]);
        end
    end

    function loadOutputCallback(src, event)
        % Access handles structure
        handles = guidata(src);

        % Open folder selection dialog
        folder_path = uigetdir;

        % Check if the user selected a folder
        if folder_path == 0
            disp('User pressed cancel');
        else
            % Save the folder path in handles
            handles.output_path = folder_path;
            guidata(src, handles);

            disp(['Selected output folder: ', folder_path]);
        end
    end

    function loadPDCallback(src, event)
        % Access handles structure
        handles = guidata(src);

        [filename, pathname] = uigetfile({'*.nii','Image Files (*.nii)'}, 'Select an Image');


        % Full path of the file
        fullPath = fullfile(pathname, filename);

        handles.PDpath = fullPath;
        guidata(src, handles);
    end

    function myCallbackFunction(src, ~)

        % Retrieve the handles structure
        handles = guidata(src);
        tag = get(src, 'Tag');

        switch tag
            case 'numSessionsInput'


                % Retrieve the values from the text boxes
                numSessionsInputHandle = findobj('Tag', 'numSessionsInput');
                handles.numSessions = str2double(get(numSessionsInputHandle, 'String'));

            case 'taskInput'
                % Retrieve the String input
                textInputHandle = findobj('Tag', 'taskInput');
                inputText = get(textInputHandle, 'String');

                % Process the String input
                % Split the inputText at commas and trim spaces
                cellArray = strtrim(split(inputText, ','));

                %     % Store the cell array in handles structure for later use
                handles.tasks = cellArray;
            case 'subjsInput'
                % Retrieve the Vector input
    % Retrieve the input string from the text box
    subjsInputHandle = findobj('Tag', 'subjsInput');
    inputStr = get(subjsInputHandle, 'String');

    % Parse and convert the input string
    if contains(inputStr, ':') || contains(inputStr, ',')
        % Handle colon notation and comma-separated list
        try
            subjects = eval(['[', inputStr, ']']);  % Convert to vector
        catch
            disp('Invalid input format');
            return;
        end
    else
        % Handle single number
        subjects = str2double(inputStr);
        if isnan(subjects)
            disp('Invalid input format');
            return;
        end
    end
    handles.subjects = subjects;
            case 'binsInput'
                vectorInputHandle = findobj('Tag', 'binsInput');
                vectorInputText = get(vectorInputHandle, 'String');

                % Convert the Vector input text to a numeric vector
                numberVector = str2num(vectorInputText);



                %     % Store the number vector in handles structure for later use
                handles.bins = numberVector;
                %
        end
        % Save the updated handles structure
        guidata(src, handles);
    end

function dropdownCallback(src, ~)
    handles = guidata(src);  % Retrieve the handles structure
    selectedValue = get(src, 'Value');  % Get the selected value (index)
    selectedString = get(src, 'String');  % Get the list of options
    selectedOption = selectedString{selectedValue};  % Get the selected option string

    % Store the selected option in handles structure
    handles.dropdownSelection = selectedOption;

    % Save the updated handles structure
    guidata(src, handles);
end


    function callOtherFileFunction(src, ~)
        % Retrieve the shared data
        handles = guidata(src);

        % Use the numberVector
        handles
        if isfield(handles, 'folder_path')  && isfield(handles, 'numSessions') && isfield(handles, 'output_path') && isfield(handles, 'subjects')  && isfield(handles, 'tasks')
            folderpath = handles.folder_path;
            outputpath = handles.output_path;
            nSess = handles.numSessions;
            subjects = handles.subjects;
            tasks = handles.tasks;

            % Call the function from otherfile.m
            BWT_runSVD(folderpath,outputpath,nSess,subjects,tasks); % Assuming the function name is 'otherfile' and takes one argument
        else
            disp('Please enter all input values.');
        end
    end

    function callOtherFileFunction2(src, ~)
        % Retrieve the shared data
        handles = guidata(src);

        % Use the numberVector
        handles
        if isfield(handles, 'folder_path')  && isfield(handles, 'numSessions') && isfield(handles, 'output_path') && isfield(handles, 'subjects')  && isfield(handles, 'tasks') && isfield(handles, 'bins')
            folderpath = handles.folder_path;
            outputpath = handles.output_path;
            nSess = handles.numSessions;
            subjects = handles.subjects;
            tasks = handles.tasks;
            nbins = handles.bins;
            PDpath = handles.PDpath;
            imout= handles.dropdownSelection; %wants images?

            % Call the function from otherfile.m
            BWT_runBW(folderpath,PDpath,outputpath,nSess,subjects,tasks,nbins,imout); % Assuming the function name is 'otherfile' and takes one argument
        else
            disp('Please enter all input values.');
        end
    end

end
