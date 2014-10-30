% MVL_CAMERA_LINEAR_3D_TO_2D projects a 3D point to a 2D point
%
%   PT2 = MVL_CAMERA_LINEAR_3D_TO_2D( PT3, CAMERA_MODEL ) projects PT3
%   to PT2 using the camera model specified in CAMERA_MODEL.
%
%   [PT2,J] = MVL_CAMERA_LINEAR_3D_TO_2D( PT3, CAMERA_MODEL ) also
%   computes the jacobian of the projection function evaluated at PT3.
%
%   These projection functions assume the camera using the computer vision
%   coordinate frame.
%

function [h,H] = mvl_camera_linear_3d_to_2d( xcv, cmod )

	% compute projection
    K = mvl_camera_get_K_matrix( cmod );
	l = K*xcv;
	h = l(1:2,1)/l(3,1);

    % compute Jacobian
    if( nargout == 2 )
		% and the jacobian
		H = [K(1:2,1:3) - [ 0 0 h(1); 0 0 h(2) ]]/l(3,1);
    end

function [hx,H] = old_mvl_camera_linear_3d_to_2d( pt3, hpose, cmod )

    % move pt into camera cf... computes xcp = Rwc'*(xwp - * xwc )
    Rwc = hpose(1:3,1:3);
    Twc = hpose(1:3,4);
    xcp = Rwc.'*( pt3 - Twc );

    % xp = K*xcp/z.
    % NOTE that because we use robotics convention, the first component 
    % of xcp, +x, "forward", is the range component that we divide by to 
    % find the horizontal and vertical pixel location.

    % lx = K*xcp
    lx(1,1) = xcp(1);
    lx(2,1) = ( cmod.fx*xcp(2) + cmod.sx*xcp(3) + cmod.cx*xcp(1) );
    lx(3,1) = ( cmod.fy*xcp(3) + cmod.cy*xcp(1) );

    gx = xcp(1);

    % make sure point is infront of the cameras
    if( dot( Rwc(:,1), pt3 - Twc ) <= 0 )
        hx = [];
        if( nargout == 2)
            H = [];
        end
        return;
    else
        hx = lx(2:3)/gx;
    end

    % compute Jacobian
    if( nargout == 2 )
        % calc K*Rwc.' directly.  See check_3d_to_2d_jacs.m for more info.
        dldx(1,1) = Rwc(1,1);
        dldx(2,1) = cmod.cx*Rwc(1,1) + cmod.fx*Rwc(1,2) + cmod.sx*Rwc(1,3);
        dldx(3,1) = cmod.cy*Rwc(1,1) + cmod.fy*Rwc(1,3);

        dldx(1,2) = Rwc(2,1);
        dldx(2,2) = cmod.cx*Rwc(2,1) + cmod.fx*Rwc(2,2) + cmod.sx*Rwc(2,3); 
        dldx(3,2) = cmod.cy*Rwc(2,1) + cmod.fy*Rwc(2,3);

        dldx(1,3) = Rwc(3,1);
        dldx(2,3) = cmod.cx*Rwc(3,1) + cmod.fx*Rwc(3,2) + cmod.sx*Rwc(3,3);
        dldx(3,3) = cmod.cy*Rwc(3,1) + cmod.fy*Rwc(3,3);

        dgdx = dldx(1,:);
        dhdx = (gx*dldx - lx*dgdx)/(gx^2);

        H = dhdx(2:3,:); % ignore top row
    end

