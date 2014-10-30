% angle = angle_wrap( angle ) where angle is a scalar angle in radians

function angle = angle_wrap( angle )

	if( size( angle,1 ) ~= 1 || size( angle, 2 ) ~= 1 )
		error( 'angle_wrap() -- angle must be a scalar' );
	end

    while( angle > pi )
        angle = angle - 2*pi;
    end
    while( angle < -pi )
        angle = angle + 2*pi;
    end

