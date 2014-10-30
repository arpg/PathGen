% roll  = psi
% pitch = theta
% yaw   = phi
% q = w xi yj zk

function pqr = quat_to_eulerPQR(q)
% see http://www.mathworks.com/access/helpdesk/help/toolbox/aeroblks/quaternionstoeulerangles.shtml\

  R = quat_to_rotmat(q);
  pqr(1:3,1) = rotmat_to_eulerPQR(R);

