
function pose = qpose_to_pose(qpose)
 
   pose(1:3,1) = qpose(1:3);
   pose(4:6,1) = quat_to_eulerPQR(qpose(4:7));

