%% Clear the output folder
function deleteAllElementsInFolder(folder_path)

% Check if the folder exists
if exist(folder_path, 'dir') ~= 7
    error('Folder does not exist.');
end

% List all elements (files and subfolders) in the folder
elements = dir(folder_path);

% Loop through each element in the folder
for i = 1:length(elements)
    element_name = elements(i).name;
    
    % Ignore "." and ".." entries (current folder and parent folder)
    if ~strcmp(element_name, '.') && ~strcmp(element_name, '..')
        element_path = fullfile(folder_path, element_name);
        
        if elements(i).isdir
            % If it's a subfolder, recursively delete its contents
            rmdir(element_path, 's');
        else
            % If it's a file, delete the file
            delete(element_path);
        end
    end
end
end