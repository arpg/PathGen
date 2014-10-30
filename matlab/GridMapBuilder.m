classdef GridMapBuilder < MapBuilder

    properties (Access = private)
        height;
        width;
        gridSize;
        offset;
    end

    methods (Access = public)
        function this = GridMapBuilder()
            this.height = 1;
            this.width  = 1;
            this.gridSize = 10;
            this.offset = [ 0; 0; 0 ];
        end

        function height = getHeight(this)
            height = this.height;
        end

        function setHeight(this, height)
            this.height = height;
        end

        function setWidth(this, width)
            this.width = width;
        end

        function width = getWidth(this)
            width = this.width;
        end

        function gridSize = getGridSize(this)
            gridSize = this.gridSize;
        end

        function setGridSize(this, gridSize)
            this.gridSize = gridSize;
        end

        function offset = getOffset(this)
            offset = this.offset;
        end

        function setOffset(this, offset)
            this.offset = offset;
        end

        function map = build(this)
            map = 1;
        end
    end

end
