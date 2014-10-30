% Hik = homo_compound_op( Hij, Hjk ) Given the pose of coordinate frame (CF) j
%	in CF i, and the pose of CF k in CF j, compute the pose of CF k in CF i. 

function Hik = homogenous_compound_op( Hij, Hjk )
	Hik = Hij*Hjk;
