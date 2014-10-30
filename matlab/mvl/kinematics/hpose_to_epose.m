% epose = hpose_to_epose( hpose ) Convert from homogeneous matrix to EulerPQR
% pose.

function epose = hpose_to_epose( hpose )

%	hpose = hpose/hpose(4,4); hmmm

	epose(1:3,1) = hpose(1:3,4);
	epose(4:6,1) = rotmat_to_eulerPQR( hpose(1:3,1:3) );
