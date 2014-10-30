function genpaths(count, generator)
    
    processInput(nargin);
    
    for i = 1 : count
        generator.generate();
    end
    
    function processInput(argCount)
        if argCount < 1
            count = 1;
        end
        
        if argCount < 2
            generator = 'config/path_generators/default.mat';
        end
        
        if ischar(generator)
            generator = PathGeneratorFactory.create(generator);
        end
    end

end