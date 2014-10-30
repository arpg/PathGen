classdef CurveDescriptionWriter < CurveFileWriter

    properties (Access = private)
        sampleRate;
    end

    methods (Access = public)
        function this = CurveDescriptionWriter()
            this.filename = 'description.txt';
            this.sampleRate = 200;
        end

        function sampleRate = getSampleRate(this)
            sampleRate = this.sampleRate;
        end

        function setSampleRate(this, sampleRate)
            this.sampleRate = sampleRate;
        end
    end

    methods (Access = protected)
        function writeFile(this, curve)
            % get information
            duration = curve.getDuration();
            distance = this.getDistance(curve);
            speeds = this.getSpeeds(curve);
            mods = this.getModifications(curve);

            % write information to file
            fout = fopen(this.getFilePath(), 'w');
            fprintf(fout, 'duration:    %f\n', duration);
            fprintf(fout, 'distance:    %f\n', distance);
            fprintf(fout, 'maxLinSpeed: %f\n', speeds(1, 1));
            fprintf(fout, 'minLinSpeed: %f\n', speeds(2, 1));
            fprintf(fout, 'avgLinSpeed: %f\n', speeds(3, 1));
            fprintf(fout, 'modifiers:   %s\n', mods);
            fclose(fout);
        end
    end

    methods (Access = private)
        function distance = getDistance(this, curve)
            times = curve.getTimes(this.sampleRate);
            poses = curve.getPoses(times);
            count = size(poses, 2);
            distance = 0;
            
            for i = 1 : count - 1
                step = norm(poses(1:3, i + 1) - poses(1:3, i));
                distance = distance + step;
            end
        end
        
        function speeds = getSpeeds(this, curve)
            times = curve.getTimes(this.sampleRate);
            velocities = curve.getVelocities(times);
            count = size(velocities, 2);
            norms = zeros(count, 1);
            
            for i = 1 : count
                norms(i, 1) = norm(velocities(1:3, i));
            end
            
            speeds = zeros(3, 1);
            speeds(1, :) = max(norms);
            speeds(2, :) = min(norms);
            speeds(3, :) = mean(norms);
        end

        function mods = getModifications(this, curve)
            list = curve.getModifications();
            format = '%s\n             %s';
            
            % return if no mods
            if isempty(list)
                mods = 'none';
                return
            end
            
            % add first mode
            mods = list{1};
            
            % add each subsequent mod
            for i = 2 : length(list)
                mods = sprintf(format, mods, list{i});
            end
        end
    end

end
