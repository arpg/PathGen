% cmod = mvl_camera_scale( cmod, scale ) scales the parameters in the camera model,
% CMOD, by scale.  e.g. fx = scale*fx and so on.

function cmod = mvl_camera_scale( cmod, scale )

	cmod.fx = scale*cmod.fx;
	cmod.fy = scale*cmod.fy;
	cmod.cx = scale*cmod.cx;
	cmod.cy = scale*cmod.cy;
	cmod.sx = scale*cmod.sx;
	cmod.width = scale*cmod.width;
	cmod.height = scale*cmod.height;

