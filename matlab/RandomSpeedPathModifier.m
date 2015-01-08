classdef RandomSpeedPathModifier < PathModifier

    properties (Access = private)
        maxSpeed;
        minSpeed;
    end

    methods (Access = public)
        function this = RandomSpeedPathModifier()
            this.maxSpeed = 1;
            this.minSpeed = 1;
        end

        function maxSpeed = getMaxSpeed(this)
            maxSpeed = this.maxSpeed;
        end

        function setMaxSpeed(this, maxSpeed)
            assert(maxSpeed > 0, 'maxSpeed > 0');

            % shift minSpeed as needed
            if maxSpeed < this.minSpeed
                this.minSpeed = maxSpeed;
            end

            this.maxSpeed = maxSpeed;
        end
        
        function minSpeed = getMinSpeed(this)
            minSpeed = this.minSpeed;
        end
        
        function setMinSpeed(this, minSpeed)
            assert(minSpeed > 0, 'minSpeed > 0');

            % shift maxSpeed as needed
            if minSpeed > this.maxSpeed
                this.maxSpeed = minSpeed;
            end

            this.minSpeed = minSpeed;
        end
        
        function poses = modify(this, poses)
            count = size(poses, 2);

            % assign speed for each pose
            for i = 1 : count
                poses(7, i) = this.getRandomSpeed();
            end
        end
    end

    methods (Access = private)
        function speed = getRandomSpeed(this)
            range = this.maxSpeed - this.minSpeed;
            speed = range * rand() + this.minSpeed;
        end
    end

end
