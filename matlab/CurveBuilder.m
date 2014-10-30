classdef (Abstract) CurveBuilder < handle

    methods (Access = public, Abstract)
        build(this);
    end

end
