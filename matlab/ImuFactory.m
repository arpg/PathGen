classdef ImuFactory < handle
    
    methods (Access = public, Static)
        function imu = create(filename)
            imu = Imu;
            config = load(filename);
            imu.setDataRate(config.dataRate);
        end
    end
    
end
