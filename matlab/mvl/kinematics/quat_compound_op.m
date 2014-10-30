
function x3 = quat_compound_op(x1,x2)

  r1 = quat_to_rotmat(x1(4:7));
  if( length(x2) == 7) % no orientation on x2?
    x3 = [ r1*x2(1:3) + x1(1:3) ; quat_mult(x1(4:7), x2(4:7))];
  else
    x3 = [ r1*x2(1:3) + x1(1:3) ];
  end
