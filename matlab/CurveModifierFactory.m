classdef CurveModifierFactory < handle
    
    methods (Access = public, Static)
        function modifier = create(filename)
            % check if filename given
            if nargin < 1
                % assign default filename
                filename = 'config/curve_modifiers/default.mat';
            end

            % read config structure
            config = load(filename);
            
            % check if valid config file
            if ~isfield(config, 'type')
                error('invalid config file');
            end
            
            this = CurveModifierFactory;
            
            % build specified type
            switch config.type
                case 'empty'
                    modifier = EmptyCurveModifier;
                case 'sigmoid'
                    modifier = this.createSigmoidModifier(config);
                case 'waddle'
                    modifier = this.createWaddleModifier(config);
                case 'closure'
                    modifier = this.createLoopClosureModifier(config);
                case 'random'
                    modifier = this.createRandomModifier(config);
                case 'group'
                    modifier = this.createGroupModifier(config);
                otherwise
                    error('''%s'' type not recognized', config.type);
            end
        end
    end

    methods (Access = public, Static)
        function modifier = createSigmoidModifier(config)
            modifier = SigmoidCurveModifier;
            modifier.setName(config.name);
            modifier.setSampleRate(config.sampleRate);
            modifier.setAmplitude(config.amplitude);
            modifier.setPeriod(config.period);
            modifier.setVerticalShift(config.verShift);
            modifier.setHorizontalShift(config.horShift);
            modifier.setDirection(config.direction);
        end
        
        function modifier = createWaddleModifier(config)
            modifier = WaddleCurveModifier;
            modifier.setName(config.name);
            modifier.setSampleRate(config.sampleRate);
            modifier.setPeriod(config.period);
            modifier.setHorizontalShift(config.horShift);
            modifier.setMaxRoll(config.maxRoll);
        end
        
        function modifier = createLoopClosureModifier(config)
            modifier = LoopClosureCurveModifier;
            modifier.setName(config.name);
            modifier.setOverlapTime(config.overlap);
        end
        
        function modifier = createRandomModifier(config)
            modifier = RandomCurveModifier;
            modifier.setName(config.name);
            modifier.setMaxMods(config.maxMods);
            modifier.setMinMods(config.minMods);
            modifier.setReplacement(config.replace);
            
            for i = 1 : length(config.modifiers)
                configfile = config.modifiers{i};
                submodifier = CurveModifierFactory.create(configfile);
                modifier.addModifier(submodifier);
            end
        end
        
        function modifier = createGroupModifier(config)
            modifier = GroupCurveModifier;
            modifier.setName(config.name);
            
            for i = 1 : length(config.modifiers)
                configfile = config.modifiers{i};
                submodifier = CurveModifierFactory.create(configfile);
                modifier.addModifier(submodifier);
            end
        end
    end
    
end
