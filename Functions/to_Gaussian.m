function  to_Gaussian(folder_path_input, folder_path_output)
% Get a list of all the txt files in the folder
txt_files = dir(fullfile(folder_path_input, '*.txt'));
numtxt = length(txt_files);
file_names = cell(numtxt, 1);

% Loop over the txt files
for file_idx = 1:numel(txt_files)
 
    % Get the filename of the current file
    filename = txt_files(file_idx).name;
 
    % Store the filename
    file_names{file_idx} = filename;
    
    % Read the table from the current file
    filepath = fullfile(folder_path_input, filename);
    A = readtable(filepath);

    L = height(A);
    h = 0;

    % Calculate the count of 'H' in the Var1 column
    for i = 1:L
        if isequal(A.Var1(i), {'H'})
            h = h + 1;
        end
    end

    filename = erase(filename, ".txt");
    output_filename = sprintf('%s.inp', filename);
    output_filename = strcat(folder_path_output,"/" ,output_filename);

    fileID = fopen(output_filename, 'w');

    fprintf(fileID, '%%chk=');
    fprintf(fileID, '%s.chk', filename);
    fprintf(fileID, '\n#P B3LYP/6-311G(d,p) Opt Freq(Raman)');
    fprintf(fileID, '\n');
    fprintf(fileID, '\n');
    fprintf(fileID, '%s', filename);
    fprintf(fileID, '\n');
    fprintf(fileID, '\n0');

    if (mod(h, 2) == 0)
        fprintf(fileID, ' 1');
    else
        fprintf(fileID, ' 2');
    end

    C = cellstr(A.Var1);

    for i = 1:height(A)
        fprintf(fileID, '\n%s %20f %20f %20f', C{i}, A.Var2(i), A.Var3(i), A.Var4(i));
    end
    
    fprintf(fileID, '\n');
    fprintf(fileID, '\n');
    fprintf(fileID, '\n');
    
    fclose(fileID);
end
end