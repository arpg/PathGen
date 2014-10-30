
function qpose = pose_to_qpose(pose)

   qpose(1:3,1) = pose(1:3);
   qpose(4:7,1) = eulerPQR_to_quat(pose(4:6));
