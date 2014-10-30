classdef (Abstract) Segment < handle & matlab.mixin.Heterogeneous
    
    properties (Access = protected)
        source;
        target;
    end
        
    methods (Access = public)
        function this = Segment()
            this.source = zeros(7, 1);
            this.target = zeros(7, 1);
        end

        function source = getSource(this)
            source = this.source;
        end

        function setSource(this, source)
            this.source = source;
        end

        function target = getTarget(this)
            target = this.target;
        end

        function setTarget(this, target)
            this.target = target;
        end
    end

    methods (Access = public, Abstract)
        getPoses(this, samples);
    end

    methods (Access = protected, Static, Sealed)
        function defaultObject = getDefaultScalarElement
            defaultObject = Arc;
        end
    end
    
end
