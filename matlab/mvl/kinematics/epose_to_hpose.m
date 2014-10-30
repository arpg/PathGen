% hpose = epose_to_hpose( epose )  Convert 6x1 Euler PQR pose vector to 3x4
%   homogeneous transform matrix.

function hpose = epose_to_hpose( epose )

	hpose(1:3,4) = epose( 1:3 );
	hpose(1:3,1:3) = eulerPQR_to_rotmat( epose(4:6) );
	hpose( 4,: ) = [ 0 0 0 1];
