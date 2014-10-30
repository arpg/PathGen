classdef ImuDataWriter < CurveFileWriter

    properties (Access = private)
        imu;
        north;
        precision;
        
    end

    methods (Access = public)
        function this = ImuDataWriter(imu)
            this.imu = imu;
            this.precision = '%10.6f';
            this.filename = 'imu.csv';
            this.north = [ 0 1 0 ];
        end

        function imu = getImu(this)
            imu = this.imu;
        end

        function setImu(this, imu)
            this.imu = imu;
        end

        function precision = getOutputPrecision(this)
            precision = this.precision;
        end

        function setOutputPrecision(this, precision)
            this.precision = precision;
        end
    end

    methods (Access = protected)
        function writeFile(this, curve)
            rate = this.imu.getDataRate();
            times = curve.getTimes(rate);
            
            acc = this.getAccelerationData(curve, times);
            mag = this.getMagnetometerData(curve, times);
            data = [ acc mag times' ];

            dlmwrite(this.getFilePath(), data, 'precision', this.precision);
        end
    end

    methods (Access = private)
        function data = getAccelerationData(this, curve, times)
            acc = curve.getAccelerations(times);
            data = acc(1:6, :)';
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
