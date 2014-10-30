classdef Edge < Segment
    
    properties (Access = private)
    end
    
    methods (Access = public)
        function this = Edge(source, target)
            this.source = source;
            this.target = target;
        end
        
        function poses = getPoses(this, samples)
            % get linear interpolation between points
            times = 0 : 1 / (samples + 1) : 1;
            poses = this.source * (1 - times) + this.target * times;
            samples = length(times);

            % overwrite with fixed orientation
            delta = this.target - this.source;
            zrot = atan2(delta(2), delta(1));
            orient = repmat([ 0; 0; zrot], 1, samples);
            poses(4:6, :) = orient;
        end
    end
    
end
