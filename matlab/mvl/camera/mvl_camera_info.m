% MVL_CAMERA_INFO( CAMERA_MODEL )

function mvl_camera_info( cmod )

    hpose = eye(4);

%    tl = mvl_camera_2d_to_3d( [0;0], hpose, cmod );
%    tr = mvl_camera_2d_to_3d( [cmod.width;0], hpose, cmod );
%    br = mvl_camera_2d_to_3d( [cmod.width;cmod.height], hpose, cmod );
%    bl = mvl_camera_2d_to_3d( [0;cmod.height], hpose, cmod );
%    fovx = 180*acos( dot( tr, tl ) )/pi;
%    fovy = 180*acos( dot( bl, tl ) )/pi;

    fovx = 180*2*atan2( cmod.width/2, cmod.fx )/pi;
    fovy = 180*2*atan2( cmod.height/2, cmod.fy )/pi;

    fprintf('camera model info:\n');
    fprintf(' Horizontal FOV:  %f deg.\n', fovx );
    fprintf('   Verticle FOV:  %f deg.\n', fovy );

