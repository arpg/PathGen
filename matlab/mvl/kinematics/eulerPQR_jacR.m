% [dRdp,dRdq,dRdr] = eulerPQR_jacR( R, pqr ) compute the Jacobian of rotation
%	matirx R, wrt to euler angles p,q,r.
%
% [dRdp,dRdq,dRdr] = eulerPQR_jacR( R ) will compute the same result, without
%	reference to the roll-pitch-yaw angles.
%
%	This is only well defined for small angle rotation matrices, since the
%	range of atan and asin are both restricted to -pi/2 to pi/2.

function [dRdp,dRdq,dRdr] = eulerPQR_jacR( R, pqr )	

	if( nargin == 2 )
		cr = cos(pqr(3));
	    sr = sin(pqr(3));
	else
		% compute cos(pqr(2)) directly from the rotation matrix, avoids trig,
		% uses a sqrt instead.
		cq = sqrt( 1 - R(3,1)^2 );
		cr = R(1,1)/cq;
		sr = R(2,1)/cq;
	end

    dRdp = R*[ 0   0   0 ; ...
               0   0  -1 ; ...
               0   1   0];

    dRdq =   [ 0   0  cr ; ...
               0   0  sr ; ...
             -cr -sr   0 ]*R;

    dRdr =   [ 0  -1   0; ...
               1   0   0; ...
               0   0   0]*R;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0

% WARNING this derviation uses "rpq" instead of the more standard "pqr" to
% represent roll,pitch,yaw.  The above has been fixed.
    
% compute what derivitaves faster:
% Usually we have the three derivative matrices above being multip[lied by a
% 3x1 vector to produce a new 3x3 matrix. We can simplify the entire process as
% follows

%    dRdr     dRdp     dRdq 
    % compute derivitave of R wrt to dr times t
%    dRdr = R*[ 0   0   0 ; ...
%               0   0  -1 ; ...
%               0   1   0] * t;
%    dRdr = [ 0   R(1,3)  -R(1,2) ; ...
%             0   R(2,3)  -R(2,2) ; ...
%             0   R(3,3)  -R(3,2) ] * t;
%    dRdrt = R(1:3,2)*t(2) - R(1:3,2)*t(3);
    dRdrt = R(1:3,2)*t(2) - R(1:3,2)*t(3);

    %%%%%
%    dRdpt =   [ 0   0  cq ; ...
%               0   0  sq ; ...
%             -cq -sq   0 ]*R;
%    dRdpt = [ cq*R(3,1)                         cq*R(3,2)              cq*R(3,3)  ;
%              sq*R(3,1)                         sq*R(3,2)              sq*R(3,3)  ;
%             -cq*R(1,1)-sq*R(2,1)    -cq*R(1,2)-sq*R(2,2)   -cq*R(1,3)-sq*R(2,3) ] * t;
%    dRdpt = [           cq*R(3,1)*t1  +             cq*R(3,2)*t2      +       cq*R(3,3)*t3 ;
%                        sq*R(3,1)*t1  +             sq*R(3,2)*t2      +       sq*R(3,3)*t3 ;
%             -cq*R(1,1)-sq*R(2,1)*t1  +  -cq*R(1,2)-sq*R(2,2)*t2   -cq*R(1,3)-sq*R(2,3)*t3 ];
    dRdpt = [           cq*R(3,1)*t1  +             cq*R(3,2)*t2  +              cq*R(3,3)*t3 ;
                        sq*R(3,1)*t1  +             sq*R(3,2)*t2  +              sq*R(3,3)*t3 ;
             -cq*R(1,1)-sq*R(2,1)*t1  +  -cq*R(1,2)-sq*R(2,2)*t2  +   -cq*R(1,3)-sq*R(2,3)*t3 ];

    %%%%%
%    dRdqt =   [ 0  -1   0; ...
%               1   0   0; ...
%               0   0   0]*R;
%    dRdqdt = [ R(2,1) R(2,2) R(2,3);
%               R(1,1) R(1,2) R(1,3);
%                 0   0   0] * t;
    dRdqdt = [ -R(2,:)*t;
                R(1,:)*t;
                   0     ];

end
