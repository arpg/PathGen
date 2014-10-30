classdef PathBuilderCurveBuilder < CurveBuilder
    
    properties (Access = private)
        pathBuilder;
        pathModifier;
        curveBuilder;
    end
    
    methods (Access = public)
        function this = PathBuilderCurveBuilder()
        end

        function pathBuilder = getPathBuilder(this)
            pathBuilder = this.pathBuilder;
        end

        function setPathBuilder(this, pathBuilder)
            this.pathBuilder = pathBuilder;
        end

        function pathModifier = getPathModifier(this)
            pathModifier = this.pathModifier;
        end

        function setPathModifier(this, pathModifier)
            this.pathModifier = pathModifier;
        end

        function curveBuilder = getPathCurveBuilder(this)
            curveBuilder = this.curveBuilder;
        end

        function setPathCurveBuilder(this, curveBuilder)
            this.curveBuilder = curveBuilder;
        end
        
        function curve = build(this)
            poses = this.pathBuilder.build();
            poses = this.pathModifier.modify(poses);
            this.curveBuilder.setPath(poses);
            curve = this.curveBuilder.build();
        end
    end
    
end
