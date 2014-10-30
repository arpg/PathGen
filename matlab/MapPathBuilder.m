classdef (Abstract) MapPathBuilder < PathBuilder

    properties (Access = protected)
        map;
    end

    methods (Access = public)
        function this = MapPathBuilder()
            this.map = Map;
        end

        function map = getMap(this)
            map = this.map;
        end

        function setMap(this, map)
            this.map = map;
        end

        function points = getWaypoints(this)
            indices = this.getPathIndices();
            points = this.map.nodes(:, indices);
        end
    end

    methods (Access = public, Abstract)
        getPathIndices(this);
    end

end
