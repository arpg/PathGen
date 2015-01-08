classdef GroupCurveModifier < CurveModifier

    properties (Access = private)
        modifiers;
    end

    methods (Access = public)
        function this = GroupCurveModifier()
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

        function curve = modify(this, curve)
            count = this.getModifierCount();

            % modify curve with each modifier
            for i = 1 : count
                curve = this.modifiers(i).modify(curve);
            end
        end
    end
    
    methods (Access = protected)
        function poses = getNewPoses(this, curve, times)
            % do nothing
        end
    end

end
