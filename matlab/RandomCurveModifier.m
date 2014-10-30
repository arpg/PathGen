classdef RandomCurveModifier < CurveModifier

    properties (Access = private)
        modifiers;
        maxMods;
        minMods;
        replace;
    end

    methods (Access = public)
        function this = RandomCurveModifier()
            this.modifiers = EmptyCurveModifier.empty(0, 0);
            this.maxMods = 1;
            this.minMods = 1;
            this.replace = false;
        end

        function count = getModifierCount(this)
            count = length(this.modifiers);
        end

        function randomModifier = getModifier(this, index)
            randomModifier = this.modifiers(index);
        end

        function addModifier(this, randomModifier)
            this.modifiers(end + 1) = randomModifier;
        end

        function replace = doesReplacement(this)
            replace = this.replace;
        end

        function setReplacement(this, replace)
            this.replace = replace;
        end

        function maxMods = getMaxMods(this)
            maxMods = this.maxMods;
        end

        function setMaxMods(this, maxMods)
            assert(maxMods >= 0, 'maxMods >= 0');

            % shift minMods as needed
            if (maxMods < this.minMods)
                this.minMods = maxMods;
            end

            this.maxMods = maxMods;
        end

        function minMods = getMinMods(this)
            minMods = this.minMods;
        end

        function setMinMods(this, minMods)
            assert(minMods >= 0, 'minMods >= 0');

            % shift maxMods as needed
            if (minMods > this.maxMods)
                this.maxMods = minMods;
            end

            this.minMods = minMods;
        end

        function curve = modify(this, curve)
            % get random modifier indices
            this.assertReadyForModification();
            indices = this.getRandomModifierIndices();

            % modify curve with each modifier
            for i = 1 : length(indices)
                curve = this.modifiers(indices(i)).modify(curve);
            end
        end
    end
    
    methods (Access = protected)
        function poses = getNewPoses(this, curve)
            error('operation no supported');
        end
    end

    methods (Access = private)
        function indices = getRandomModifierIndices(this)
            randCount = this.getRandomModifierCount();
            options = 1 : this.getModifierCount();
            indices = zeros(1, randCount);

            % get each modifier index
            for i = 1 : randCount
                randIndex = randi(length(options));
                indices(i) = options(randIndex);

                % remove if replacement disabled
                if ~this.replace
                    options(randIndex) = [];
                end
            end
        end

        function count = getRandomModifierCount(this)
            tmaxMods = this.maxMods;
            
            if ~this.replace
                tmaxMods = min(this.maxMods, this.getModifierCount());
            end
            
            range = tmaxMods - this.minMods + 1;
            count = randi(range) + this.minMods - 1;
        end

        function assertReadyForModification(this)
            assert(this.getModifierCount() > 0, 'empty modifier list');
            check = this.replace || this.minMods <= this.getModifierCount();
            assert(check, 'insufficient number of modifiers for minMod value');
        end
    end

end
