classdef RandomPathBuilder < MapPathBuilder

    properties (Access = private)
        maxEdges;
        minEdges;
        minTurnAngle;
        maxAngleWeight;
        minAngleWeight;
        startIndices;
    end

    methods (Access = public)
        function this = RandomPathBuilder()
            this.maxEdges = 1;
            this.minEdges = 1;
            this.minTurnAngle = 0;
            this.maxAngleWeight = 1;
            this.minAngleWeight = 1;
            this.startIndices = 1;
        end

        function maxEdges = getMaxEdges(this)
            maxEdges = this.maxEdges;
        end

        function setMaxEdges(this, maxEdges)
            assert(maxEdges > 0, 'maxEdges > 0');

            % shift minEdges as needed
            if maxEdges < this.minEdges
                this.minEdges = maxEdges;
            end

            this.maxEdges = maxEdges;
        end
        
        function minEdges = getMinEdges(this)
            minEdges = this.minEdges;
        end
        
        function setMinEdges(this, minEdges)
            assert(minEdges > 0, 'minEdges > 0');

            % shift maxEdges as needed
            if minEdges > this.maxEdges
                this.maxEdges = minEdges;
            end

            this.minEdges = minEdges;
        end

        function minTurnAngle = getMinTurnAngle(this)
            minTurnAngle = this.minTurnAngle;
        end

        function setMinTurnAngle(this, minTurnAngle)
            assert(minTurnAngle >= 0, 'minTurnAngle >= 0');
            this.minTurnAngle = minTurnAngle;
        end

        function maxAngleWeight = getMaxAngleWeight(this)
            maxAngleWeight = this.maxAngleWeight;
        end

        function setMaxAngleWeight(this, maxAngleWeight)
            assert(maxAngleWeight >= 0, 'maxAngleWeight >= 0');
            this.maxAngleWeight = maxAngleWeight;
        end

        function minAngleWeight = getMinAngleWeight(this)
            minAngleWeight = this.minAngleWeight;
        end

        function setMinAngleWeight(this, minAngleWeight)
            assert(minAngleWeight >= 0, 'minAngleWeight >= 0');
            this.minAngleWeight = minAngleWeight;
        end

        function setMap(this, map)
            this.startIndices = 1 : map.getNodeCount();
            this.map = map;
        end

        function startIndices = getStartIndices(this)
            startIndices = this.startIndices;
        end

        function setStartIndices(this, startIndices)
            % use all nodes if none given
            if isempty(startIndices)
                startIndices = 1 : this.map.getNodeCount();
            end

            this.startIndices = startIndices;
        end

        function indices = getPathIndices(this)
            % loop until valid path found
            while ~exist('indices', 'var')
                try
                    indices = this.getPathIndicesTry();
                catch err
                    if strcmp(err.identifier, 'RANDPATH:nopath')
                        % do nothing
                    else
                        rethrow(err);
                    end
                end
            end
        end
    end

    methods (Access = private)
        function indices = getPathIndicesTry(this)
            edges = this.getRandomEdgeCount();
            indices = zeros(1, edges + 1);

            % add first node
            count = length(this.startIndices);
            indices(1) = this.startIndices(randi(count));
            
            % add second node
            links = find(this.map.links(:, indices(1)));
            indices(2) = links(randi(length(links)));
            
            % add remaining nodes
            for i = 3 : edges + 1
                indices(i) = this.getNextIndex(indices(i - 1), indices(i - 2));
            end
        end
        
        function index = getNextIndex(this, currIndex, prevIndex)
            % get list of valid links
            [links, angles] = this.getValidLinks(currIndex, prevIndex);
            
            % check if no valid options
            if isempty(links)
                % TODO: add backtracking
                error('RANDPATH:nopath', 'No valid path found.');
            end
            
            % select one of the valid links
            index = this.selectValidLink(links, angles);
        end

        
        function [links, angles] = getValidLinks(this, currIndex, prevIndex)
            % get initial list of every link
            links = find(this.map.links(:, currIndex));
            count = length(links);
            angles = zeros(1, count);
            
            % get points entering turn
            prev = this.map.nodes(:, prevIndex);
            curr = this.map.nodes(:, currIndex);
            validCount = 0;
            
            % check each link
            for i = 1 : count
                % calculate resulting turn angle 
                next = this.map.nodes(:, links(i));
                angle = turn_angle(prev, curr, next);
                
                % check if valid angle
                if angle >= this.minTurnAngle
                    % add to valid list
                    validCount = validCount + 1;
                    links(validCount) = links(i);
                    angles(validCount) = angle;
                end
            end
            
            % trim valid list
            links = links(1:validCount);
            angles = angles(1:validCount);
        end

        function index = selectValidLink(this, links, angles)
            % create weight for each valid link
            diffs = angles - this.minTurnAngle;
            ratios = diffs / (pi - this.minTurnAngle);
            maxWeights = this.maxAngleWeight * ratios;
            minWeights = this.minAngleWeight * (1 - ratios);
            weights = maxWeights + minWeights;
            
            % select weighted link index
            total = sum(weights);
            value = total * rand();
            
            % compare again each weight
            for i = 1 : length(weights)
                value = value - weights(i);
                
                % check if index found
                if value <= 0
                    index = links(i);
                    break;
                end
            end
        end

        function count = getRandomEdgeCount(this)
            range = this.maxEdges - this.minEdges + 1;
            count = randi(range) + this.minEdges - 1;
        end
    end

end
