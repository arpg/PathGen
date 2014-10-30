classdef RandomClosedPathBuilder < MapPathBuilder

    properties (Access = private)
        randomBuilder;
        closureBuilder;
    end

    methods (Access = public)
        function this = RandomClosedPathBuilder()
        end

        function randomBuilder = getRandomPathBuilder(this)
            randomBuilder = this.randomBuilder;
        end

        function setRandomPathBuilder(this, randomBuilder)
            this.randomBuilder = randomBuilder;
        end

        function closureBuilder = getClosurePathBuilder(this)
            closureBuilder = this.closureBuilder;
        end

        function setClosurePathBuilder(this, closureBuilder)
            this.closureBuilder = closureBuilder;
        end

        function points = getWaypoints(this)
            % get path loop indices
            openPathIndices  = this.randomBuilder.getPathIndices();
            this.closureBuilder.setOpenPathIndices(openPathIndices);
            closePathIndices = this.closureBuilder.getPathIndices();

            % get open path nodes
            openPathMap = this.randomBuilder.getMap();
            openPathPoints = openPathMap.nodes(:, openPathIndices);
            
            % get close path nodes
            closePathMap = this.randomBuilder.getMap();
            closePathPoints = closePathMap.nodes(:, closePathIndices);

            % get joined loop nodes
            points = [ openPathPoints closePathPoints(:, 2 : end - 1) ];
        end

        function indices = getPathIndices(this)
            error('operation not available');
        end
    end

end
