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
            poses = ArcPath.fixRotation(poses);
        end
    end
        
    methods (Access = private, Static)
        function poses = fixRotation(poses)
            % initialize with first pose
            total = poses(6, 1);                                                   
                                     
            % total each subsequent pose
            for i = 2 : size(poses, 2)                                             
                a = poses(6, i - 1);                                               
                b = poses(6, i);                                                   
                                                                                   
                diff = mod(b - a, 2 * pi);                                         
                                                                                   
                if (diff > pi)                                                     
                    diff = diff - 2 * pi;                                          
                end                                                                
                           
                total = total + diff;                                              
                poses(6, i) = total;                                               
            end
        end 
    end

end
