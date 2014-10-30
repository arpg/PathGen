classdef SplineCurveBuilder < PathCurveBuilder

    properties (Access = private)
    end

    methods (Access = public)
        function this = SplineCurveBuilder()
        end

        function curve = build(this)
            times = this.getTimes();
            poseFunc = spline(times, this.poses);
            duration = times(end);
            curve = Curve(poseFunc, duration);
        end
    end

end
