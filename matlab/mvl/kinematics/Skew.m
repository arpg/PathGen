%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S = Skew( w )
%
% Create the skew symmetric matrix S from the 3 vector w.
%
% Used in derivatives of rotation matrices, angular velocites, etc. See
% Modeling and Control of Robot Manipulators. Sec. 3.1.1.
%
function S = Skew( w )
    % wz = w(3);
    % wy = w(2);
    % wx = w(1);

    S = [ 0    -w(3)  w(2) ;...
          w(3)     0 -w(1) ;...
         -w(2)  w(1)    0 ];

