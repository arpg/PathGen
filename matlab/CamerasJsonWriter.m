classdef CamerasJsonWriter < CurveFileWriter

    properties (Access = private)
        cameras;
    end

    methods (Access = public)
        function this = CamerasJsonWriter(cameras)
            this.cameras = cameras;
            this.filename = 'cameras.json';
        end

        function cameras = getCameras(this)
            cameras = this.camera;
        end

        function setCameras(this, cameras)
            this.cameras = cameras;
        end
    end

    methods (Access = protected)
        function writeFile(this, curve)
            % open file and write head
            fout = fopen(this.getFilePath(), 'w+');
            this.writeHead(fout);
            
            % write all but last camera block
            for i = 1 : length(this.cameras) - 1
                camera = this.cameras{i};
                this.writeCamera(fout, camera, curve);
                fprintf(fout, ',\n');
            end
            
            % write last camera block
            camera = this.cameras{end};
            this.writeCamera(fout, camera, curve);
            
            % write tail and close
            this.writeTail(fout);
            fclose(fout);
        end
    end

    methods (Access = private)
        function writeHead(this, fout)
            fprintf(fout, '{\n\t"cameras" : [\n');
        end
        
        function writeTail(this, fout)
            fprintf(fout, '\n\t]\n}');
        end
        
        function writeCamera(this, fout, camera, curve)
            prefix  = strcat(camera.getName(), 'Cam');
            inifile = strcat(prefix, '.ini');
            povfile = strcat(prefix, '.pov');
            outdir  = camera.getOutputDirectory();
            frames  = this.getFrameCount(camera, curve);
            
            fprintf(fout, '\t\t{\n');
            fprintf(fout, '\t\t\t"inifile" : "%s",\n', inifile);
            fprintf(fout, '\t\t\t"povfile" : "%s",\n', povfile);
            fprintf(fout, '\t\t\t"outdir"  : "%s",\n', outdir);
            fprintf(fout, '\t\t\t"prefix"  : "%s",\n', prefix);
            fprintf(fout, '\t\t\t"frames"  : %d\n', frames);
            fprintf(fout, '\t\t}');
        end
        
        function frames = getFrameCount(this, camera, curve)
            rate  = camera.getFrameRate();
            frames = size(curve.getTimes(rate), 2);
        end
    end

end
