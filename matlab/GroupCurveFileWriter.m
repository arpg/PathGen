classdef GroupCurveFileWriter < CurveFileWriter

    properties (Access = private)
        writers;
        digits;
        index;
    end

    methods (Access = public)
        function this = GroupCurveFileWriter()
            this.writers = [];
            this.index = 1;
            this.digits = 2;
        end

        function digits = getDirectoryDigits(this)
            digits = this.digits;
        end

        function setDirectoryDigits(this, digits)
            this.digits = digits;
        end

        function index = getWriteIndex(this)
            index = this.index;
        end

        function setWriteIndex(this, index)
            this.index = index;
        end

        function count = getWriterCount(this)
            count = length(this.writers);
        end

        function writer = getWriter(this, index)
            writer = this.writers(index);
        end

        function addWriter(this, writer)
            this.writers = [ this.writers writer ];
        end
    end

    methods (Access = protected)
        function writeFile(this, curve)
            dirname = this.getNextDirectory();
            count = this.getWriterCount();

            % invoke each writer in group
            for i = 1 : count
                this.writers(i).setDirectory(dirname);
                this.writers(i).write(curve);
            end
        end

        function dirname = getNextDirectory(this)
            maxDigits = max(this.digits, ceil(log(this.index) / log(10)));
            format = sprintf('%%s/path%%0%dd', maxDigits);
            dirname = sprintf(format, this.directory, this.index);
            this.index = this.index + 1;
        end
    end

end
