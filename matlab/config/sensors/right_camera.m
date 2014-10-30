camera = {};
camera.name = 'Right';
camera.pose = [ 0.1; -0.2; 0.5; 0; 0; 0 ];
camera.frameRate = 60;
camera.sky = [ 0; 0; -1 ];
camera.fov = 100;
camera.imageHeight = 640;
camera.imageWidth = 480;
save('config/sensors/right_camera', '-struct', 'camera');