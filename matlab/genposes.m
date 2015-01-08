function [ pc, pi ] = genposes(P, V, Tci, fc, fi, arcs)

    % combine poses & velocites
    waypoints = [ P ; V ];

    % check if arcs should be added
    if nargin >= 6 && arcs == true
        config = 'config/arc_path_builders/open.mat';
        pathBuilderFactory = ArcPathBuilderFactory();
        pathBuilder = pathBuilderFactory.create(config);
        pathBuilder.setPoses(waypoints);
        path = pathBuilder.build();
        waypoints = path.getPoses(100);
    end
    
    % create spline curve builder
    curveBuilder = SplineCurveBuilder();
    curveBuilder.setPath(waypoints);
    curve = curveBuilder.build();
    
    % create imu data
    imu = Imu();
    imu.setDataRate(fi);
    pi = imu.getData(curve);
    
    % create camera poses
    camera = Camera();
    camera.setPose(Tci);
    camera.setFrameRate(fc);
    pc = camera.getPoses(curve);

end