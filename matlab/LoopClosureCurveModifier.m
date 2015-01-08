classdef LoopClosureCurveModifier < CurveModifier

    properties (Access = private)
        overlap;
    end

    methods (Access = public)
        function this = LoopClosureCurveModifier()
            this.overlap = 2;
        end

        function overlap = getOverlapTime(this)
            overlap = this.overlap;
        end

        function setOverlapTime(this, overlap)
            this.overlap = overlap;
        end
    end
    
    methods (Access = protected)
        function poses = getNewPoses(this, curve, times)
            poses = curve.getPoses(times);
        end
    end

end
