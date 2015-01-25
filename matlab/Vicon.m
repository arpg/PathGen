classdef Vicon < handle

    properties (Access = private)
        pose;
        objectId;
        objectPose;
        dataRate;
    end

    methods (Access = public)
        function this = Vicon()
            this.objectId = 0;
            this.dataRate = 1;
            this.pose = [ 0; 0; 0; 0; 0; 0 ];
        end
        
        function objectId = getObjectId(this)
            objectId = this.objectId;
        end
        
        function setObjectId(this, objectId)
            this.objectId = objectId;
        end
        
        function objectPose = getObjectPose(this)
            objectPose = this.objectPose;
        end
        
        function setObjectPose(this, objectPose)
            this.objectPose = objectPose;
        end

        function dataRate = getDataRate(this)
            dataRate = this.dataRate;
        end

        function setDataRate(this, dataRate)
            this.dataRate = dataRate;
        end

        function pose = getPose(this)
            pose = this.pose;
        end

        function setPose(this, pose)
            this.pose = pose;
        end
        
        function data = getData(this, curve)
            times = curve.getTimes(this.dataRate);
            data = this.getPoseData(curve, times);
        end
        
        function data = getPoseData(this, curve, times)
            % curve.getPoses(times): robot pose, 7xN
            % this.pose: pose of vicon frame in the world, 6x1
            % this.objectPose: pose of calibu target in the world, 6x1
            % data: Nx6
            Twv = epose_to_hpose(this.pose); % 4x4 
            Two = epose_to_hpose(this.objectPose); % 4x4
            Tvo = Twv \ Two;
            Opose = hpose_to_epose(Tvo); % object pose in vicon, 6x1
            data = repmat(Opose', numel(times), 1);
        end
    end


end
