% Generates the .mat files from the .m files in the config subdirectory
%
function generateMatFiles

    dir_list = {'config'};
    while numel(dir_list) > 0
        current_dir = dir_list{end};
        dir_list(end) = [];
        
        files = dir(current_dir);
        for i = 1:numel(files)
            filename = fullfile(current_dir, files(i).name);
            if ~files(i).isdir
                [~, ~, ext] = fileparts(files(i).name);
                if strcmpi(ext, '.m')
                    generateFile(filename);
                end
            elseif  ~strcmp(files(i).name, '.') && ...
                    ~strcmp(files(i).name, '..')
                dir_list{end+1} = filename;
            end
        end
    end
    
function generateFile(filename)
    lines = importdata(filename);
    for i = 1:numel(lines)
        eval(lines{i})
    end