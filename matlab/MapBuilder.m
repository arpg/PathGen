classdef (Abstract) MapBuilder < handle

    methods (Access = public, Abstract)
        build(this);
    end

end
