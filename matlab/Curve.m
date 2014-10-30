classdef Curve < handle

    properties (Access = private)
        duration;
        poseFunc;
        velocityFunc;
        accelerationFunc;
        modifications;
    end

    methods (Access = public)
        function this = Curve(poseFunc, duration, modifications)
            this.poseFunc = poseFunc;
            this.duration = duration;
            this.velocityFunc = 0;
            this.accelerationFunc = 0;

            if nargin < 3
                modifications = {};
            end

            this.modifications = modifications;
        end

        function duration = getDuration(this)
            duration = this.duration;
        end

        function setDuration(this, duration)
            this.duration = duration;
        end

        function modifications = getModifications(this)
            modifications = this.modifications;
        end
        
        function times = getTimes(this, rate)
            times = 0 : 1 / rate : this.duration;
        end

        function poses = getPoses(this, times)
            poses = ppval(this.poseFunc, times);
        end

        function velocities = getVelocities(this, times)
            func = this.getVelocityFunction();
            velocities = ppval(func, times);
        end

        function accelerations = getAccelerations(this, times)
            func = this.getAccelerationFunction();
            accelerations = ppval(func, times);
        end

        function func = getPoseFunction(this)
            func = this.poseFunc;
        end

        function func = getVelocityFunction(this)
            % check if function needs to be derived
            if isnumeric(this.velocityFunc)
                this.velocityFunc = fnder(this.poseFunc);
            end

            func = this.velocityFunc;
        end

        function func = getAccelerationFunction(this)
            % check if function needs to be derived
            if isnumeric(this.accelerationFunc)
                velFunc = this.getVelocityFunction();
                this.accelerationFunc = fnder(velFunc);
            end

            func = this.accelerationFunc;
        end
    end

end
