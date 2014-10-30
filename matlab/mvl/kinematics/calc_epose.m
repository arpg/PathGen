%  EPOSE = CALC_EPOSE( POS, TARGET, UP )
%    Given a 3D position, POS, a 3D TARGET point to point at, and an UP
%    direction, compute the associated 6D Euler pose.
%

function epose = calc_epose( pos, target, up )

    % line between points will be the plane normal
	normal = (target - pos)/norm( target-pos);

    % line from "up" to "target" will intersect plane defined by 
    % axis and pos.  That point will define our new up
	p1 = up + pos; % point above us
	p2 = normal + target; % point along normal from target

	% p3 will be on the plane, line from target (whcih is on the plane) to p3
	% will define newup.
    p3 = line_plane_intersect( p1, p2, target, normal );

	% normalized newup
	newup = (p3-target)/norm(p3-target);

    % dot of new up with "old" up gives new angle 
    % angle = acos( dot( newup, up ) )

    % cross between up and normal will be what we rotate about 
    axis = cross( newup, normal );

    forward = normal;
    right = axis/norm(axis);
    up = newup;
    R = [ forward right -up ];
    
    %  get Euler pose 
	epose = [pos; rotmat_to_eulerPQR( R ) ];

