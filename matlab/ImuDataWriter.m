classdef ImuDataWriter < CurveFileWriter

    properties (Access = private)
        imu;
        precision;
    end

    methods (Access = public)
        function this = ImuDataWriter(imu)
            this.imu = imu;
            this.precision = '%10.6f';
            this.filename = 'imu/';
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
            
            accel = this.imu.getAccelerationData(curve, times);
            gyro = this.imu.getGyroscopeData(curve, times);
            mag = this.imu.getMagnetometerData(curve, times);
            
            filepath = this.getFilePath();
            
            if ~exist(filepath, 'dir')
                mkdir(filepath);
            end
            
            this.writeData('accel.txt', accel);
            this.writeData('gyro.txt', gyro);
            this.writeData('mag.txt', mag);
            this.writeData('timestamp.txt', [ times' times' ]);
        end
    end

    methods (Access = private)
        function writeData(this, name, data)
            filename = strcat(this.getFilePath(), name);
            dlmwrite(filename, data, 'precision', this.precision);
        end
    end

end
