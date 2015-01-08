classdef Imu < handle

    properties (Access = private)
        dataRate;
        north;
    end

    methods (Access = public)
        function this = Imu()
            this.dataRate = 1;
            this.north = [ 0 1 0 ];
        end

        function dataRate = getDataRate(this)
            dataRate = this.dataRate;
        end

        function setDataRate(this, dataRate)
            this.dataRate = dataRate;
        end

        function north = getNorth(this)
            north = this.north;
        end

        function setNorth(this, north)
            this.north = north;
        end
        
        function data = getData(this, curve)
            times = curve.getTimes(this.dataRate);
            accel = this.getAccelerationData(curve, times);
            gyro = this.getGyroscopeData(curve, times);
            mag = this.getMagnetometerData(curve, times);
            data = [ accel gyro mag ]';
        end
        
        function data = getAccelerationData(this, curve, times)
            acc = curve.getAccelerations(times);
            poses = curve.getPoses(times);
            count = length(times);
            
            % add gravity acceleration
            for i = 1 : count
                rotmat = eulerPQR_to_rotmat(poses(4:6, i));
                gravity = rotmat * [ 0; 0; 1 ];
                acc(1:3, i) = acc(1:3, i) / 9.8 + gravity;
            end
            
            % swap column orders (x, y, z) -> (y, z, x)
            data = [ acc(2:3, :); acc(1, :) ]';
        end
        
        function data = getGyroscopeData(this, curve, times)
            vels = curve.getVelocities(times);
            poses = curve.getPoses(times);
            count = length(times);
            data = zeros(3, count);
            
            % convert to body rates
            for i = 1 : count
                data(:, i) = EulerRates2BodyRates(poses(4:6, i), vels(4:6, i));
            end
            
            % swap column orders (x, y, z) -> (y, z, x)
            data = [ data(2:3, :); data(1, :) ]';
        end

        function data = getMagnetometerData(this, curve, times)
            poses = curve.getPoses(times);
            count = size(poses, 2);
            data = zeros(count, 3);
            
            % compute for each pose
            for i = 1 : count
                % convert north vector to imu coord space
                R = eulerPQR_to_rotmat(poses(4:6, i));
                data(i, 1:3) = this.north * R;
            end
        end
    end


end
