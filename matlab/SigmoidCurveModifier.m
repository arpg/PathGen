classdef SigmoidCurveModifier < CurveModifier

    properties (Access = private)
        amplitude;
        period;
        verShift;
        horShift;
        direction;
    end

    methods (Access = public)
        function this = SigmoidCurveModifier()
            this.amplitude = 1;
            this.period    = 1;
            this.verShift  = 0;
            this.horShift  = 0;
            this.direction = [ 0; 0; 1 ];
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

        function verShift = getVerticalShift(this)
            verShift = this.verShift;
        end

        function setVerticalShift(this, verShift)
            this.verShift = verShift;
        end

        function horShift = getHorizontalShift(this)
            horShift = this.horShift;
        end

        function setHorizontalShift(this, horShift)
            this.horShift = horShift;
        end

        function direction = getDirection(this)
            direction = this.direction;
        end

        function setDirection(this, direction)
            this.direction = direction;
        end
    end
    
    methods (Access = protected)
        function poses = getNewPoses(this, curve, times)
            poses = curve.getPoses(times);
            count = size(poses, 2);
            
            a = this.amplitude;
            b = 2 * pi / this.period;
            c = this.horShift;
            d = this.verShift;
            
            mag = a * sin(b * (times - c)) + d;
            position = this.direction * mag;
            position = [ position; zeros(3, count) ];
            
            for i = 1 : count
                poses(1:6, i) = compound_op(poses(:, i), position(:, i));
            end
        end
    end

end
