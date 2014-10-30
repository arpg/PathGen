
function xprime = quat_inverse_op(x)

   r = quat_to_rotmat(x(4:7));
   b = [x(4); -x(5:7)];
   xprime = [ [-r'] * x(1:3) ; b];
