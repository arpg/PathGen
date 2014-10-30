% MVL_CAMERA_2D_TO_3D projects a 2D point in the image plane into a 3D unit vector.
%
%   RAY = MVL_CAMERA_2D_TO_3D( PT, HPOSE, CAMERA_MODEL ) returns the 3D
%   unit ray of projection defined by the point. HPOSE is a 4x4 homogeneous pose
%   matirx.
%
%   [RAY,J] = MVL_CAMERA_2D_TO_3D( PT, HPOSE, CAMERA_MODEL ) returns the 3D
%   unit ray of projection, as well as the partial derivatives (the Jacobian, J) 
%   of the projection function with respect to the pixel location.
%
%   See also MVL_CAMERA_3D_TO_2D

function [ray,J] = mvl_camera_2d_to_3d( pt2, hpose, cmod )

    if( nargout <= 1)
        if( cmod.type == 'MVL_CAMERA_LINEAR' )
            ray = mvl_camera_linear_2d_to_3d( pt2, cmod );
        elseif( cmod.type == 'MVL_CAMERA_WARPED' )
            ray = mvl_camera_warped_2d_to_3d( pt2, cmod);
        else
            error('unknown camera model');
        end
    % derivatives needed?
    elseif(nargout == 2)
        if( cmod.type == 'MVL_CAMERA_LINEAR')
            [ray,J] = mvl_camera_linear_2d_to_3d( pt2, cmod );
        elseif( cmod.type == 'MVL_CAMERA_WARPED' )
            [ray,J] = mvl_camera_warped_2d_to_3d( pt2, cmod );
        else
            error('error: unknown or unsuppored camera model');
        end
    end

    % convert results to users coordinate frame:
	ray = inv(cmod.RDF)*ray; % swap coordinates
    ray = hpose(1:3,1:3)*ray; % and rotate

	% same for J 
    if( nargout == 2)
        J = inv(cmod.RDF)*J; % swap coordinates
        J = hpose(1:3,1:3)*J; % and rotate
    end


