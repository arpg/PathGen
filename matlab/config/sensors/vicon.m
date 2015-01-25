vicon = {};
vicon.pose = [ 1; 2; 3; 0; 0; 0 ];
vicon.objectId = 0;
% pose of calibu target centroid, the same as in Calibu.pov: rot(x,90)
vicon.objectPose = [0; 0; 0; axis_angle_to_eulerPQR([1 0 0], pi/2) ]; 
vicon.dataRate = 100;
save('config/sensors/vicon', '-struct', 'vicon');