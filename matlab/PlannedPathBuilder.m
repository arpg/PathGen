classdef PlannedPathBuilder < MapPathBuilder

    properties (Access = protected)
        startIndex;
        goalIndex;
        opened;
        closed;
        gscores;
        fscores;
        parents;
        steps;
    end

    methods (Access = public)
        function this = PlannedPathBuilder()
            this.startIndex = 1;
            this.goalIndex = 1;
        end

        function indices = getPathIndices(this)
            this.initNewSearch();

            while find(this.opened)
                this.steps = this.steps + 1;
                index = this.getBestNode();

                if index == this.goalIndex
                    indices = this.buildPath();
                    return;
                end

                this.visitNode(index);
            end

            error('no path found');
        end
    end

    methods (Access = protected, Abstract)
        getActualCost(this, index, prevIndex);
        getEstimatedCost(this, index);
    end

    methods (Access = protected)
        function initNewSearch(this)
            count = this.map.getNodeCount();
            this.opened = zeros(1, count);
            this.closed = zeros(1, count);
            this.gscores = zeros(1, count);
            this.fscores = zeros(1, count);
            this.parents = zeros(1, count);
            this.opened(this.startIndex) = 1;
            this.steps = 0;
        end

        function bestIndex = getBestNode(this)
            indices = find(this.opened);
            bestIndex = indices(1);
            bestScore = this.fscores(1);

            for i = 2 : length(indices)
                index = indices(i);
                score = this.fscores(index);

                if score < bestScore
                    bestIndex = index;
                    bestScore = score;
                end
            end
        end

        function visitNode(this, index)
            this.opened(index) = 0;
            this.closed(index) = 1;

            neighbors = find(this.map.links(:, index));

            for i = 1 : length(neighbors)
                if this.closed(neighbors(i))
                    continue;
                end

                this.inspectNeighbor(neighbors(i), index);
            end
        end

        function inspectNeighbor(this, index, prevIndex)
            gscore = this.getTotalActualCost(index, prevIndex);

            if ~this.opened(index) || gscore < this.gscores(index)
                this.parents(index) = prevIndex;
                this.gscores(index) = gscore;

                estimate = this.getEstimatedCost(index);
                this.fscores(index) = gscore + estimate;

                this.opened(index) = 1;
            end
        end

        function cost = getTotalActualCost(this, index, prevIndex)
            step = this.getActualCost(index, prevIndex);
            cost = this.gscores(prevIndex) + step;
        end

        function indices = buildPath(this)
            indices = zeros(1, this.steps);
            mapIndex = this.goalIndex;
            pathIndex = this.steps;

            while mapIndex ~= this.startIndex
                indices(pathIndex) = mapIndex;
                mapIndex = this.parents(mapIndex);
                pathIndex = pathIndex - 1;
            end

            indices(pathIndex) = this.startIndex;
            indices = indices(pathIndex : end);
        end

        function dist = getEuclideanDistance(this, indexA, indexB)
            a = this.map.nodes(:, indexA);
            b = this.map.nodes(:, indexB);
            dist = norm(a - b);
        end

        function dist = getManhattanDistance(this, indexA, indexB)
            a = this.map.nodes(:, indexA);
            b = this.map.nodes(:, indexB);
            dist = sum(a - b);
        end
    end

end
