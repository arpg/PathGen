
    % demonstrates some problems with Euler angles.
    % angles have to be far from the singularity.

    pqr = [ pi; 0; 0] + 2*randn(3,1);
    pqr = angle_wrap(pqr);
    R = eulerPQR_to_rotmat( pqr );

    pqr - rotmat_to_eulerPQR( R )

