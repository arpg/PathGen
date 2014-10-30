%MVL_CAMERA_WARPED_2D_TO_3D projects a 2D point in the image plane 
%                     into a 3D unit vector.
%
%   [RAY] = MVL_CAMERA_WARPED_2D_TO_3D( PT, CAMERA_MODEL ) returns the 3D
%   unit ray of projection defined by the point.
%
%   [RAY,DRAY] = MVL_CAMERA_WAPRED_2D_TO_3D( PT, CAMERA_MODEL ) returns the 3D
%   unit ray of projection, as well as the partial derivatives of the 
%   projection function with respect to the pixel location.
%
% See also MVL_CAMERA_3D_TO_2D

function [ray,dray] = mvl_camera_warped_2d_to_3d( pt, hpose, cmod )

    % TODO

