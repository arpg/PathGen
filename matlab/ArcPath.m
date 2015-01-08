classdef ArcPath < handle

    properties (Access = private)
        segments;
    end

    methods (Access = public)
        function this = ArcPath(segments)
            this.segments = segments;
        end

        function count = getSegmentCount(this)
            count = size(this.segments, 2);
        end

        function segment = getSegment(this, index)
            segment = this.segments(index);
        end

        function poses = getPoses(this, samples)
            count = this.getSegmentCount();
            total = (samples - 1) * count + 1;
            poses = zeros(7, total);

            s = 1;
            e = samples + 1;

            for i = 1 : count
                temp = this.segments(i).getPoses(samples);
                poses(:, s:e) = temp(:, 1 : end - 1); 
                s = s + samples + 1;
                e = e + samples + 1;
            end

            poses(:, end) = temp(:, end);
            poses = fix_rot_seq(poses);
        end
    end

end
