classdef (Abstract) CurveModifier < handle & matlab.mixin.Heterogeneous

    properties (Access = protected)
        name;
        sampleRate;
    end

    methods (Access = public)
        function this = CurveModifier()
            this.name = 'unknown';
            this.sampleRate = 1;
        end

        function name = getName(this)
            name = this.name;
        end

        function setName(this, name)
            this.name = name;
        end

        function sampleRate = getSampleRate(this)
            sampleRate = this.sampleRate;
        end

        function setSampleRate(this, sampleRate)
            this.sampleRate = sampleRate;
        end

        function curve = modify(this, curve)
            % get modified curve poses
            duration = curve.getDuration();
            times = 0 : 1 / this.sampleRate : duration;
            newPoses = this.getNewPoses(curve, times);

            % create modified curve
            poseFunc = spline(times, newPoses);
            mods = curve.getModifications();
            mods{end + 1} = this.name;
            curve = Curve(poseFunc, duration, mods);
        end
    end

    methods (Access = protected, Abstract)
        getNewPoses(this, curve, times);
    end

    methods (Access = protected, Static, Sealed)
        function defaultObject = getDefaultScalarElement
            defaultObject = EmptyCurveModifier;
        end
    end

end
