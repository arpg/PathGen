classdef (Abstract) PathCurveBuilder < CurveBuilder

    properties (Access = protected)
        poses;
    end

    methods (Access = public)
        function this = PathCurveBuilder()
            % create simple path
            this.poses = zeros(7, 2);
            this.poses(7, :) = 1;
            this.poses(1, 1) = 1;
        end

        function poses = getPath(this)
            poses = this.poses;
        end

        function setPath(this, poses)
            this.poses = poses;
        end
    end

    methods (Access = protected)
        function times = getTimes(this, poses)
            if nargin < 2
                poses = this.poses;
            end

            count = size(poses, 2);
            times = zeros(1, count);
            times(1) = 0;

            for i = 2 : count
                final = poses(:, i);
                start = poses(:, i - 1);
                avgSpeed = (final(7) + start(7)) / 2;
                distance = norm(final(1:3) - start(1:3));
                duration = distance / avgSpeed;
                times(i) = times(i - 1) + duration;
            end
        end
    end

end
