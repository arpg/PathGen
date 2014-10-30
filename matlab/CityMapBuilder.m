classdef CityMapBuilder < handle
    
    properties (Access = private)
        % user-assigned
        height;
        width;
        offset;
        blockSize;
        streetSize;
        crossRatio;
        
        % auto-assigned
        gridSize;
        totalHeight;
        totalWidth;
        totalNodes;
        inCrossSize;
        exCrossSize;
        innerShift;
        cornersPerColumn;
        verCrossesPerColumn;
        horCrossesPerColumn;
        verCrossTop;
        horCrossTop;
    end
    
    methods (Access = public)
        function this = CityMapBuilder()
            this.height = 1;
            this.width  = 1;
            this.blockSize  = 16;
            this.streetSize = 4;
            this.crossRatio = 0.5;
            this.offset = [ 0; 0; 0 ];
            this.updateMapSpecs();
        end

        function height = getHeight(this)
            height = this.height;
        end

        function setHeight(this, height)
            this.height = height;
            this.updateMapSpecs();
        end

        function width = getWidth(this)
            width = this.width;
        end

        function setWidth(this, width)
            this.width = width;
            this.updateMapSpecs();
        end

        function offset = getOffset(this)
            offset = this.offset;
        end

        function setOffset(this, offset)
            this.offset = offset;
            this.updateMapSpecs();
        end

        function blockSize = getBlockSize(this)
            blockSize = this.blockSize;
        end

        function setBlockSize(this, blockSize)
            this.blockSize = blockSize;
            this.updateMapSpecs();
        end

        function streetSize = getStreetSize(this)
            streetSize = this.streetSize;
        end

        function setStreetSize(this, streetSize)
            this.streetSize = streetSize;
            this.updateMapSpecs();
        end

        function crossRatio = getCrossRatio(this)
            crossRatio = this.crossRatio;
        end

        function setCrossRatio(this, crossRatio)
            crossRatio = max(min(1.0, crossRatio), 0.1);
            this.crossRatio = crossRatio;
            this.updateMapSpecs();
        end
        
        function indices = getCornerIndices(this)
            indices = 1 : this.verCrossTop - 1;
        end
        
        function map = build(this)
            map = Map(this.totalNodes);
            this.addCornerNodes(map);
            this.addCornerLinks(map);
            this.addVerticalCrossNodes(map);
            this.addVerticalCrossLinks(map);
            this.addHorizontalCrossNodes(map);
            this.addHorizontalCrossLinks(map);
            
            shift = repmat(this.offset, 1, this.totalNodes);
            map.nodes = map.nodes + shift;
        end
    end
    
    methods (Access = private)
        function addCornerNodes(this, map)
            % calc start position
            x = -this.totalWidth / 2 - this.streetSize / 4;
            
            % add first column
            this.addCornerColumn(map, x, 1);
            
            % increment position
            x = x + this.streetSize / 2;
            index = this.cornersPerColumn + 1;
            
            %add internal columns
            for i = 1 : this.width
                % add left block-column
                this.addCornerColumn(map, x, index);
                
                % increment position
                x = x + this.innerShift;
                index = index + this.cornersPerColumn;
                
                % add right block-column
                this.addCornerColumn(map, x, index);
                
                % increment position
                x = x + this.streetSize / 2;
                index = index + this.cornersPerColumn;
            end
            
            % add last column
            this.addCornerColumn(map, x, index);
        end
        
        function addCornerColumn(this, map, x, index)
            % calc start position
            y = -this.totalHeight / 2 - this.streetSize / 4;

            % first corner
            map.nodes(:, index) = [ x; y; 0 ];

            % increment position
            y = y + this.streetSize / 2;
            index = index + 1;

            % add internal corners
            for j = 1 : this.height
                % bottom block-corner
                map.nodes(:, index) = [ x; y; 0 ];

                % increment position
                y = y + this.innerShift;
                index = index + 1;

                % top block-corner
                map.nodes(:, index) = [ x; y; 0 ];

                % increment position
                y = y + this.streetSize / 2;
                index = index + 1;
            end

            % last corner
            map.nodes(:, index) = [ x; y; 0 ];
        end
        
        function addCornerLinks(this, map)
            this.linkInternalCorners(map);
            this.linkExternalCorners(map);
        end
        
        function linkInternalCorners(this, map)
            % link each block column
            for x = 1 : this.width
                % link each block row
                for y = 1 : this.height
                    % link each corner in block
                    this.linkCorner(map, x, y, -1, -1);
                    this.linkCorner(map, x, y, -1,  1);
                    this.linkCorner(map, x, y,  1, -1);
                    this.linkCorner(map, x, y,  1,  1);
                end
            end
        end
        
        function linkCorner(this, map, col, row, x, y)
            % calc corner index
            ccol = 2 * col + (x - 1) / 2;
            crow = 2 * row + (y - 1) / 2;
            index = ccol * this.cornersPerColumn + crow + 1;
            
            % link node below
            map.linkSafe(index - 1, index);
            
            % link node above
            map.linkSafe(index + 1, index);
            
            % link node to left
            map.linkSafe(index - this.cornersPerColumn, index);
            
            % link node to right
            map.linkSafe(index + this.cornersPerColumn, index);
            
            % link diagonal intersection node
            map.linkSafe(index + x * this.cornersPerColumn + y, index);
        end
        
        function linkExternalCorners(this, map)
            right = this.verCrossTop - this.cornersPerColumn - 1;
            
            % link each external column node
            for y = 1 : this.cornersPerColumn - 1
                map.linkSafe(y, y + 1);
                map.linkSafe(right + y, right + y + 1);
            end
            
            top = this.cornersPerColumn - 1;
            
            % link each external row node
            for x = 1 : 2 * this.width + 1
                a = (x - 1) * this.cornersPerColumn + 1;
                b = a + this.cornersPerColumn;
                map.linkSafe(a, b);
                map.linkSafe(a + top, b + top);
            end
            
            % link bottom-left corners
            a = 2;
            b = this.cornersPerColumn + 1;
            map.linkSafe(a, b);
            
            % link top-left corners
            a = this.cornersPerColumn - 1;
            b = 2 * this.cornersPerColumn;
            map.linkSafe(a, b);
            
            % link bottom-right corners
            a = 2 * this.width * this.cornersPerColumn + 1;
            b = a + this.cornersPerColumn + 1;
            map.linkSafe(a, b);
            
            % link top-right corners
            a = (2 * this.width + 1) * this.cornersPerColumn;
            b = a + this.cornersPerColumn - 1;
            map.linkSafe(a, b);
        end
        
        function addVerticalCrossNodes(this, map)
            % calc start position
            x = -this.totalWidth / 2 - this.streetSize / 4;
            index = this.verCrossTop;
            
            for i = 1 : this.width + 1
                % add left street cross nodes
                this.addVerticalCrossColumn(map, x, index);
                
                % increment position
                x = x + this.streetSize / 2;
                index = index + this.verCrossesPerColumn;
                
                % add right street cross nodes
                this.addVerticalCrossColumn(map, x, index);
                
                % increment position
                x = x + this.innerShift;
                index = index + this.verCrossesPerColumn;
            end
        end
        
        function addVerticalCrossColumn(this, map, x, index)
            % calc start position
            y = -this.totalHeight / 2 + this.streetSize / 4 ...
                + this.exCrossSize;
            
            for i = 1 : this.height
                % add bottom cross node
                map.nodes(:, index) = [ x; y; 0 ];
                
                % increment step
                y = y + this.inCrossSize;
                index = index + 1;
                
                % add top cross node
                map.nodes(:, index) = [ x; y; 0 ];
                
                % increment step
                y = y + this.gridSize - this.inCrossSize;
                index = index + 1;
            end
        end
        
        function addVerticalCrossLinks(this, map)
            % link each cross column
            for x = 1 : this.width + 1
                % link each cross row
                for y = 1 : this.height
                    % link each cross corner
                    this.linkVerticalCross(map, x, y, -1, -1);
                    this.linkVerticalCross(map, x, y, -1,  1);
                    this.linkVerticalCross(map, x, y,  1, -1);
                    this.linkVerticalCross(map, x, y,  1,  1);
                end
            end
        end
        
        function linkVerticalCross(this, map, col, row, x, y)
            % calc cross index
            col = 2 * (col - 1) + (1 + x) / 2;
            row = 2 * row + (y - 1) / 2;
            verOffset = col * this.verCrossesPerColumn + row - 1;
            index = this.verCrossTop + verOffset;
            
            % link corner node
            corner = col * this.cornersPerColumn + row + 1;
            map.linkSafe(corner, index);
            
            % link diagonal cross node
            cross = index - x * this.verCrossesPerColumn - y;
            map.linkSafe(cross, index);
            
            % link orthogonal cross node
            map.linkSafe(index - y, index);
        end
        
        function addHorizontalCrossNodes(this, map)
            % calc start position
            x = -this.totalWidth / 2 + this.streetSize / 4 ...
                + this.exCrossSize;
            
            index = this.horCrossTop;
            
            for i = 1 : this.width
                % add left street cross nodes
                this.addHorizontalCrossColumn(map, x, index);
                
                % increment position
                x = x + this.inCrossSize;
                index = index + this.horCrossesPerColumn;
                
                % add right street cross nodes
                this.addHorizontalCrossColumn(map, x, index);
                
                % increment position
                x = x + this.gridSize - this.inCrossSize;
                index = index + this.horCrossesPerColumn;
            end
        end
        
        function addHorizontalCrossColumn(this, map, x, index)
            % calc start position
            y = -this.totalHeight / 2 - this.streetSize / 4;
            
            for i = 1 : this.height + 1
                % add bottom cross node
                map.nodes(:, index) = [ x; y; 0 ];
                
                % increment step
                y = y + this.streetSize / 2;
                index = index + 1;
                
                % add top cross node
                map.nodes(:, index) = [ x; y; 0 ];
                
                % increment step
                y = y + this.gridSize - this.streetSize / 2;
                index = index + 1;
            end
        end
        
        function addHorizontalCrossLinks(this, map)
            % link each cross column
            for x = 1 : this.width
                % link each cross row
                for y = 1 : this.height + 1
                    % link each cross corner
                    this.linkHorizontalCross(map, x, y, -1, -1);
                    this.linkHorizontalCross(map, x, y, -1,  1);
                    this.linkHorizontalCross(map, x, y,  1, -1);
                    this.linkHorizontalCross(map, x, y,  1,  1);
                end
            end
        end
        
        function linkHorizontalCross(this, map, col, row, x, y)
            % calc cross index
            col = 2 * (col - 1) + (1 + x) / 2;
            row = 2 * row + (y - 1) / 2;
            horOffset = col * this.horCrossesPerColumn + row - 1;
            index = this.horCrossTop + horOffset;
            
            % link corner node
            corner = (col + 1) * this.cornersPerColumn + row;
            map.linkSafe(corner, index);
            
            % link diagonal cross node
            cross = index - x * this.horCrossesPerColumn - y;
            map.linkSafe(cross, index);
            
            % link orthogonal cross node
            cross = index - x * this.horCrossesPerColumn;
            map.linkSafe(cross, index);
        end
        
        function link(this, map, a, b)
            try
                map.links(a, b) = 1;
                map.links(b, a) = 1;
            catch
            end
        end
        
        function updateMapSpecs(this)
            % convenience variables
            h = this.height;
            w = this.width;
            
            % calc map dimensions
            this.gridSize = this.blockSize + this.streetSize;
            this.totalHeight = h * this.gridSize;
            this.totalWidth  = w * this.gridSize;

            % calc total nodes
            cornerNodes = 4 * (h * (w + 1) + w + 1);
            verCrossNodes = 4 * h * (w + 1);
            horCrossNodes = 4 * w * (h + 1);
            crossNodes = verCrossNodes + horCrossNodes;
            this.totalNodes = cornerNodes + crossNodes;
            
            % calc start indices for cross nodes
            this.verCrossTop = cornerNodes + 1;
            this.horCrossTop = cornerNodes + verCrossNodes + 1;
            
            % calc helpful variables for node creation
            this.innerShift = this.blockSize + this.streetSize / 2;
            this.cornersPerColumn = 2 * this.height + 2;
            this.verCrossesPerColumn = 2 * this.height;
            this.horCrossesPerColumn = 2 * this.height + 2;
            
            % calc cross sizes
            this.inCrossSize = this.innerShift * this.crossRatio;
            this.exCrossSize = (this.innerShift - this.inCrossSize) / 2;
        end
    end
    
end
