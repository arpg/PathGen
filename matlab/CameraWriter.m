classdef CameraWriter < CurveFileWriter

    properties (Access = private)
        camera;
    end

    methods (Access = public)
        function this = CameraWriter(camera)
            this.camera = camera;
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
            poses = this.camera.getPoses(curve);
            this.writeParamFile();
            this.writeIniFile(size(poses, 2));
            this.writePosesFile(poses);
            this.writeGenerateFile();
            this.createImageDirectory();
        end
    end

    methods (Access = private)
        function writeParamFile(this)
            % open output file
            cameraName = this.camera.getName();
            path = sprintf('%sCamPath', this.camera.getName());
            filename = sprintf('%s/%sCam.pov', this.directory, cameraName); 
            fout = fopen(filename, 'w+');
            
            % write file content
            fprintf(fout, '#include "%s.inc"\n', path);
            fprintf(fout, '\n');
            fprintf(fout, 'camera\n');
            fprintf(fout, '{\n');
            fprintf(fout, '\tlocation < %s[clock][0], ', path);
            fprintf(fout, '%s[clock][1], %s[clock][2] >\n', path, path);
            fprintf(fout, '\tlook_at < %s[clock][3], ', path);
            fprintf(fout, '%s[clock][4], %s[clock][5] >\n', path, path);
            fprintf(fout, '\tsky < %s[clock][6], ', path);
            fprintf(fout, '%s[clock][7], %s[clock][8] >\n', path, path);
            fprintf(fout, '\tright <-1.33, 0, 0>\n');
            fprintf(fout, '\tangle 100\n');
            fprintf(fout, '}\n');
            fprintf(fout, '\n');
            fprintf(fout, '#include "%s"', this.camera.getModel());
            
            % close output file
            fclose(fout);
        end
        
        function writeIniFile(this, count)
            % open output file
            cameraName = this.camera.getName();
            filename = sprintf('%s/%sCam.ini', this.directory, cameraName); 
            fout = fopen(filename, 'w+');
            
            % write file content
            fprintf(fout, 'Render\n');
            fprintf(fout, '\n');
            fprintf(fout, 'Height=%d\n', this.camera.getImageHeight());
            fprintf(fout, 'Width=%d\n', this.camera.getImageWidth());
            fprintf(fout, 'Initial_Frame=0\n');
            fprintf(fout, 'Final_Frame=%d\n', count);
            fprintf(fout, 'Initial_Clock=0\n');
            fprintf(fout, 'Final_Clock=%d\n', count);
            
            % close output file
            fclose(fout);
        end
        
        function writePosesFile(this, poses)
            cameraName = this.camera.getName();
            filename = sprintf('%s/%sCamPath.inc', this.directory, cameraName); 
            fout = fopen(filename, 'w+');
            this.writePosesHead(fout, poses);
            this.writePosesBody(fout, poses);
            fclose(fout);
        end

        function writePosesHead(this, fout, poses)
            count = size(poses, 2);
            varname = strcat(this.camera.getName(), 'CamPath');
            fprintf(fout, '#declare %s = array[%d][9]{\n', varname, count);
        end

        function writePosesBody(this, fout, poses)
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
        
        function writeGenerateFile(this)
            % open output file
            cameraName = sprintf('%sCam', this.camera.getName());
            filename = sprintf('%s/%sGen.sh', this.directory, cameraName);
            fout = fopen(filename, 'w+');
            
            % write file content
            fprintf(fout, '#!/bin/bash\n\n');
            fprintf(fout, 'povray %s.ini %s.pov -O"%s/%s-"\n\n', cameraName, ...
                cameraName, this.camera.getOutputDirectory(), cameraName);
            
            % add renaming commands
            name = this.camera.getName();                                                   
            rate = this.camera.getFrameRate();                                              
                                                                                
            fprintf(fout, 'fps=%d\n\n', rate);                                              
            fprintf(fout, 'rm -rf pgm\n');                                                  
            fprintf(fout, 'mkdir pgm\n');                                                   
            fprintf(fout, 'convert images/*.png pgm/%s-%%04d.pgm\n', name);                 
            fprintf(fout, 'rm pgm/%s-0000.pgm\n\n', name);                                  
            fprintf(fout, 'FILES=`ls pgm/%s-*`\n\n', name);                                            
            fprintf(fout, 'for FILE in $FILES; do\n');                                      
            fprintf(fout, '  NUM=$(echo "$FILE" | sed "s/pgm\\/%s-0*\\(.*\\)\\.pgm/\\1/g")\n', name); 
            fprintf(fout, '  SEC=$(echo "scale=6; ($NUM - 1) * (1 / $fps)" | bc -l)\n');    
            fprintf(fout, '  SEC=$(echo "x=$SEC; if (x < 1) print 0; if (x < 10) print 0; x" | bc -l)\n');
            fprintf(fout, '  mv $FILE pgm/%s-$SEC.pgm\n', name);                        
            fprintf(fout, 'done\n\n');                                                      
            fprintf(fout, 'mv pgm/%s-000.pgm pgm/%s-00.000000.pgm', name, name); 
            
            % close output file
            fclose(fout);
        end
        
        function createImageDirectory(this)
            outdir = this.camera.getOutputDirectory();
            imgdir = strcat(this.directory, '/', outdir);
            
            if ~exist(imgdir, 'dir')
                mkdir(imgdir);
            end
        end
    end

end
