classdef ArcBuilderFactory < handle
    
    methods (Access = public, Static)
        function camera = create(filename)
            config = load(filename);
            camera = ArcBuilder;
            camera.setMaxIdealRadius(config.maxIdealRadius);
            camera.setMaxSpeed(config.maxSpeed);
        end
    end
    
end
