classdef CameraFactory < handle
    
    methods (Access = public, Static)
        function camera = create(filename)
            config = load(filename);
            camera = Camera;
            camera.setName(config.name);
            camera.setPose(config.pose);
            camera.setFrameRate(config.frameRate);
            camera.setSky(config.sky);
            camera.setFieldOfView(config.fov);
            camera.setImageHeight(config.imageHeight);
            camera.setImageWidth(config.imageWidth);
            camera.setModel(config.model);
            camera.setOutputDirectory(config.outdir);
        end
    end
    
end
