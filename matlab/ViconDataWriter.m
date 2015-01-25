classdef ViconDataWriter < CurveFileWriter

    properties (Access = private)
        vicon;
        precision;
    end

    methods (Access = public)
        function this = ViconDataWriter(vicon)
            this.vicon = vicon;
            this.precision = '%10.6g';
            this.filename = 'posys/';
        end

        function vicon = getVicon(this)
            vicon = this.vicon;
        end

        function setVicon(this, vicon)
            this.vicon = vicon;
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
            rate = this.vicon.getDataRate();
            times = curve.getTimes(rate);
            
            poses = this.vicon.getPoseData(curve, times);
            poseFormat = 6; % 6=Euler [pqr|xyz], defined in HAL Pose.proto
            metadata = [this.vicon.getObjectId(), poseFormat, ...
                size(poses,2)];
            metadata = repmat(metadata, numel(times), 1);
            covariance = zeros(numel(times), 1);
            
            data = [times' times' metadata poses covariance];
            
            filepath = this.getFilePath();
            
            if ~exist(filepath, 'dir')
                mkdir(filepath);
            end
            
            filename = sprintf('object%02d.csv', this.vicon.getObjectId());
            this.writeData(filename, data);
        end
    end

    methods (Access = private)
        function writeData(this, name, data)
            filename = strcat(this.getFilePath(), name);
            dlmwrite(filename, data, 'precision', this.precision);
        end
    end

end
