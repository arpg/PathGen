classdef CurveWriterFactory < handle
    
    methods (Access = public, Static)
        function writer = create(filename)
            % check if filename given
            if nargin < 1
                % assign default filename
                filename = 'config/curve_writer/default.mat';
            end

            % read config structure
            config = load(filename);
            
            % check if valid config file
            if ~isfield(config, 'type')
                error('invalid config file');
            end
            
            this = CurveWriterFactory;
            
            % build specified type
            switch config.type
                case 'standard'
                    writer = this.createStandardWriter(config);
                case 'mapgraph'
                    writer = this.createMapGraphWriter(config);
                otherwise
                    error('''%s'' type not recognized', config.type);
            end
        end
    end

    methods (Access = private, Static)
        function writer = createStandardWriter(config)
            writer = GroupCurveFileWriter;
            writer.setDirectory(config.directory);

            % add imu data writer
            imu = ImuFactory.create(config.imu);
            writer.addWriter(ImuDataWriter(imu));
            
            % add camera pose writer for each camera
            for i = 1 : length(config.cameras)
                camera = CameraFactory.create(config.cameras{i});
                writer.addWriter(CameraPoseWriter(camera));
            end

            % add description writer
            writer.addWriter(CurveDescriptionWriter);
            
            % add each sub-writer to group
            for i = 1 : length(config.writers)
                member = CurveWriterFactory.create(config.writers{i});
                writer.addWriter(member);
            end
        end
        
        function writer = createMapGraphWriter(config)
            writer = MapCurveGraphWriter;
            writer.setMap(MapFactory.create(config.map));
        end
    end
    
end
