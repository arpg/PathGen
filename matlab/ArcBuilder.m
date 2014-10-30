classdef ArcBuilder < handle

    properties (Access = private)
        maxIdealRadius;
        maxSpeed;
        prevPose;
        currPose;
        nextPose;
    end

    methods (Access = public)
        function this = ArcBuilder()
            this.maxIdealRadius = 1;
            this.maxSpeed = 1;

            % create default poses
            poses = zeros(7, 3);
            poses(1, 2:3) = 1;
            poses(2, 3) = 1;
            poses(7, :) = 1;

            this.prevPose = poses(:, 1);
            this.currPose = poses(:, 2);
            this.nextPose = poses(:, 3);
        end

        function maxIdealRadius = getMaxIdealRadius(this)
            maxIdealRadius = this.maxIdealRadius;
        end

        function setMaxIdealRadius(this, maxIdealRadius)
            this.maxIdealRadius = maxIdealRadius;
        end

        function maxSpeed = getMaxSpeed(this)
            maxSpeed = this.maxSpeed;
        end

        function setMaxSpeed(this, maxSpeed)
            this.maxSpeed = maxSpeed;
        end

        function prevPose = getPrevPose(this)
            prevPose = this.prevPose;
        end

        function setPrevPose(this, prevPose)
            this.prevPose = prevPose;
        end

        function currPose = getCurrPose(this)
            currPose = this.currPose;
        end

        function setCurrPose(this, currPose)
            this.currPose = currPose;
        end

        function nextPose = getNextPose(this)
            nextPose = this.nextPose;
        end

        function setNextPose(this, nextPose)
            this.nextPose = nextPose;
        end

        function arc = build(this)
            % convert to current pose's coordinate frame
            ba = this.prevPose(1:3) - this.currPose(1:3);
            bc = this.nextPose(1:3) - this.currPose(1:3);
            baLen = norm(ba);
            bcLen = norm(bc);
            baUnit = ba / baLen;
            bcUnit = bc / bcLen;
            
            % compute length ratio (actual / max possible)
            lenRatio = (ba' * bc) / (baLen * bcLen);
            lenRatio = min(max(lenRatio, -1), 1);
            
            % check if 0° or 180° at corner
            if abs(1 - abs(lenRatio)) < 1E-4
                arc = Arc;
                this.currPose(4:6) = baUnit;
                arc.setSpeed(this.currPose(7));
                arc.setSource(this.currPose);
                arc.setTarget(this.currPose);
                arc.setCenter(this.currPose(1:3));
                arc.setAngle(0);
                arc.setAxis([ 0; 0; 1]);
                return;
            end
            
            % compute angle at corner
            edgeAngle = acos(lenRatio);
            arcAngle = pi - edgeAngle;
            halfEdgeAngle = edgeAngle / 2;
            halfArcAngle = arcAngle / 2;
            
            % compute ideal arc radius
            angleScale = edgeAngle / pi;
            speedScale = this.currPose(7) / this.maxSpeed;
            idealRadius = angleScale * speedScale * this.maxIdealRadius;
            
            % compute max arc radius
            maxTangent = min(baLen / 2, bcLen / 2);
            maxRadius = maxTangent * sin(halfEdgeAngle) / ...
                sin(halfArcAngle);
            
            % select best radius
            radius = min(maxRadius, idealRadius);
            tangent = radius * sin(halfArcAngle) / sin(halfEdgeAngle);
            
            % compute center of arc
            centerDist = tangent * cos(halfEdgeAngle);
            centerDist = centerDist + radius * cos(halfArcAngle);
            centerDir = (baUnit + bcUnit) / 2;
            centerUnit = centerDir / norm(centerDir);
            center = centerUnit * centerDist + this.currPose(1:3);
            
            % compute axis of rotation
            axisDir = cross(bc, ba);
            axis = axisDir / norm(axisDir);
            
            % compute tangent points
            posIn = baUnit * tangent + this.currPose(1:3);
            posOut = bcUnit * tangent + this.currPose(1:3);
            
            % compute speed in & out
            ratioIn = tangent / baLen;
            ratioOut = tangent / bcLen;

            speedIn = ratioIn * this.prevPose(7) + ...
                    (1 - ratioIn) * this.currPose(7);

            speedOut = ratioOut * this.nextPose(7) + ...
                    (1 - ratioOut) * this.currPose(7);

            % create in & out poses
            inPose = [ posIn; zeros(3, 1); speedIn ];
            outPose = [ posOut; zeros(3, 1); speedOut ];

            % create & decorate arc
            arc = Arc;
            arc.setSpeed(this.currPose(7));
            arc.setSource(inPose);
            arc.setTarget(outPose);
            arc.setCenter(center);
            arc.setAngle(arcAngle);
            arc.setAxis(axis);
        end
    end

end
