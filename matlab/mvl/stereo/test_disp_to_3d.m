
	[lcmod,Tl] = mvl_camera_read( '../camera/lcmod.xml' );
	[rcmod,Tr] = mvl_camera_read( '../camera/rcmod.xml' );


	pstd = 0.5; % just to make covariance ellipses big
	Sig = diag( repmat(pstd, 1,4) )

	hold on;
	axis equal;
	grid on;
	set( gca, 'ZDir', 'reverse');
	set( gca, 'YDir', 'reverse');

    tl = Tl(1:3,4);
    tr = Tr(1:3,4);
    
    lpose = T2Cart( Tl );
    rpose = T2Cart( Tr );

	center = (tl+tr) / 2;
	plot3(center(1),center(2),center(3),'ro');
	plot_camera( lpose, 0.05, 1, 1 );
	plot_camera( rpose, 0.05, 1, 1 );

    % generate 3d grid of points infront of the camera
	for( row = -0.2:0.1:0.2 )
		for( col = -0.2:0.1:0.2 )

			x = [ 1.4; col; row];
			lpx = mvl_camera_3d_to_2d( x, Tl, lcmod ); % + pstd*randn(2,1); 
			rpx = mvl_camera_3d_to_2d( x, Tr, rcmod ); % + pstd*randn(2,1);

			[fx,Fx] = mvl_disp_to_3d( lpx, rpx, lcmod, rcmod, Tl, Tr );
			Px = Fx*Sig*Fx.'; % projects image covarinace into 3D

			plot_3d_gaussian( fx, Px, 10 );

			plot3( [center(1); fx(1)], [center(2) fx(2)], [center(3); fx(3)], 'b-' );
		end
	end
	
	view( 30, 30 );
	camlight;
	camlight left;
	camlight right;

