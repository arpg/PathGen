classdef PathModifierFactory < handle
    
    methods (Access = public, Static)
        function modifier = create(filename)
            % check if filename given
            if nargin < 1
                % assign default filename
                filename = 'config/path_modifiers/default.mat';
            end

            % read config structure
            config = load(filename);
            
            % check if valid config file
            if ~isfield(config, 'type')
                error('invalid config file');
            end
            
            this = PathModifierFactory;
            
            % build specified type
            switch config.type
                case 'empty'
                    modifier = EmptyPathModifier;
                case 'randspeed'
                    modifier = this.createRandomSpeedModifier(config);
                otherwise
                    error('''%s'' type not recognized', config.type);
            end
        end
    end

    methods (Access = public, Static)
        function modifier = createRandomSpeedModifier(config)
            modifier = RandomSpeedPathModifier;
            modifier.setMaxSpeed(config.maxSpeed);
            modifier.setMinSpeed(config.minSpeed);
        end
    end
    
end
