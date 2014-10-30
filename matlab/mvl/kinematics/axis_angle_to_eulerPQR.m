
function pqr = axis_angle_to_eulerPQR( axis, angle )

    R = axis_angle_to_rotmat( axis, angle );
    pqr = rotmat_to_eulerPQR( R );
    
if 0
    % this code is broken...
    x = axis(1);
    y = axis(2);
    z = axis(3);

    
    s = sin(angle);
    c = cos(angle);
    t = 1-c;
    if ((x*y*t + z*s) > 0.998)
        yaw = 2*atan2(x*sin(angle/2), cos(angle/2));
        pitch = pi/2;
        roll = 0;
        pqr = [roll;pitch;yaw];
        return;
    end
    if ((x*y*t + z*s) < -0.998) % south pole singularity detected
        yaw = -2*atan2(x*sin(angle/2), cos(angle/2));
        pitch = -pi/2;
        roll = 0;
        pqr = [roll;pitch;yaw];
        return;
    end

    yaw = atan2(y * s- x * z * t , 1 - (y*y+ z*z ) * t); 
    pitch = asin(x * y * t + z * s) ; 
    roll = atan2(x * s - y * z * t , 1 - (x*x + z*z) * t);
    pqr = [roll;pitch;yaw];
end
