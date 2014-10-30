classdef ArcCurveBuilder < PathCurveBuilder

    properties (Access = private)
        pathBuilder;
        sampleCount;
    end

    methods (Access = public)
        function this = ArcCurveBuilder()
            this.sampleCount = 1;
        end

        function pathBuilder = getArcPathBuilder(this)
            pathBuilder = this.pathBuilder;
        end

        function setArcPathBuilder(this, pathBuilder)
            this.pathBuilder = pathBuilder;
        end

        function sampleCount = getArcSampleCount(this)
            sampleCount = this.sampleCount;
        end

        function setArcSampleCount(this, sampleCount)
            this.sampleCount = sampleCount;
        end

        function curve = build(this)
            % generate poses from arc path
            this.pathBuilder.setPoses(this.poses);
            path = this.pathBuilder.build();
            poses = path.getPoses(this.sampleCount);

            % build spline from arc path poses
            times = this.getTimes(poses);
            duration = times(end);
            poseFunc = spline(times, poses);

            curve = Curve(poseFunc, duration);
        end
    end

end
