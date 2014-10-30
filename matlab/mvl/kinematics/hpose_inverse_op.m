% Hji = hpose_inverse_op( Hij ) Givnen the pose of coordinate frame i
%   in coordinate frame j, compute the pose coordinate frame j in coordinate
%   frame i - i.e. the inverse operation. Pose is represented by the 4x4
%   homogenous matrix, Hij = [ Rij, Tij; 0 0 0 1];, composed of an xyz 3
%   vector, Tij, and an orientation matrix Rij, where subscripts describe the frame
%   names - e.g. Tij and Rij are the xyz location and 3x3 orientation matrix of
%   frame j in frame i.

function Hji = hpose_inverse_op( Hij )

	Hji = [ Hij(1:3,1:3).' -Hij(1:3,1:3).'*Hij(1:3,4); 0 0 0 1 ];
