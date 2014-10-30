classdef ClosurePathBuilder < PlannedPathBuilder

    properties (Access = private)
        minTurnAngle;
        tightTurnWeight;
        retraceWeight;
        openIndices;
    end

    methods (Access = public)
        function this = ClosurePathBuilder()
            this.minTurnAngle = 0;
            this.tightTurnWeight = 0;
            this.retraceWeight = 0;
            this.openIndices = 1;
        end

        function minTurnAngle = getMinTurnAngle(this)
            minTurnAngle = this.minTurnAngle;
        end

        function setMinTurnAngle(this, minTurnAngle)
            this.minTurnAngle = minTurnAngle;
        end

        function tightTurnWeight = getTightTurnWeight(this)
            tightTurnWeight = this.tightTurnWeight;
        end

        function setTightTurnWeight(this, tightTurnWeight)
            this.tightTurnWeight = tightTurnWeight;
        end

        function retraceWeight = getRetraceWeight(this)
            retraceWeight = this.retraceWeight;
        end

        function setRetraceWeight(this, retraceWeight)
            this.retraceWeight = retraceWeight;
        end

        function openIndices = getOpenPathIndices(this)
            openIndices = this.openIndices;
        end

        function setOpenPathIndices(this, openIndices)
            this.openIndices = openIndices;
            this.startIndex = openIndices(end);
            this.goalIndex = openIndices(1);
        end
    end

    methods (Access = protected)
        function initNewSearch(this)
            initNewSearch@PlannedPathBuilder(this);
            this.parents(this.startIndex) = this.openIndices(end - 1);
        end

        function cost = getActualCost(this, index, prevIndex)
            % get euclidean distance
            dist = this.getEuclideanDistance(index, prevIndex);
            
            % get retracing waypoint penalty
            retrace = this.getRetraceScore(index);
            
            % get current tight turn penalty
            currAngle = this.getCurrentAngleScore(index, prevIndex);
            
            % get close tight turn penalty
            closeAngle = this.getClosingAngleScore(index);
            
            % return total score
            cost = dist + retrace + currAngle + closeAngle;
        end

        function cost = getEstimatedCost(this, index)
            % get manhattan distance
            dist = this.getManhattanDistance(index, this.goalIndex);
            
            % get tight turn closing penalty
            angle = this.getClosingAngleScore(index);
            
            % return total score
            cost = dist + angle;
        end
    end
    
    methods (Access = private)
        function score = getRetraceScore(this, index)
            retrace = ~isempty(find(this.openIndices == index, 1));
            retrace = retrace && index ~= this.goalIndex;
            score = this.retraceWeight * retrace;
        end
        
        function score = getCurrentAngleScore(this, index, prevIndex)
            prevIndex = this.parents(prevIndex);
            score = this.getAngleScore(prevIndex, prevIndex, index);
        end
    
        function score = getClosingAngleScore(this, index)
            score = 0;
            
            % check if non-zero score possible
            if this.hasClosingAngle(index)
                goalIndex = this.goalIndex;
                nextIndex = this.openIndices(2);
                score = this.getAngleScore(index, goalIndex, nextIndex);
            end
        end
        
        function flag = hasClosingAngle(this, index)
            % has link to goal node
            flag = this.map.links(this.goalIndex, index);
            
            % has non-trivial turn limit
            flag = flag && this.minTurnAngle > 0;
        end
        
        function weight = getAngleScore(this, a, b, c)
            weight = 0;
            angle = this.getAngle(a, b, c);

            % check if tight turn
            if angle < this.minTurnAngle
                ratio = 1 - angle / this.minTurnAngle;
                weight = ratio * this.tightTurnWeight;
            end
        end
        
        function angle = getAngle(this, a, b, c)
            % get points from indices
            a = this.map.nodes(:, a);
            b = this.map.nodes(:, b);
            c = this.map.nodes(:, c);
            
            % return final angle
            angle = turn_angle(a, b, c);
        end
    end

end
