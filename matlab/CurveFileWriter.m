classdef (Abstract) CurveFileWriter < CurveWriter

    properties (Access = protected)
        directory;
        filename;
    end

    methods (Access = public)
        function this = CurveFileWriter()
            this.directory = '.';
            this.filename = 'curve';
        end

        function directory = getDirectory(this)
            directory = this.directory;
        end

        function setDirectory(this, directory)
            this.directory = directory;
        end

        function filename = getFileName(this)
            filename = this.filename;
        end

        function setFileName(this, filename)
            this.filename = filename;
        end

        function filePath = getFilePath(this)
            filePath = strcat(this.directory, '/', this.filename);
        end

        function write(this, curve)
            this.createDirectory();
            this.writeFile(curve);
        end
    end

    methods (Access = protected, Abstract)
        writeFile(this, curve);
    end

    methods (Access = protected)
        function createDirectory(this)
            % create directory if needed
            if ~exist(this.directory, 'dir')
                mkdir(this.directory);
            end
        end
    end

end
