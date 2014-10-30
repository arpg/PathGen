% mvl_stereo_sanity_check( lcmod, rcmod, lposemat, rposemat )
%    make sure cameras are well positioned

function stereo_sanity_check( lcmod, rcmod, Hwlc, Hwrc )

    theta = 1.0;  % max acceptable angle between camera pointing vectors
 
    fprintf('Left camera (using the Robotics convention) :\n');
    fprintf('    Forward :  %f %f %f     (%f degrees from X axis)\n',Hwlc(1:3,1),...
            180/pi*acos(dot(Hwlc(1:3,1),[1;0;0])));
    fprintf('      Right :  %f %f %f     (%f degrees from Y axis)\n',Hwlc(1:3,2),... 
            180/pi*acos(dot(Hwlc(1:3,2),[0;1;0])));
    fprintf('       Down :  %f %f %f     (%f degrees from Z axis)\n',Hwlc(1:3,3),...
            180/pi*acos(dot(Hwlc(1:3,3),[0;0;1])));

    fprintf('Right (camera using the Robotics convention) :\n');
    fprintf('    Forward :  %f %f %f     (%f degrees from X axis)\n',Hwrc(1:3,1),...
            180/pi*acos(dot(Hwrc(1:3,1),[1;0;0])));
    fprintf('      Right :  %f %f %f     (%f degrees from Y axis)\n',Hwrc(1:3,2),... 
            180/pi*acos(dot(Hwrc(1:3,2),[0;1;0])));
    fprintf('       Down :  %f %f %f     (%f degrees from Z axis)\n',Hwrc(1:3,3),...
            180/pi*acos(dot(Hwrc(1:3,3),[0;0;1])));

    % make sure cameras are roughly pointing in the same direction
    fprintf('Stereo Camera Model Info:\n');
    fprintf('    pointing vectors differ by %.3f degrees\n',...
            acos( dot(Hwlc(1:3,1),Hwrc(1:3,1))) );
    if( acos( dot(Hwlc(1:3,1),Hwrc(1:3,1)) ) > pi*theta/180)
        fprintf('\n ** WARNING: cameras are not well aligned. **\n\n');
    end
    fprintf('    pointing vector and baseline differ by %.3f degrees\n', ...
             180/pi*acos( dot(Hwrc(1:3,1), Hwrc(1:3,4)-Hwlc(1:3,4)) ));

    if( acos( dot(Hwlc(1:3,1), Hwrc(1:3,4)-Hwlc(1:3,4)) ) < pi*89/180)
        fprintf('\n ** WARNING: optical axis and baseline are not perpendicular. **\n\n');
    end

    % place a point 2 meters infront of the cameras
    center = (Hwlc(1:3,4) + Hwrc(1:3,4))/2;
    pointing = ( Hwlc(1:3,1) + Hwrc(1:3,1))/2;

    % get an x actually in the picture
    x = center + 10*pointing + randn(3,1);
    lx = mvl_camera_3d_to_2d( x, Hwlc, lcmod );
    rx = mvl_camera_3d_to_2d( x, Hwrc, rcmod );
    while( lx(1) < 0 || lx(1) > lcmod.width  || ...
           lx(2) < 0 || lx(2) > lcmod.height || ...
           rx(1) < 0 || rx(1) > rcmod.width  || ...
           rx(2) < 0 || rx(2) > rcmod.height )
        x = center + 10*pointing + 4*randn(3,1);
        lx = mvl_camera_3d_to_2d( x, Hwlc, lcmod );
        rx = mvl_camera_3d_to_2d( x, Hwrc, rcmod );
    end

    rex = mvl_disp_to_3d( lx, rx, lcmod, rcmod, Hwlc, Hwrc );

    fprintf('   [%.2f %.2f %.2f] proj. to ', x(:));
    fprintf(' [%.2f %.2f], [%.2f %.2f]', lx(:), rx(:));
    fprintf(' and back to [%.2f %.2f %.2f]\n', rex(:));

	thresh = 1e-3;
    if( norm(rex - x) > thresh )
        fprintf('\n ** WARNING:  reprojection errors are significant. ** \n\n');
	else
        fprintf('\n Stereo camera models look good.\n\n');	
    end

    % figure out disparity mapping
    for( range = 0.01:0.5:5 )
        x = center + range*pointing;
        d = mvl_camera_3d_to_2d( x,Hwlc,lcmod) - mvl_camera_3d_to_2d(x,Hwrc,rcmod);
        fprintf('range %f maps to %f disparity\n', range, d(1) );
    end 
