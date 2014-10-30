classdef MapFactory < handle
    
    methods (Access = public, Static)
        function map = create(filename)
            % check if filename given
            if nargin < 1
                % assign default filename
                filename = 'config/maps/default.mat';
            end

            % read config structure
            config = load(filename);
            
            % check if valid config file
            if ~isfield(config, 'type')
                error('invalid config file');
            end
            
            this = MapFactory;
            
            % build specified type
            switch config.type
                case 'custom'
                    map = Map;
                    map.nodes = config.nodes;
                    map.links = config.links;
                case 'city'
                    map = this.createCityMap(config);
                case 'grid'
                    map = this.createGridMap(config);
                otherwise
                    error('''%s'' type not recognized', config.type);
            end
        end
    end

    methods (Access = private, Static)
        function map = createCityMap(config)
            builder = CityMapBuilder;
            builder.setHeight(config.height);
            builder.setWidth(config.width);
            builder.setBlockSize(config.blockSize);
            builder.setStreetSize(config.streetSize);
            builder.setCrossRatio(config.crossRatio);
            builder.setOffset(config.offset);
            map = builder.build();
        end

        function map = createGridMap(config)
            builder = GridMapBuilder;
            builder.setHeight(config.height);
            builder.setWidth(config.width);
            builder.setGridSize(config.blockSize);
            builder.setOffset(config.offset);
            map = builder.build();
        end
    end
    
end
