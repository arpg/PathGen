% not working
function [axis,angle] = rotmat_to_axis_angle( R )

    q = rotmat_to_quat( R );
    [axis,angle] = quat_to_axis_angle( q );


if 0
    % see http://www.martinb.com/maths/geometry/rotations/conversions

    if( abs(R(1,2)-R(2,1)) < eps && ...
        abs(R(1,3)-R(3,1)) < eps && ...
        abs(R(2,3)-R(3,2)) < eps)
        % singularity found
        if ( abs(R(1,2)+R(2,1)) < eps && ...
             abs(R(1,3)+R(3,1)) < eps && ...
             abs(R(2,3)+R(3,2)) < 0.1)
            % this singularity is identity matrix so angle = 0
            % note epsilon is greater in this case since we only have to
            % distinguish between 0 and 180 degrees
            angle = 0;
            x = 1; % axis is arbitrary
            y = 0;
            z = 0;
            return;
        end
        % otherwise this singularity is angle = 180
        angle = pi;

        x = (R(1,1)+1)/2;
        if (x > 0) % can only take square root of positive number,
                   % always true for orthogonal matrix
            x = sqrt(x);
        else
            x = 0;  %in case matrix has become de-orthogonalised
        end

        y = (R(2,2)+1)/2;
        if (y > 0)
               y = qrt(y);
        else
            y = 0;
        end

        z = (R(3,3)+1)/2;
        if (z > 0)
            z = sqrt(z);
        else
            z = 0;
        end

        if( abs(x)<eps && ~abs(y)<eps  && ~abs(z)<eps  ) 
            y = -y;
        elseif(abs(y)<eps && ~abs(z)<eps)
            z = -z;
        elseif( abs(z)<eps )
            x = -x;
        elseif ((R(1,2) > 0) && (R(1,3) > 0) && (R(2,3) > 0))
            return;
        elseif((R(2,3) > 0))
            x=-x;
        elseif((R(1,3) > 0))
            y=-y;
        elseif((R(1,2) > 0))
            z=-z;
        end
        return;
    end

    s = sqrt((R(3,2) - R(2,3))*(R(3,2) - R(2,3)) +  ...
             (R(1,3) - R(3,1))*(R(1,3) - R(3,1)) + ...
             (R(2,1) - R(1,2))*(R(2,1) - R(1,2))); % used to normalise
    if( abs(s) < 0.001)
        s=1; % prevent divide by zero, should not happen if matrix is
             % orthogonal and should be caught by singularity test above, 
             % but I've left it in just in case
    end
    angle = acos(( R(1,1) + R(2,2) + R(3,3) - 1)/2);

    x = (R(3,2) - R(2,3))/s;
    y = (R(1,3) - R(3,1))/s;
    z = (R(2,1) - R(1,2))/s;

    axis = [x;y;z];
end
