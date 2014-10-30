classdef Map < handle

    properties (Access = public)
        nodes;
        links;
    end

    methods (Access = public)
        function this = Map(count)
            if nargin < 1
                count = 1;
            end

            this.nodes = zeros(3, count);
            this.links = zeros(count, count);
        end

        function count = getNodeCount(this)
            count = size(this.nodes, 2);
        end

        function linkSafe(this, a, b)
            try
                this.link(a, b);
            catch err
                if strcmp(err.identifier, 'MAP:badindex')
                    % do nothing
                else
                    rethrow(err);
                end
            end
        end

        function link(this, a, b)
            this.validateIndex(a);
            this.validateIndex(b);
            this.links(a, b) = 1;
            this.links(b, a) = 1;
        end
    end

    methods (Access = private)
        function validateIndex(this, index)
            if index <= 0 || index > this.getNodeCount()
                error('MAP:badindex', 'Invalid map index.');
            end
        end
    end

end
