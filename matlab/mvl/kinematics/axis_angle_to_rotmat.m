% rot = axis_angle_to_rotmat( axis, angle )
%
% NOTE: There are three sources of redundancy with the axis-angle rotation
% specification. 1). if angle is 0, axis is undefined 2) using 4 parameters to
% define 3 degrees of freedom, and 3) [-axis,-angle] = [axis,angle] =
% [axis,2pi*angle]
% 
% NOTE: These issues will also effect quaternions.  Converting from an axis
% angle to a quaternion will be undefined for angle=0
function rot = axis_angle_to_rotmat( axis, angle )

   quat(2:4) = axis / norm(axis);
   quat(2:4) = sin( angle / 2) * quat(2:4);
   quat(1) = cos( angle / 2);

   rot = quat_to_rotmat(quat);

