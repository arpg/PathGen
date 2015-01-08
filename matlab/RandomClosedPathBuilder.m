classdef RandomClosedPathBuilder < MapPathBuilder

    properties (Access = private)
        randomBuilder;
        closureBuilder;
        minAngle;
    end

    methods (Access = public)
        function this = RandomClosedPathBuilder()
            this.minAngle = pi / 5;
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
            flag = false;
            
            while ~flag
                points = this.getRawWaypoints();
                flag = this.isValid(points);
            end
        end
        
        function points = getRawWaypoints(this)
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
        
        function flag = isValid(this, waypoints)
            % check all internal angles
            for i = 1 : size(waypoints, 2) - 2
                a = waypoints(:, i + 0);
                b = waypoints(:, i + 1);
                c = waypoints(:, i + 2);
                
                % turn angle is too sharp
                if turn_angle(a, b, c) < this.minAngle
                    flag = false;
                    return;
                end
            end

            % check first angle
            a = waypoints(:, end);
            b = waypoints(:, 1);
            c = waypoints(:, 2);

            % turn angle is too sharp
            if turn_angle(a, b, c) < this.minAngle
                flag = false;
                return;
            end

            % check last angle
            a = waypoints(:, end - 1);
            b = waypoints(:, end);
            c = waypoints(:, 1);

            % turn angle is too sharp
            if turn_angle(a, b, c) < this.minAngle
                flag = false;
                return;
            end
            
            flag = true;
        end

        function indices = getPathIndices(this)
            error('operation not available');
        end
    end

end
