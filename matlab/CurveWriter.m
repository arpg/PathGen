classdef (Abstract) CurveWriter < handle & matlab.mixin.Heterogeneous

    methods (Access = public, Abstract)
        write(this, curve);
    end

    methods (Access = protected, Static, Sealed)
        function defaultObject = getDefaultScalarElement
            defaultObject = ImuDataWriter;
        end
    end

end
