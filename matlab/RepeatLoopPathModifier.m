classdef RepeatLoopPathModifier < PathModifier

    properties (Access = private)
        loopCount;
    end

    methods (Access = public)
        function this = RepeatLoopPathModifier()
            loopCount = 2;
        end

        function loopCount = getLoopCount(this)
            loopCount = this.loopCount;
        end

        function setLoopCount(this, loopCount)
            assert(loopCount > 0, 'loopCount > 0');
            this.loopCount = loopCount;
        end
        
        function poses = modify(this, poses)
            poses = repmat(poses, 1, this.loopCount);
        end
    end

end
