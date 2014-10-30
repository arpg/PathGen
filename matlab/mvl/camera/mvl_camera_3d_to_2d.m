% MVL_CAMERA_3D_TO_2D projects a 3D point to a 2D point
%
%   PT2 = MVL_CAMERA_3D_TO_2D( PT3, HPOSE,  CAMERA_MODEL ) projects PT3 to PT2
%   using the camera model specified in CAMERA_MODEL.   HPOSE is a 4x4
%   homogeneous pose matirx.
%
%   [PT2,J] = MVL_CAMERA_3D_TO_2D( PT3, HPOSE, CAMERA_MODEL ) projects PT3 to
%   PT2 using the camera model specified in CAMERA_MODEL and computes the
%   jacobian of the projection function evaluated at PT3.
%
%   This function automatically selects the correct projection model based on
%   the CAMERA_MODEL.type field.

function [pt2,J] = mvl_camera_3d_to_2d( pt3, hpose, cmod )


    % first, put point in CV frame
	% transform point into camera frame
	xcv = cmod.RDF*hpose(1:3,1:3)'*(pt3-hpose(1:3,4));

    if( nargout <= 1)
        if( strcmp( cmod.type, 'MVL_CAMERA_LINEAR' ) || strcmp( cmod.type, 'MVL_CAMERA_LUT' ) == true )
            pt2 = mvl_camera_linear_3d_to_2d( xcv, cmod );
        elseif( cmod.type == 'MVL_CAMERA_WARPED' )
            pt2 = mvl_camera_warped_3d_to_2d( xcv, cmod );
        else
            error('unknown camera model');
        end
    % derivatives needed?
    elseif(nargout == 2)
        if( cmod.type == 'MVL_CAMERA_LINEAR' )
            [pt2,J] = mvl_camera_linear_3d_to_2d( xcv, cmod );
        elseif( cmod.type == MVL_CAMERA_WARPED )
            [pt2,J] = mvl_camera_warped_3d_to_2d( xcv, cmod );
        else
            error('error: unknown or unsuppored camera model');
        end
        % transform Jacobian into external coordinate frame
        J = J*cmod.RDF*hpose(1:3,1:3)';
    end


