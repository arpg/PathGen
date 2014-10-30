classdef (Abstract) PathModifier < handle

    properties (Access = protected)
    end

    methods (Access = public)
        function this = PathModifier()
        end
    end

    methods (Access = public, Abstract)
        modify(this, poses)
    end

end
