writer = {};
writer.type = 'standard';
writer.directory = './paths';
writer.imu = 'config/sensors/imu.mat';
writer.vicon = 'config/sensors/vicon.mat';
writer.cameras{1} = 'config/sensors/left_camera.mat';
writer.writers{1} = 'config/curve_writers/render.mat';
save('config/curve_writers/figure8', '-struct', 'writer');