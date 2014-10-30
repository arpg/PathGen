classdef PathBuilderFactory < handle
    
    methods (Access = public, Static)
        function builder = create(filename)
            % check if filename given
            if nargin < 1
                % assign default filename
                filename = 'config/path_builders/default.mat';
            end

            % read config structure
            config = load(filename);
            
            % check if valid config file
            if ~isfield(config, 'type')
                error('invalid config file');
            end
            
            this = PathBuilderFactory;
            
            % build specified type
            switch config.type
                case 'randpath'
                    builder = this.createRandomPathBuilder(config);
                case 'randloop'
                    builder = this.createRandomClosedPathBuilder(config);
                case 'direct'
                    builder = this.createDirectPathBuilder(config);
                case 'closure'
                    builder = this.createClosurePathBuilder(config);
                otherwise
                    error('''%s'' type not recognized', config.type);
            end
        end
    end

    methods (Access = private, Static)
        function builder = createRandomPathBuilder(config)
            builder = RandomPathBuilder;
            builder.setMaxEdges(config.maxEdges)
            builder.setMinEdges(config.minEdges)
            builder.setMinTurnAngle(config.minTurnAngle)
            builder.setMaxAngleWeight(config.maxAngleWeight)
            builder.setMinAngleWeight(config.minAngleWeight)
            builder.setMap(MapFactory.create(config.map));
            builder.setStartIndices(config.startIndices);
        end

        function builder = createRandomClosedPathBuilder(config)
            builder = RandomClosedPathBuilder;
            builder.setMap(MapFactory.create(config.map));

            rBuilder = PathBuilderFactory.create(config.randomBuilder);
            builder.setRandomPathBuilder(rBuilder);

            cBuilder = PathBuilderFactory.create(config.closureBuilder);
            builder.setClosurePathBuilder(cBuilder);
        end

        function builder = createDirectPathBuilder(config)
            builder = DirectPathBuilder;
            builder.setStartIndex(config.startIndex);
            builder.setGoalIndex(config.goalIndex);
            builder.setMap(MapFactory.create(config.map));
        end

        function builder = createClosurePathBuilder(config)
            builder = ClosurePathBuilder;
            builder.setMinTurnAngle(config.minTurnAngle);
            builder.setTightTurnWeight(config.tightTurnWeight);
            builder.setRetraceWeight(config.retraceWeight);
            builder.setOpenPathIndices(config.openIndices);
            builder.setMap(MapFactory.create(config.map));
        end
    end
    
end
