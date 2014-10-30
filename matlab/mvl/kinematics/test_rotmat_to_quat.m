
  pqr = [pi; 0; 0] + 0.00*randn(3,1);
  pqr*180/pi
  R = eulerPQR_to_rotmat( pqr )
%  R = [-1 0 0; 0 -1 0; 0 0 -1] * eulerPQR_to_rotmat( randn(3,1)*0.01)

  [ normalize(eulerPQR_to_quat( rotmat_to_eulerPQR( R )  ))  rotmat_to_quat( R ) ...
    normalize(eulerPQR_to_quat( rotmat_to_eulerPQR( R )  )) - rotmat_to_quat( R )]

  180*quat_to_eulerPQR( rotmat_to_quat( R ))/pi
  180*rotmat_to_eulerPQR( R )/pi
