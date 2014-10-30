classdef GroupCurveWriter < CurveWriter

    properties (Access = private)
        writers;
    end

    methods (Access = public)
        function this = GroupCurveWriter()
            this.writers = [];
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

        function write(this, curve)
            count = this.getWriterCount();

            for i = 1 : count
                this.writers.write(curve);
            end
        end
    end

end
