%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sample between given way points
% This function takes a set of WayPoints, Velocities at each way point, and
% a desired sampling frequency, and produces a new set of waypoints and
% velocities sampled from the trajectory.
function [p,v] = SampleTrajectory( WayPoints, ForwardVelocityProfile, SampleFrequency )

    TimeDelta = 1.0/SampleFrequency;

    % needed to match integral of velocity:
    d =  path_integral( WayPoints );

    % velocity is actually 1-d.  It's just the forward speed at that
    % instance.  We assume we're always forward moving.  Will generalize
    % some other day.
    % Put a spline on velocity, then integrate that to get the
    % position sampling points.  However, we need to adjust the velocity 
    Vel = [ForwardVelocityProfile(1)];
	Times = 0;
    TotalTime = 0;
    for ii = 2:numel(ForwardVelocityProfile)
        % generate velocity segment:
        v0 = ForwardVelocityProfile(ii-1);
        v1 = ForwardVelocityProfile(ii);
        s0 = d(ii-1);
        s1 = d(ii);
        [vt,ts] = GenVelocitySegment( Times(end), s0, v0, s1, v1 );
        % we know that the integral of this velocity will give us the
        % correct distance traveled.
        Vel = [Vel vt(2:end)];
        Times = [Times ts(2:end) ];

        TotalTime = ts(end);
    end
    VelocitySpline = spline( Times, Vel );

    % get distance along velocity profile.
	SampleDistances = IntegrateVelocity( VelocitySpline, TimeDelta, TotalTime );

    %%%%
    % now get the path spline
    % make sure rotations go in the right dir so rotations look good
    for ii = 2:size(WayPoints,2)
        WayPoints(4:6,ii) = AngleFix( WayPoints(4:6,ii-1), WayPoints(4:6,ii) );
    end

    % sample along the path
    d =  path_integral( WayPoints );
    cs = pchip( d, WayPoints );
    xx = [d(1):0.1:d(end)];
    yy = ppval(cs,xx);

    % sample again to even out sampling rate along corners
    d = path_integral( yy );
    cs = pchip( d, yy );

    % now, sample the path according to the velocity integral:
    p = ppval(cs,SampleDistances);

    v = ppval( VelocitySpline, 0:TimeDelta:TotalTime );
    
    
    
    % ok, now re-orient each pose to point along the trajectory, as a
    % car-like camera would do:
    pnew = [];
    for ii = 1:size(p,2)-1
        pw1 = p(:,ii);
        pw2 = p(:,ii+1);
        Tw1 = Cart2T( pw1 );
        Tw2 = Cart2T( pw2 );
        T12 = inv(Tw1)*Tw2;
        forward = pw2(1:3)-pw1(1:3);
        forward = forward/norm(forward);
        right = Tw1(1:3,2);
        down = cross(forward,right);
        R = [ forward right down ];
        Tnew = Tw1;
        Tnew(1:3,1:3) = R; % change orientation
        pnew = [ pnew T2Cart(Tnew) ];
    end
    Tnew = Cart2T( p(:,end) );
    Tnew(1:3,1:3) = R;
    pnew = [ pnew T2Cart(Tnew) ];

    p = pnew;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% hack so interpolation is smooth
function b = AngleFix1( a, b )
    while( a > b && a - b > pi )
        b = b + 2*pi;
    end
    while( b > a && b - a > pi )
        b = b - 2*pi;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hack so interpolation is smooth
function b = AngleFix( a, b )
   b(1) = AngleFix1( a(1),b(1) );
   b(2) = AngleFix1( a(2),b(2) );
   b(3) = AngleFix1( a(3),b(3) );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Idea here is to go from a linear-interpolated velocity from a to b --
%  i.e., a line -- to one that has curve.  This is so that the integral of
%  the velocity profile gives the correct distance at the end of the day,
%  while preserving the velocity end constraints.
%
%  Think of a velocity-vs-position line from [s0,v0] to [s1,v1].  If the
%  integral under that velocity popfile is too big, it means a vehicle
%  moving along that profile will go too far.  We fix this by reducing the
%  velocity via a spline, yet we arive at the correct end velocity, and the
%  integral under the new velocity curve gives the correct distance.
%
%  This means the time the curve takes is a free parameter, which we will
%  recompute at each loop (so we can converte from velocity-vs-position to
%  velocity-vs-time).
%
%  Ok, moving at v over d means we travel for t d/t = v
%  So, t = d/v  OR t = integral d(s)/v(s) ds where is arc length, or
%  distance in our case, so we're solving integral s/v(s)ds 
%
%  Each loop we will 
%  1) V-vs-s spline
%  2) Compute end time, t by integrating V-vs-s from s0 to s1
%  3) V-vs-t spline (make spline from 0-t1 based on V)
%  4) Check velocity integral, adjust midpoint between V0 and V1
%
function [v,t] = GenVelocitySegment( t0, s0, v0, s1, v1 )
    % ok, lets see how changing the spline changes the integral
    % really, we need to walk to the bottom right corner of the velocity
    % profile.
    dx = (s1-s0);
    dy = (v1-v0);
    mid = [s0;v0]+[dx; dy]/2;
    if( v0 < v1 )
        corner = [s1;v0];
    else
        corner = [s0;v1];
    end

    % dx, dy:
    m = [ (corner(1)-mid(1));  (corner(2)-mid(2)) ];
    m = m/norm(m);

    nsegs = 1000;
    
    % Actual required travel distance:
    required_dist = s1 - s0;

%        subplot( 1, 2, 1 ); hold; grid on; axis equal;
%    figure; hold on; grid on; axis equal;
%    plot( s0, v0, 'rx' );
%    plot( s1, v1, 'gx' );
%    plot( [s0, s1]', [v0, v1]' );
    
    % little minimax on search parameter th to find velocity profile:
    update = norm( corner - mid )/2; % can be negative...
    th = 0;
    integrated_dist = 0;
 
    % move mid point moves perpendicular to the slope
    c = mid + m*th;
    plot( c(1), c(2), 'bo');
    VelocityVsPositionSpline = pchip( [s0,c(1),s1], [c(2),c(2),c(2)] );

    % this is tricky -- what should I choose for the oiverall time?  If I
    % recalc this at each iteration, the alg below does not converge.  so
    % for now I just fix this to some "average" time based on the average
    % velocity.  This obviously might cause problems -- esp as I don't tell
    % teh user when he's given us crap input.
    t = CalcTime( VelocityVsPositionSpline, s0, s1 );

    while( abs(required_dist-integrated_dist) > 1e-6 )
%        subplot( 1, 2, 1 ); hold; grid on; axis equal;

        
        % move mid point moves perpendicular to the slope
        c = mid + m*th;
%        plot( c(1), c(2), 'bo');
        VelocityVsPositionSpline = pchip( [s0,c(1),s1], [v0,c(2),v1] );

        % now interplolate retult:
        delta = (s1-s0)/nsegs;
        vsx = s0:delta:s1;
        vsy = ppval( VelocityVsPositionSpline, vsx );

        % plot it
  %      plot( vsx, vsy, 'r-');
        
        % now put a spline on velocity vs time
        VelocityVsTimeSpline = pchip( [0,t/2,t], [v0,c(2),v1] );
        vtx = 0:t/10:t;
        vty = ppval( VelocityVsTimeSpline, vtx );

        % check the integral
        integrated_dist = quad( @(vtx)ppval( VelocityVsTimeSpline,vtx), 0, t );
    %    required_dist
        
     %   subplot( 1, 2, 2 );
      %  plot( vtx, vty );

%        waitforbuttonpress;
        


        % 
        if( required_dist > integrated_dist )
            th = th - update;
        else
            th = th + update;
        end
        update = update/2;
    end
    v = vty;
    t = vtx + t0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: vs -- a velocity vs distance spline.
% Input: s0 -- start distance
% Input: s1 -- end distance
% Compute how long it would take to travel the velocity profile:
%   t = Integral s/v(s) ds
% that integral is wrong.  what I need is, for each little segment,
% ds/v(s)  so, I need to interate 1/v(s) ( i think ).
function t = CalcTime( vs, s0, s1 )
    t = quad( @(s)func(s,vs), s0, s1 );
end
function ts = func( s, vs )
        ts = 1./ppval( vs, s );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% move along the velocity profile computing how far we've moved every
% TimeDelta seconds.
function s = IntegrateVelocity( VelocitySpline, TimeDelta, TotalTime )
    s = [];
    for dt = 0:TimeDelta:TotalTime
        s = [ s quad( @(dt)ppval(VelocitySpline,dt), 0, dt ) ];
    end
end

