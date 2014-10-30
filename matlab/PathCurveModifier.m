classdef GroupPathModifier < PathModifier

    properties (Access = private)
        modifiers;
    end

    methods (Access = public)
        function this = GroupPathModifier()
            this.modifiers = [];
        end

        function count = getModifierCount(this)
            count = length(this.modifiers);
        end

        function modifier = getModifier(this, index)
            modifier = this.modifiers(index);
        end

        function addModifier(this, modifier)
            this.modifiers = [ this.modifiers modifier ];
        end

        function poses = modify(this, poses)
            count = this.getModifierCount();

            % modify path with each modifier
            for i = 1 : count
                poses = this.modifiers.modify(poses);
            end
        end
    end

end
