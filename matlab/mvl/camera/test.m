% test
    [cmod,startpose] = mvl_camera_read( 'lcmod.xml' );

    pt2 = [ cmod.width/2*randn(1); cmod.height/2*randn(1) ];
    pt3 = randn(3,1);
    pose = [ 100*randn(3,1); randn(3,1) ];

    Hpose = epose_to_hpose( pose );

    [ h, H ] = mvl_camera_3d_to_2d( pt3, Hpose, cmod );
    [ r,dr ] = mvl_camera_2d_to_3d( pt2, Hpose, cmod );

    mvl_camera_write( 'test.xml', Hpose, cmod );
