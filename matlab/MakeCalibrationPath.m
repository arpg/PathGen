function Trajectory = MakeCalibrationPath

    SampleFreq = 20;
    t = [0:1/SampleFreq:2*pi];
    n = numel(t);

    WayPoints = [0.5*sin(4*t); 2*sin(t); sin(2*t); 0.5*sin(2*t); zeros(2,n)];
    
    WayPoints = LookAt( WayPoints, [3;0;0] );

    plot_simple_path( WayPoints, 0.5 ); light;

    Trajectory = [ t; WayPoints ];
    
end

function newposes = LookAt( poses, target )
    newposes = poses;
    for ii = 1:size(poses,2)
        R = eulerPQR_to_rotmat( poses(4:6,ii));
        f = (target-poses(1:3,ii)) / norm(target-poses(1:3,ii));
        d = R(:,3);
        r = cross(d,f);
        r = r / norm(r);
        d = cross(f,r);
        d = d / norm(d);
        R = [f r d];
        newposes(4:6,ii) = rotmat_to_eulerPQR(R);
    end
end
