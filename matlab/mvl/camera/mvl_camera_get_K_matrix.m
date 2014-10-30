% K = MVL_CAMERA_GET_K_MATRIX( cmod ).  TODO, convert K to the
% appropriate convention, based on cmod.forward, cmod.right, and cmod.down.

function K = mvl_camera_get_K_matrix( cmod )

    K = zeros(3);
    K(1,1) = cmod.fx;
    K(1,2) = cmod.sx;
    K(1,3) = cmod.cx;
    K(2,2) = cmod.fy;
    K(2,3) = cmod.cy;
    K(3,3) = 1;

