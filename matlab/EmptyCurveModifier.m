classdef EmptyCurveModifier < CurveModifier

    methods (Access = public)
        function curve = modify(this, curve)
            % do nothing
        end
    end
    
    methods (Access = protected)
        function poses = getNewPoses(this, curve, times)
            % do nothing
        end
    end

end
