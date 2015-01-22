classdef Figure8CurveBuilder < PathCurveBuilder

    properties (Access = private)
        sampleRate;
        width;
        height;
        speed;
        xOffset;
        yOffset;
        zOffset;
    end

    methods (Access = public)
        function this = Figure8CurveBuilder()
            this.sampleRate = 1;
            this.width = 2;
            this.height = 1;
            this.speed = 1;
            this.xOffset = 0;
            this.yOffset = 0;
            this.zOffset = 0;
        end

        function width = getWidth(this)
            width = this.width;
        end

        function setWidth(this, width)
            this.width = width;
        end

        function height = getHeight(this)
            height = this.height;
        end

        function setHeight(this, height)
            this.height = height;
        end

        function speed = getSpeed(this)
            speed = this.speed;
        end

        function setSpeed(this, speed)
            this.speed = speed;
        end

        function sampleRate = getSampleRate(this)
            sampleRate = this.sampleRate;
        end

        function setSampleRate(this, sampleRate)
            this.sampleRate = sampleRate;
        end

        function xOffset = getXOffset(this)
            xOffset = this.xOffset;
        end

        function setXOffset(this, xOffset)
            this.xOffset = xOffset;
        end

        function yOffset = getYOffset(this)
            yOffset = this.yOffset;
        end

        function setYOffset(this, yOffset)
            this.yOffset = yOffset;
        end

        function zOffset = getZOffset(this)
            zOffset = this.zOffset;
        end

        function setZOffset(this, zOffset)
            this.zOffset = zOffset;
        end

        function curve = build(this)
            distance = this.getDistance();
            duration = distance / this.speed;
            times = 0 : 1 / this.sampleRate : duration;
            
            n = length(times);
            poses = this.getPoses(n);
            poseFunc = spline(times, poses);
            curve = Curve(poseFunc, duration);
        end
    end
    
    methods (Access = private)
        function poses = getPoses(this, n)
            t = 0 : 2 * pi / n : 2 * pi;
            t = t(1:n);

            % poses = [0.5 * sin(4*t); 2 * sin(t); sin(2 * t); 0.5 * sin(2 * t); zeros(2, n)];
            poses = [0.05 * sin(4*t); 0.25 * sin(t); 0.125 * sin(2 * t); 0.5 * sin(2 * t); zeros(2, n)];
            
            poses(1, :) = poses(1, :) + this.xOffset;
            poses(2, :) = poses(2, :) + this.yOffset;
            poses(3, :) = poses(3, :) + this.zOffset;
            poses = this.lookAt(poses, [0;0;0]);
            poses = [ poses; repmat(this.speed, 1, n) ];
        end
        
        function distance = getDistance(this)
            t = 0 : 0.0001 : 2 * pi;
            % p = [ 0.5 * sin(4*t); 2 * sin(t); sin(2 * t) ];
            p = [ 0.1 * sin(4*t); 0.5 * sin(t); 0.25 * sin(2 * t) ];
            distance = 0;
            
            for i = 2 : length(p)
                delta = p(:, i) - p(:, i - 1);
                distance = distance + norm(delta);
            end
        end
        
        function newposes = lookAt(this, poses, target)
            newposes = poses;
            
            for ii = 1:size(poses,2)
                R = eulerPQR_to_rotmat( poses(4:6,ii));
                f = (target-poses(1:3,ii)) / norm(target-poses(1:3,ii));
                d = R(:,3);
                r = cross(d,f);
                r = r / norm(r);
                d = cross(f,r);
                d = d / norm(d);
                R = [f r d];
                newposes(4:6,ii) = rotmat_to_eulerPQR(R);
            end
        end
    end

end
