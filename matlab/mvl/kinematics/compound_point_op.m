
function x12 = compound_point_op(x1, x2)

    R1 = eulerPQR_to_rotmat(x1(4:6));
    x12 = [ R1*x2(1:3) + x1(1:3) ];

