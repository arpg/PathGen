classdef CameraPoseWriter < CurveFileWriter

    properties (Access = private)
        camera;
    end

    methods (Access = public)
        function this = CameraPoseWriter(camera)
            this.camera = camera;
            name = camera.getName();
            this.filename = strcat(name, 'CamPath.inc');
        end

        function camera = getCamera(this)
            camera = this.camera;
        end

        function setCamera(this, camera)
            this.camera = camera;
        end
    end

    methods (Access = protected)
        function writeFile(this, curve)
            poses = this.getPoses(curve);
            fout = fopen(this.getFilePath(), 'w+');
            this.writeHead(fout, poses);
            this.writePoses(fout, poses);
            fclose(fout);
        end
    end

    methods (Access = private)
        function poses = getPoses(this, curve)
            % get list of imu path poses
            rate  = this.camera.getFrameRate();
            times = curve.getTimes(rate);
            pathPoses = curve.getPoses(times);

            % create empty list of camera poses
            count = size(pathPoses, 2);
            poses = zeros(6, count);
            transform = this.camera.getPose();

            % transform each pose
            for i = 1 : count
                pathPose = pathPoses(1:6, i);
                poses(:, i) = tcomp(pathPose, transform);
            end
        end

        function writeHead(this, fout, poses)
            count = size(poses, 2);
            varname = strcat(this.camera.getName(), 'CamPath');
            fprintf(fout, '// row format: {location, target, up}\n');
            fprintf(fout, '#declare %s = array[%d][9]{\n', varname, count);
        end

        function writePoses(this, fout, poses)
            count = size(poses, 2);
            
            % write all but last pose
            for i = 1 : count - 1
                pose = this.getPovrayPose(poses(:, i));
                fprintf(fout, '\t{%f,%f,%f,%f,%f,%f,%f,%f,%f},\n', pose);
            end 
            
            % write last pose
            pose = this.getPovrayPose(poses(:, end));
            fprintf(fout, '\t{%f,%f,%f,%f,%f,%f,%f,%f,%f}\n}\n', pose);
        end

        function pose = getPovrayPose(this, pose)
            location = pose(1:3);
            R = Cart2R(pose(4:6));
            target = location + R(:, 1);
            up = -R(:, 3);
            pose = [ location target up ];
        end
    end

end
