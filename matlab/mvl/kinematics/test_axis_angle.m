clear all

%    axis = randn(3,1)
%    anlge = 2*pi*randn

%    pqr = axis_angle_to_eulerPQR( axis, angle );
for( i=1:1000 )

    pqr = angle_wrap( 2*pi*randn(3,1) );
    180/pi*pqr;
    R = eulerPQR_to_rotmat( pqr );
 
    % sometimes we get 'flipped' quats
    q1 = eulerPQR_to_quat( pqr );
    q2 = rotmat_to_quat( R );

%    if( quat_isflipped( q1, q2 ) )
%        fprintf('q2 is flipped\n');
%    end

    [ax,an] = rotmat_to_axis_angle( R );
    [axis, angle] = eulerPQR_to_axis_angle( pqr );

    % pitch greater than 90 deg. is what causes the problems...
    pqr1 = axis_angle_to_eulerPQR( ax, an );
    if( norm(pqr - pqr1) > 1e-6)
        fprintf('flipped pqr norm = %f:  ', norm(pqr - pqr1));
        if( abs(pqr(2)) > pi/2 )
            fprintf('    pqr is % -f % -f % -f', 180/pi*pqr(:));
            fprintf('    vs % -f % -f % -f', 180/pi*pqr1(:));
            fprintf(' and pitch is greater than 90 \n');
        else
            fprintf('    pqr is % -f % -f % -f\n', 180/pi*pqr(:));
        end
    else
%        fprintf('pqr looks fine\n' );
    end

        

%    [ax axis; an angle]
%    norm( [ax-axis; an-angle] )
%    180/pi*(pqr - axis_angle_to_eulerPQR( axis, angle )) % sometimes off by 180
%    180/pi*(pqr - axis_angle_to_eulerPQR( ax, an )) % sometimes off by 180
%    180/pi*(pqr - quat_to_eulerPQR( q1 ))
%    180/pi*(pqr - quat_to_eulerPQR( q2 ))
    
%    [ax,an] = rotmat_to_axis_angle( R );
%    R - axis_angle_to_rotmat( ax, an )
%    pqr = axis_angle_to_eulerPQR( ax, an )

%    R = axis_angle_to_rotmat( axis, angle )   
%    [ax,an] = rotmat_to_axis_angle( R )

%    normalize( axis ) - normalize( ax )
end
