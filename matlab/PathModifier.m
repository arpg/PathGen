classdef (Abstract) PathModifier < handle & matlab.mixin.Heterogeneous

    properties (Access = protected)
    end

    methods (Access = public)
        function this = PathModifier()
        end
    end

    methods (Access = public, Abstract)
        modify(this, poses);
    end

    methods (Access = protected, Static, Sealed)
        function defaultObject = getDefaultScalarElement
            defaultObject = EmptyPathModifier;
        end
    end

end