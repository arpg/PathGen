classdef PathGenerator < handle
    
    properties (Access = private)
        curveBuilder;
        curveModifier;
        curveWriter;
    end
    
    methods (Access = public)
        function this = PathGenerator()
        end

        function curveBuilder = getCurveBuilder(this)
            curveBuilder = this.curveBuilder;
        end

        function setCurveBuilder(this, curveBuilder)
            this.curveBuilder = curveBuilder;
        end

        function curveModifier = getCurveModifier(this)
            curveModifier = this.curveModifier;
        end

        function setCurveModifier(this, curveModifier)
            this.curveModifier = curveModifier;
        end

        function curveWriter = getCurveWriter(this)
            curveWriter = this.curveWriter;
        end

        function setCurveWriter(this, curveWriter)
            this.curveWriter = curveWriter;
        end
        
        function generate(this)
            curve = this.curveBuilder.build();
            curve = this.curveModifier.modify(curve);
            this.curveWriter.write(curve);
        end
    end
    
end
