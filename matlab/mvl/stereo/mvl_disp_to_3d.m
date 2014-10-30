% fx = mvl_disp_to_3d( lpx, rpx, lcmod, rcmod, lhpose, rhpose ) Given left,
% 	px, and right, rpx, pixel measurements tringulate into fx the 3D
% 	osition of the measured point.  lhpose and rhpose are the left and right
% 	4x4 homogeneous pose matrices.
%
% [fx,Fx] = mvl_disp_to_3d( lpx, rpx, lcmod, rcmod, lhpose, rhpose ) also
%	computes the 3x4 Jacobian of the triangulation function with respect to the
%	pixel locations, which can be used to compute the 3D covariance of fx - e.g.
%	Cov3d = Fx*Cov4d*Fx', where Cov4d is the block diagonal matrix with the left
%   and right 2x2 image covariances.
%

function [x,F] = mvl_disp_to_3d( lpx, rpx, lcmod, rcmod, lpose, rpose )

	R = (lpose(1:3,1:3) + rpose(1:3,1:3) )/2; 
	baseline = norm(rpose(1:3,4) - lpose(1:3,4) );
	if( baseline < eps )
		error('Baseline is too small, sure you passed the right camera models in?\n');
	end

	fxavg = (lcmod.fx + rcmod.fx)/2;
    fyavg = (lcmod.fy + rcmod.fy)/2;
    center = (rcmod.cx / rcmod.fx) - (lcmod.cx / lcmod.fx);  % should be near 0
    fx = baseline*fxavg;
    disp = (lpx(1) - rpx(1)) - center;

	if( disp < eps )
		fprintf('Warning: disp small: [%f, %f, %f, %f] ==> disp = %f\n',...
				lpx, rpx, disp );
		x = [inf;inf;inf];
		F = eye(3,4);
		return;
	end		

    if( nargout == 2 )
        % compute jacobian of stereo equation
        J(1,1) = -fx*(disp^-2);
        J(1,2) =  0;
        J(1,3) =  -J(1,1);
        J(1,4) =  0;

		J(2,1) = -1/2*baseline*(2*rpx(1)-lcmod.cx-rcmod.cx)/(disp)^2;
        J(2,2) =  0;
		J(2,3) = -J(2,1);
        J(2,4) =  0;

		J(3,1) = (fx*(-lpx(2)+lcmod.cy-rpx(2)+rcmod.cy)/fyavg/disp^2)/2;
        J(3,2) = ((fx/fyavg)/disp)/2;
		J(3,3) = -J(3,1);
        J(3,4) = J(3,2);

		% Use the following to double check the Jacobian.  Note that the horizontal and
		% vertical estimates are computed from an average of the left value and right
		% value - this is important for getting the right Jacobian.
		%   syms fx ul ur vl vr fy fyavg b lcx lcy rcx rcy;
		%	disp = (ul-ur);
		%	p(1,1) = fx/disp;
		%	p(2,1) = ( (ul-lcx)*(b/disp ) + b + (ur-rcx)*(b/disp ))/2;
		%	p(3,1) = ((vl-lcy)*( (fx/fyavg)/disp ) + (vr-rcy)*( (fx/fyavg)/disp ))/2;
		%	simplify( jacobian( p, [ul,vl,ur,vr] ) )

		J(1,1:4) = [ -fx/(disp)^2, 0, fx/disp^2, 0];
		J(2,1:4) = [ -1/2*baseline*(2*rpx(1)-lcmod.cx-rcmod.cx)/disp^2,...
	                  0,...
					  1/2*baseline*(2*lpx(1)-lcmod.cx-rcmod.cx)/disp^2,...
					  0 ];
		J(3,1:4) = [ 1/2*fx*(-lpx(2)+lcmod.cy-rpx(2)+rcmod.cy)/fyavg/disp^2,...
		             1/2*fx/fyavg/disp,...
					-1/2*fx*(-lpx(2)+lcmod.cy-rpx(2)+rcmod.cy)/fyavg/disp^2,...
 					 1/2*fx/fyavg/disp ];

		F = R*J; % transform into camera's cf
	end

    p(1,1) = fx/disp;
	y1 = (lpx(1)-lcmod.cx)*(baseline/disp );
    y2 = baseline + (rpx(1)-rcmod.cx)*(baseline/disp );
    p(2,1) = (y1+y2)/2;
	p(3,1) = ( ((rpx(2)+lpx(2))/2)-lcmod.cy)*( (fx/fyavg)/disp ); % note the avg
	p(3,1) = ((lpx(2)-lcmod.cy)*( (fx/fyavg)/disp ) + (rpx(2)-rcmod.cy)*( (fx/fyavg)/disp ))/2;

    % wf = ws(+)sf
    x =  R*p + lpose(1:3,4);

