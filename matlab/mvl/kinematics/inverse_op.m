
function ipose = inverse_op(pose)

  R = eulerPQR_to_rotmat(pose(4:6));
  ipose = [-R'*pose(1:3); rotmat_to_eulerPQR(R')];

%  ipose = qpose_to_epose( quat_inverse_op( epose_to_qpose( pose ) ) );
