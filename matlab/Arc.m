classdef Arc < Segment
    
    properties (Access = private)
        speed;
        center;
        angle;
        axis;
    end
    
    methods (Access = public)
        function this = Arc()
            this.center = zeros(3, 1);
            this.axis = [ 0; 0; 1 ];
            this.angle = 0;
        end
        
        function speed = getSpeed(this)
            speed = this.speed;
        end

        function setSpeed(this, speed)
            this.speed = speed;
        end

        function center = getCenter(this)
            center = this.center;
        end

        function setCenter(this, center)
            this.center = center;
        end

        function angle = getAngle(this)
            angle = this.angle;
        end

        function setAngle(this, angle)
            this.angle = angle;
        end

        function axis = getAxis(this)
            axis = this.axis;
        end

        function setAxis(this, axis)
            this.axis = axis;
        end
    
        function poses = getPoses(this, samples)
            % initialize pose list
            samples = samples + 2;
            poses = zeros(7, samples);
            poses(:, 1) = this.source;
            speeds = this.getSpeeds(samples);

            % create rotation matrix
            rotStep = this.angle / (samples - 1);
            rotMat = axis_angle_to_rotmat(this.axis, rotStep);

            % create each sample pose
            for i = 2 : samples
                % rotate last position by step rotation
                prev = poses(1:3, i - 1) - this.center;
                poses(1:3, i) = rotMat * prev + this.center;

                % assign new speed
                poses(7, i) = speeds(i);
            end

            % add orientation values
            poses = this.updateOrientations(poses);
        end
    end

    methods (Access = private)
        function speeds = getSpeeds(this, samples)
            % calculate vector sizes
            hi = ceil(samples / 2);
            lo = samples - hi;

            % get max weight for middle speed
            flag = mod(samples + 1, 2);
            step = 1 / samples;
            minv = step * flag;
            maxv = 1 - minv;

            % get partial weight vectors
            freq = maxv / (hi - 1);
            an = 1 : -freq : minv;
            bn = minv : freq : 1;
            zs = zeros(1, lo);

            % calculate final speeds
            as = [ an, zs ] * this.source(7);
            cs = [ zs, bn ] * this.target(7);
            bs = [ 1 - an, 1 - bn(2 - flag : end) ] * this.speed;
            speeds = as + bs + cs;
        end

        function poses = updateOrientations(this, poses)
            count = size(poses, 2);

            % update each samples
            for i = 1 : count
                % set orientation to arc tangent
                cpos = poses(1:3, i) - this.center;
                rpos = cross(this.axis, cpos);
                zrot = atan2(rpos(2), rpos(1));
                poses(4:6, i) = [ 0; 0; zrot ];
            end
        end
    end
    
end
