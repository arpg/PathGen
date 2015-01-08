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
                case 'reploop'
                    modifier = this.createRepeatLoopModifier(config);
                case 'group'
                    modifier = this.createGroupModifier(config);
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

        function modifier = createRepeatLoopModifier(config)
            modifier = RepeatLoopPathModifier;
            modifier.setLoopCount(config.loopCount);
        end

        function modifier = createGroupModifier(config)
            modifier = GroupPathModifier;

            % create & add each submodifier to group
            for i = 1 : length(config.modifiers)
                submodifier = PathModifierFactory.create(config.modifiers{i});
                modifier.addModifier(submodifier);
            end
        end
    end
    
end
