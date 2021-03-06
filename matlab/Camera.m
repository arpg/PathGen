classdef Camera < handle

    properties (Access = private)
        name;
        pose;
        frameRate;
        sky;
        fov;
        imageHeight;
        imageWidth;
        model;
        outdir;
    end

    methods (Access = public)
        function this = Camera()
            this.name = 'camera';
            this.pose = zeros(6, 1);
            this.frameRate = 1;
            this.sky = [ 0; 0; -1 ];
            this.fov = 100;
            this.imageHeight = 640;
            this.imageWidth = 480;
            this.model = 'mymodel.pov';
            this.outdir = '.';
        end

        function name = getName(this)
            name = this.name;
        end

        function setName(this, name)
            this.name = name;
        end

        function pose = getPose(this)
            pose = this.pose;
        end

        function setPose(this, pose)
            this.pose = pose;
        end

        function frameRate = getFrameRate(this)
            frameRate = this.frameRate;
        end

        function setFrameRate(this, frameRate)
            this.frameRate = frameRate;
        end

        function sky = getSky(this)
            sky = this.sky;
        end

        function setSky(this, sky)
            this.sky = sky;
        end

        function fov = getFieldOfView(this)
            fov = this.fov;
        end

        function setFieldOfView(this, fov)
            this.fov = fov;
        end

        function imageHeight = getImageHeight(this)
            imageHeight = this.imageHeight;
        end

        function setImageHeight(this, imageHeight)
            this.imageHeight = imageHeight;
        end

        function imageWidth = getImageWidth(this)
            imageWidth = this.imageWidth;
        end

        function setImageWidth(this, imageWidth)
            this.imageWidth = imageWidth;
        end

        function model = getModel(this)
            model = this.model;
        end

        function setModel(this, model)
            this.model = model;
        end

        function outdir = getOutputDirectory(this)
            outdir = this.outdir;
        end

        function setOutputDirectory(this, outdir)
            this.outdir = outdir;
        end
        
        function poses = getPoses(this, curve)
            % get list of imu path poses
            times = curve.getTimes(this.frameRate);
            pathPoses = curve.getPoses(times);

            % create empty list of camera poses
            count = size(pathPoses, 2);
            poses = zeros(6, count);

            % transform each pose
            for i = 1 : count
                pathPose = pathPoses(1:6, i);
                poses(:, i) = tcomp(pathPose, this.pose);
            end
        end
    end

end
