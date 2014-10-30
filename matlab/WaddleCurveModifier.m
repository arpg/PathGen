classdef WaddleCurveModifier < CurveModifier

    properties (Access = private)
        amplitude;
        period;
        horShift;
        maxRoll;
    end

    methods (Access = public)
        function this = WaddleCurveModifier()
            this.amplitude = 1;
            this.period    = 1;
            this.horShift  = 0;
            this.maxRoll   = pi / 8;
        end

        function amplitude = getAmplitude(this)
            amplitude = this.amplitude;
        end

        function setAmplitude(this, amplitude)
            this.amplitude = amplitude;
        end

        function period = getPeriod(this)
            period = this.period;
        end

        function setPeriod(this, period)
            this.period = period;
        end

        function horShift = getHorizontalShift(this)
            horShift = this.horShift;
        end

        function setHorizontalShift(this, horShift)
            this.horShift = horShift;
        end

        function maxRoll = getMaxRoll(this)
            maxRoll = this.maxRoll;
        end

        function setMaxRoll(this, maxRoll)
            this.maxRoll = maxRoll;
        end
    end
    
    methods (Access = protected)
        function poses = getNewPoses(this, curve, times)
            poses = curve.getPoses(times);
            count = size(poses, 2);
            
            a = this.amplitude;
            b = 2 * pi / this.period;
            c = this.horShift;
            
            mag = a * sin(b * (times - c));
            roll =  mag / a * this.maxRoll;
            
            position = [ zeros(3, count); roll; zeros(2, count) ];
            
            for i = 1 : count
                poses(1:6, i) = compound_op(poses(:, i), position(:, i));
            end
        end
    end

end
