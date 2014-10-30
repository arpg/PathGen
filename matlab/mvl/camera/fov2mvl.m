% Given vertical and horizontal field of view and the image size, return an MVL
% linear camera model.
function cmod = fov2mvl( fovx, fovy, width, height )

    % focal lengths based on FOV and image plane size
    fx = width/2/tan( fovx/2 );
    fy = height/2/tan( fovy/2 );
    
    % principal point in exact center of image plane
    cx = width/2;
    cy = height/2;          

    % no skew 
    sx = 0;

    cmod.type     = 'MVL_CAMERA_LINEAR';
    cmod.name     = 'fov2mvl';
    cmod.serialno = -1;
    forward       = [1; 0; 0]; 
    right         = [0; 1; 0];
    down          = [0; 0; 1];
    cmod.RDF      = [ right'; down'; forward' ];
    cmod.width    = width;
    cmod.height   = height;
    cmod.fx       = fx; 
    cmod.cx       = cx;
    cmod.fy       = fy;
    cmod.cy       = cy;
    cmod.sx       = sx;

