classdef ArcPathBuilderFactory < handle
    
    methods (Access = public, Static)
        function builder = create(filename)
            % check if filename given
            if nargin < 1
                % assign default filename
                filename = 'config/arc_path_builders/default.mat';
            end

            % read config structure
            config = load(filename);
            
            % check if valid config file
            if ~isfield(config, 'type')
                error('invalid config file');
            end

            this = ArcPathBuilderFactory;

            % build specified type
            switch config.type
                case 'standard'
                    builder = this.createArcPathBuilder(config);
                case 'closed'
                    builder = this.createArcClosedPathBuilder(config);
                otherwise
                    error('''%s'' type not recognized', config.type);
            end
        end
    end

    methods (Access = private, Static)
        function builder = createArcPathBuilder(config)
            builder = ArcPathBuilder;
            builder.setPoses(ArcPathBuilderFactory.loadPoses(config));
            arcBuilder = ArcBuilderFactory.create(config.arcBuilder);
            builder.setArcBuilder(arcBuilder);
        end
        
        function builder = createArcClosedPathBuilder(config)
            builder = ArcClosedPathBuilder;
            builder.setPoses(ArcPathBuilderFactory.loadPoses(config));
            arcBuilder = ArcBuilderFactory.create(config.arcBuilder);
            builder.setArcBuilder(arcBuilder);
        end

        function poses = loadPoses(config)
            if isfield(config, 'poses')
                poses = config.poses;
            else
                poses = zeros(7, 3);
                poses(1, 2:3) = 1;
                poses(2, 3) = 1;
                poses(7, :) = 1;
            end
        end
    end
    
end
