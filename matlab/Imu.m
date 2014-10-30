classdef Imu < handle

    properties (Access = private)
        dataRate;
    end

    methods (Access = public)
        function this = Imu()
            this.dataRate = 1;
        end

        function dataRate = getDataRate(this)
            dataRate = this.dataRate;
        end

        function setDataRate(this, dataRate)
            this.dataRate = dataRate;
        end
    end

end
