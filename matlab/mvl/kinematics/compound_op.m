
function x12 = compound_op(x1, x2)

  R1 = eulerPQR_to_rotmat(x1(4:6));

  if( length(x2) == 6) % orientation on x2?
    R2 = eulerPQR_to_rotmat(x2(4:6));
    x12 = [ R1*x2(1:3) + x1(1:3); rotmat_to_eulerPQR(R1*R2)];
  else
    x12 = [ R1*x2(1:3) + x1(1:3) ];
  end

