classdef DirectPathBuilder < PlannedPathBuilder

    properties (Access = private)
        startIndex;
        goalIndex;
    end

    methods (Access = public)
        function this = PlannedPathBuilder()
            this.startIndex = 1;
            this.goalIndex = 1;
        end

        function startIndex = getStartIndex(this)
            startIndex = this.startIndex;
        end

        function setStartIndex(this, startIndex)
            this.startIndex = startIndex;
        end

        function goalIndex = getGoalIndex(this)
            goalIndex = this.goalIndex;
        end

        function setGoalIndex(this, goalIndex)
            this.goalIndex = goalIndex;
        end
    end

    methods (Access = protected)
        function cost = getActualCost(this, index, prevIndex)
            cost = this.getEuclideanDistance(index, prevIndex);
        end

        function cost = getEstimatedCost(this, index)
            cost = this.getEuclideanDistance(index, this.goalIndex);
        end
    end

end
