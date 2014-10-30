classdef (Abstract) PathBuilder < handle

    methods (Access = public)
        function poses = build(this)
            points = this.getWaypoints();
            count = size(points, 2);
            poses = [ points; zeros(3, count); ones(1, count) ];
        end
    end
    
    methods (Access = public, Abstract)
        getWaypoints(this);
    end

end
