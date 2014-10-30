function [ax,an] = quat_to_axis_angle( q )

    n = norm( q(2:4) );
    if( n > 0 ) 
        ax = q(2:4)/norm( q(2:4) );
        an = 2*acos( q(1) );
    else
        ax = [1;0;0]; 
        an = 2*acos( q(1) );
    end

