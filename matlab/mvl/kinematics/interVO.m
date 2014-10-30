
    grid on;
    set( gca, 'ZDir', 'reverse' );
    set( gca, 'YDir', 'reverse' );
    axis equal;
    set(gcf, 'Color', [0.2 0.2 0.2]); 
    set(gca, 'Color', [0.2 0.2 0.2]);
%    view( -40, 40 );
    camlight;
    xlabel( 'x' );
    ylabel( 'y' );
    zlabel( 'z' );


    dpose = [0.1; 0.0; -0.005; 0; 0; 0.1 ];

    poses = zeros(6,1);
    nposes = 100;
    for ii = 2:nposes
        dpose(6) = 0.1*sin( 0.1*ii );
        poses = [ poses compound_op( poses(:,ii-1), dpose ) ];
    end

    plot_simple_path( poses, 0.2 );


    return;
    n = 10;
    interp_dpose = dpose/n;

    interp_poses = poses(:,1);
    for ii = 2:nposes*n
        interp_poses = [ interp_poses compound_op( interp_poses(:,ii-1), interp_dpose ) ];
    end

    plot_simple_path( interp_poses, 0.1 );

