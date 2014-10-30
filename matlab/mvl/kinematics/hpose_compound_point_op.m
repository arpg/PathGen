% Hik = hpose_compound_point_op( Hij, Tjk ) Given the pose of coordinate frame (CF) j
%	in CF i, and the pose of CF k in CF j, compute the pose of CF k in CF i.
function Tik = hpose_compound_point_op( Hij, Tjk )

	if( length(Tjk) == 3 )
		Tik = Hij*[Tjk;1];
	elseif( length(Tjk) == 4 )
		Tik = Hij*Tjk
	else
		error('hpose_compound_point_op() -- Tjk needs to be a 4x1 or 3x1 vector');
	end

