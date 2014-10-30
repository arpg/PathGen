% quat = axis_angle_to_quat( axis, angle )
%
% NOTE: There are three sources of redundancy with the axis-angle rotation
% specification. 1). if angle is 0, axis is undefined 2) using 4 parameters to
% define 3 degrees of freedom, and 3) [-axis,-angle] = [axis,angle] =
% [axis,2pi*angle]
%
% So, if angle is zero, then sin(angle) below will be zero, and the quaternion
% will be undefined.
%
% Generally, this tells me that using axis-angle or rodrigues parameters is
% problematic, at least if one is converting from axis

function quat = axis_angle_to_quat( axis, angle )

   quat(2:4) = axis / norm(axis);
   quat(2:4) = sin( angle/2 ) * quat(2:4);
   quat(1) = cos( angle/2 );

