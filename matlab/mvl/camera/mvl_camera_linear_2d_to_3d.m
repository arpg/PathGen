% MVL_CAMERA_LINEAR_2D_TO_3D projects a 2D point in the image plane into a 3D
%   unit vector.
%
%   [RAY] = MVL_CAMERA_LINEAR_2D_TO_3D( PT, CMOD ) returns the 3D unit ray of
%   projection defined by the point, and the 3x3 intrinsic camera parameters in
%   CMOD.
%
%   [RAY,DRAY] = MVL_CAMERA_LINEAR_2D_TO_3D( PT, CMOD ) returns the 3D unit ray
%   of projection, as well as the partial derivatives of the projection function
%   with respect to the pixel location.
%
%   This function uses the computer vision coordinate frame convention.
%
%   See also MVL_CAMERA_3D_TO_2D
%

function [ray,dray] = mvl_camera_linear_2d_to_3d( pt, cmod )

	% inverse projection
	K = mvl_camera_get_K_matrix( cmod );
    invK = inv(K);
	xn = invK*[pt;1];
    dotxn = xn.'*xn; 
    normxn = sqrt(dotxn);
    xh = xn/normxn;
%
%	invK = [ 1/fx, -sx/fx/fy, (sx*cy-cx*fy)/fx/fy  ;...
%		   [    0,      1/fy,              -cy/fya ;...
%		   [    0,         0,                   1 ];
%

	% 3x2 jacobian of inverse projection wrt to pt
    iK = invK(1:3,1:2);
    dray = (iK*normxn - (xh*xn.')*iK)/dotxn;
    ray = xh;

