%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  J = JacCart2T( x )
%  Compute the 16x6 Jacobian, dvect(T)/dx, wrt to xyz-Euler pose x
function J = JacCart2T( x )

    % Recall
    % T = [      cp*cq, -cr*sq+sr*sp*cq,  sr*sq+cr*sp*cq,  x; ...
    %            cp*sq,  cr*cq+sr*sp*sq, -sr*cq+cr*sp*sq,  y; ...
    %              -sp,           sr*cp,           cr*cp,  z; ...
    %                0,               0,               0,  1];
    % This is rotation about the fixed frame.
    % see eqn 2.20 of Modelling and Control of Robot Manip.

    J = zeros(16,6);

    cr = cos(x(4));
    sr = sin(x(4));
    cp = cos(x(5));
    sp = sin(x(5));
    cq = cos(x(6));
    sq = sin(x(6));

    % Col 1 of T:
    J(1,4:6) = [0, -sp*cq, -cp*sq]; % Row 1: dT11/drpq
    J(2,4:6) = [0, -sp*sq,  cp*cq]; % Row 2: dT21/drpq
    J(3,4:6) = [0,    -cp,      0]; % Row 3: dT31/drpq
    % Row 4: T41

    % Col 2 of T:
    J(5,4:6) = [ sr*sq+cr*sp*cq,  sr*cp*cq, -cr*cq-sr*sp*sq]; % Row 5: dT12/drpq
    J(6,4:6) = [-sr*cq+cr*sp*sq,  sr*cp*sq, -cr*sq+sr*sp*cq]; % Row 6: dT22/drpq
    J(7,4:6) = [          cr*cp,    -sr*sp,              0 ]; % Row 7: dT32/drpq
    % Row 8: T42

    % Recall:
    % T = [      cp*cq, -cr*sq+sr*sp*cq,  sr*sq+cr*sp*cq,  x; ...
    %            cp*sq,  cr*cq+sr*sp*sq, -sr*cq+cr*sp*sq,  y; ...
    %              -sp,           sr*cp,           cr*cp,  z; ...
    %                0,               0,               0,  1];

    % Col 3 of T:
    J(9,4:6)  = [ cr*sq-sr*sp*cq,  cr*cp*cq,  sr*cq-cr*sp*sq]; % Row 9:  dT13/drpq
    J(10,4:6) = [-cr*cq-sr*sp*sq,  cr*cp*sq,  sr*sq+cr*sp*cq]; % Row 10: dT23/drpq
    J(11,4:6) = [         -sr*cp,    -cr*sp,              0 ]; % Row 11: dT33/drpq
    % Row 12: T43

    % Col 4 of T:
    J(13:15,1:3) = eye(3); % dT1:3,4/dxyz
    % Row 16: T44

