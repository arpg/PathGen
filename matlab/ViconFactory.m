classdef ViconFactory < handle
    
    methods (Access = public, Static)
        function vicon = create(filename)
            vicon = Vicon;
            config = load(filename);
            vicon.setPose(config.pose);
            vicon.setObjectId(config.objectId);
            vicon.setObjectPose(config.objectPose);
            vicon.setDataRate(config.dataRate);
        end
    end
    
end
