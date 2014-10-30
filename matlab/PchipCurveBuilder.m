classdef PchipCurveBuilder < PathCurveBuilder

    properties (Access = private)
        sampleRate;
    end

    methods (Access = public)
        function this = PchipCurveBuilder()
            this.sampleRate = 1;
        end

        function sampleRate = getSampleRate(this)
            sampleRate = this.sampleRate;
        end

        function setSampleRate(this, sampleRate)
            this.sampleRate = sampleRate;
        end

        function curve = build(this)
            % build pchip-spline
            times = this.getTimes();
            poseFunc = pchip(times, this.poses);
            duration = times(end);

            % build spline-spline from pchip-spline
            times = 0 : 1 / this.sampleRate : duration;
            poses = ppval(poseFunc, times);
            poseFunc = spline(times, poses);

            curve = Curve(poseFunc, duration);
        end
    end

end
