
function qout = quat_normalize(q)

   mag = sqrt(q(1)*q(1) + q(2)*q(2) + q(3)*q(3) + q(4)*q(4));
   
   qout(1,1) = q(1) / mag;
   qout(2,1) = q(2) / mag;
   qout(3,1) = q(3) / mag;
   qout(4,1) = q(4) / mag;

