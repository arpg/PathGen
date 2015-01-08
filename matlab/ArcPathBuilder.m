classdef ArcPathBuilder < handle

    properties (Access = protected, Constant)
        EPSILON = 1E-8;
    end

    properties (Access = protected)
        arcBuilder;
        poses;
    end

    methods (Access = public)
        function this = ArcPathBuilder()
            this.arcBuilder = ArcBuilder;
        end

        function arcBuilder = getArcBuilder(this)
            arcBuilder = this.arcBuilder;
        end

        function setArcBuilder(this, arcBuilder)
            this.arcBuilder = arcBuilder;
        end

        function poses = getPoses(this)
            poses = this.poses;
        end

        function setPoses(this, poses)
            this.poses = poses;
        end

        function path = build(this)
            arcs = this.getArcs();
            segments = this.getSegments(arcs);
            path = ArcPath(segments);
        end
    end

    methods (Access = protected)
        function arcs = getArcs(this)
            count = size(this.poses, 2) - 2;
            arcs = Arc.empty(0, count);

            % create each internal arc
            for i = 1 : count
                this.arcBuilder.setPrevPose(this.poses(:, i + 0));
                this.arcBuilder.setCurrPose(this.poses(:, i + 1));
                this.arcBuilder.setNextPose(this.poses(:, i + 2));
                arcs(i) = this.arcBuilder.build();
            end
        end

        function segments = getSegments(this, arcs)
            % merge arcs and source edges
            source = this.poses(:, 1);
            segments = this.getSourceSegments(arcs, source);

            % create final edge
            source = segments(end).getTarget();
            target = this.poses(:, end);
            distance = norm(target - source);

            % add edge if valid
            if distance > this.EPSILON
                segments(end + 1) = Edge(source, target);
            end
        end

        function segments = getSourceSegments(this, arcs, source)
            % create max possible list size
            count = 2 * length(arcs) + 2;
            segments(count) = Arc;
            index = 0;

            % create leading edge for each arc
            for i = 1 : length(arcs)
                target = arcs(i).getSource();
                distance = norm(target - source);

                % add edge if valid
                if distance > this.EPSILON
                    index = index + 1;
                    segments(index) = Edge(source, target);
                    source = segments(index).getTarget();
                end

                % add arc if valid
                if arcs(i).getAngle() > this.EPSILON
                    index = index + 1;
                    segments(index) = arcs(i);
                    source = segments(index).getTarget();
                end
            end

            % trim empty cells
            segments = segments(1 : index);
        end
    end

end
