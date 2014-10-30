% MVL_CAMERA_WARPED_3D_TO_2D projects a 3D point to a 2D point
%
%   PT2 = MVL_CAMERA_WARPED_3D_TO_2D( PT3, HPOSE, CAMERA_MODEL ) projects PT3 to
%   PT2 using the camera model specified in CAMERA_MODEL. 
%
%   [PT2,J] = MVL_CAMERA_WARPED_3D_TO_2D( PT3, CAMERA_MODEL ) also computes the
%   jacobian of the projection function evaluated at PT3.
%
%   This function uses the computer vision coordinate frame convention.

function [pt2,J] = mvl_camera_warped_3d_to_2d( xcv, cmod )

% TODO

