classdef PathGeneratorFactory < handle
    
    methods (Access = public, Static)
        function generator = create(filename)
            % check if filename given
            if nargin < 1
                % assign default filename
                filename = 'config/path_generators/default.mat';
            end

            % read config structure
            config = load(filename);
            
            % create supporting objects
            builder = CurveBuilderFactory.create(config.builder);
            modifier = CurveModifierFactory.create(config.modifier);
            writer = CurveWriterFactory.create(config.writer);
            
            % create & decoreate generator
            generator = PathGenerator;
            generator.setCurveBuilder(builder);
            generator.setCurveModifier(modifier);
            generator.setCurveWriter(writer);
        end
    end
    
end
