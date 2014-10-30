% [axis,angle] = eulerPQR_to_axis_angle( pqr )

function [axis,angle] = eulerPQR_to_axis_angle( pqr )
 
    pqr = angle_wrap_eulerPQR( pqr );
        q = eulerPQR_to_quat( pqr );
%Equivalent
%    R = eulerPQR_to_rotmat( pqr );
%     q = rotmat_to_quat( R );

% WARNING: notation here is "rpy" or "rpq" as opposed to PQR.

[axis,angle] = quat_to_axis_angle( q );

    % keep angle between pi and -pi
    if( angle > pi )
        axis = -axis;
        angle = -(angle-2*pi);
    end
    if( angle < -pi )
        axis = -axis;
        angle = -(angle+2*pi);
    end

if 0
    % none of the routines from euclideanspace.com work.  there is some CF bug.
    % screw it, my routines are nice anyway
    rpy = angle_wrap( rpy );

    c1 = cos(rpy(3)/2);
    s1 = sin(rpy(3)/2);
    c2 = cos(rpy(2)/2);
    s2 = sin(rpy(2)/2);
    c3 = cos(rpy(1)/2);
    s3 = sin(rpy(1)/2);
    c1c2 = c1*c2;
    s1s2 = s1*s2;
    w =c1c2*c3 - s1s2*s3;
    x =c1c2*s3 + s1s2*c3;
    y =s1*c2*c3 + c1*s2*s3;
    z =c1*s2*c3 - s1*c2*s3;
    angle = 2 * acos(w);
    norm = x*x+y*y+z*z;
    if (norm < 0.001)
        % when all euler angles are zero angle =0 so we can set axis 
        % to anything to avoid divide by zero
        x=1;
        y=0;
        z=0;
    else
        norm = sqrt(norm);
        x = x/norm;
        y = y/norm;
        z = z/norm;
    end

    axis = [x;y;z];
end
