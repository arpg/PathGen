classdef ArcClosedPathBuilder < ArcPathBuilder

    properties (Access = private)
    end

    methods (Access = public)
        function this = ArcClosedPathBuilder()
        end
    end

    methods (Access = protected)
        function arcs = getArcs(this)
            arcs = getArcs@ArcPathBuilder(this);

            this.arcBuilder.setPrevPose(this.poses(:, end - 1));
            this.arcBuilder.setCurrPose(this.poses(:, end));
            this.arcBuilder.setNextPose(this.poses(:, 1));
            arcs(end + 1) = this.arcBuilder.build();

            this.arcBuilder.setPrevPose(this.poses(:, end));
            this.arcBuilder.setCurrPose(this.poses(:, 1));
            this.arcBuilder.setNextPose(this.poses(:, 2));
            arcs(end + 1) = this.arcBuilder.build();
        end

        function segments = getSegments(this, arcs)
            % merge arcs and source edges
            source = arcs(end).getTarget();
            segments = this.getSourceSegments(arcs, source);
        end
    end

end
