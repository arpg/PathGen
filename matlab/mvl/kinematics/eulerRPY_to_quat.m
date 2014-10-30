
% euler  = [roll, pitch, yaw]
% where phi is yaw, theta is pitch and psi is roll
% order matters here -- these are PQR quaternions
% q = [ w i j k]

function quat = euler_to_quat(euler)

   % first, make sure our angles are in the desired range
   euler = angle_wrap_eulerPQR(euler);

   cosX = cos(euler(1)/2.0);
   cosY = cos(euler(2)/2.0);
   cosZ = cos(euler(3)/2.0);

   sinX = sin(euler(1)/2.0);
   sinY = sin(euler(2)/2.0);
   sinZ = sin(euler(3)/2.0);

   quat = [ cosX*cosY*cosZ + sinX*sinY*sinZ; ...
            sinX*cosY*cosZ - cosX*sinY*sinZ; ...
            cosX*sinY*cosZ + sinX*cosY*sinZ; ...
            cosX*cosY*sinZ - sinX*sinY*cosZ];


