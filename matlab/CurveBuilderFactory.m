classdef CurveBuilderFactory < handle
    
    methods (Access = public, Static)
        function builder = create(filename)
            % check if filename given
            if nargin < 1
                % assign default filename
                filename = 'config/curve_builders/default.mat';
            end

            % read config structure
            config = load(filename);
            
            % check if valid config file
            if ~isfield(config, 'type')
                error('invalid config file');
            end

            this = CurveBuilderFactory;
            
            % build specified type
            switch config.type
                case 'spline'
                    builder = this.createSplineCurveBuilder(config);
                case 'pchip'
                    builder = this.createPchipCurveBuilder(config);
                case 'arc'
                    builder = this.createArcCurveBuilder(config);
                case 'path'
                    builder = this.createPathBuilderCurveBuilder(config);
                case 'fig8'
                    builder = this.createFigure8CurveBuilder(config);
                otherwise
                    error('''%s'' type not recognized', config.type);
            end
        end
    end

    methods (Access = private, Static)
        function builder = createSplineCurveBuilder(config)
            builder = SplineCurveBuilder;
            poses = CurveBuilderFactory.loadPath(config);
            builder.setPath(poses);
        end

        function builder = createPchipCurveBuilder(config)
            builder = PchipCurveBuilder;
            builder.setSampleRate(config.sampleRate);
            poses = CurveBuilderFactory.loadPath(config);
            builder.setPath(poses);
        end

        function builder = createArcCurveBuilder(config)
            builder = ArcCurveBuilder;
            builder.setArcSampleCount(config.sampleCount);
            pathBuilder = ArcPathBuilderFactory.create(config.pathBuilder);
            builder.setArcPathBuilder(pathBuilder);
            poses = CurveBuilderFactory.loadPath(config);
            builder.setPath(poses);
        end

        function builder = createPathBuilderCurveBuilder(config)
            builder = PathBuilderCurveBuilder;
            
            pathBuilder = PathBuilderFactory.create(config.pathBuilder);
            builder.setPathBuilder(pathBuilder);
            
            pathModifier = PathModifierFactory.create(config.pathModifier);
            builder.setPathModifier(pathModifier);
            
            curveBuilder = CurveBuilderFactory.create(config.curveBuilder);
            builder.setPathCurveBuilder(curveBuilder);
        end
        
        function builder = createFigure8CurveBuilder(config)
            builder = Figure8CurveBuilder;
            builder.setSampleRate(config.sampleRate);
            builder.setWidth(config.width);
            builder.setHeight(config.height);
            builder.setSpeed(config.speed);
            builder.setXOffset(config.xOffset);
            builder.setYOffset(config.yOffset);
            builder.setZOffset(config.zOffset);
        end

        function poses = loadPath(config)
            if isfield(config, 'poses')
                poses = config.poses;
            else
                poses = zeros(7, 2);
                poses(7, :) = 1;
                poses(1, 2) = 1;
            end
        end
    end
    
end
