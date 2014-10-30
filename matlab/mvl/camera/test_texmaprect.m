%
function test

    load mandrill; % texture is 'X', cmap is 'map'
    tex = uint8( X );

    cmod = mvl_camera_read( 'lcmod.xml' );
	cmod_pose = epose_to_hpose( [0;0;0;0;0;0] ); % put the camera at the origin

	plane_pose = epose_to_hpose( [3;0;0;0;0;pi] ); % plane pose
	plane_width = 1;
	plane_height = 1;

    img = uint8( zeros( cmod.height, cmod.width ) );

	% render the texture
	render_texrect( plane_pose, plane_width, plane_height, tex, cmod_pose, cmod, img );
    imshow( img );

	th = 0.1;
	dpose = epose_to_hpose( [0;0;0;th;th/3;th/2] );
	dpose = epose_to_hpose( [0;0;0;th;0;0] ); % roll
	dpose = epose_to_hpose( [0;0;0;0;0;th] ); % roll
%	dpose = epose_to_hpose( [0;0;0;0;th;0] ); % pitch
%	dpose = epose_to_hpose( [0;0;0;0;0;th] ); % yaw
    for( th = 0:0.1:10*pi+0.1 )

		render_texrect( plane_pose, plane_width, plane_height, ...
                        tex, cmod_pose, cmod, img );
		plane_pose = hpose_compound_op( plane_pose, dpose );

        waitforbuttonpress;
        imshow( img );
        img = uint8( zeros( size(img) ) );
    end

%
function dst_img = render_texrect( ...
		plane_pose, plane_width, plane_height, tex, cmod_pose, cmod, dst_img )

	% looking at the plane with surface normal [1;0;0]
	tl = [0;plane_width/2;-plane_height/2]; % top left
	bl = [0;plane_width/2;plane_height/2]; % bottom left
	tr = [0;-plane_width/2;-plane_height/2]; % top right

	% transform to world positions
	tl = hpose_compound_point_op( plane_pose, tl );
	bl = hpose_compound_point_op( plane_pose, bl );
	tr = hpose_compound_point_op( plane_pose, tr );

	P = tl(1:3); 
	N = tr(1:3) - tl(1:3);
	M = bl(1:3) - tl(1:3);

    zbuf = inf( size( dst_img ));
    % do texture mapping
	texmaprect( P, N, M, tex, dst_img, zbuf, cmod_pose, cmod );

%	texmaprect( P, N, M, tex, size(tex,2), size(tex,1), dst_img, ...
%			size(dst_img,2), size(dst_img,1), cmod_pose,...
%			cmod.fx, cmod.fy, cmod.cx, cmod.cy, cmod.sx );

