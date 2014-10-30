%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% dEdt = BodyRates2EulerRates( Rbn, pqr_bn, omega )
%
% Convert Body-Rate angular velocity, omega, into Euler-rates, dEdt, (time
% derivative of roll, pitch, yaw). 
%
% pqr     is the roll-pitch-yaw zyx-Euler angle defining Rbn, the rotation
%         from body frame to navigation frame.
% omega   is the body-rate angular velocity.
%
% dEdt    is the time derivative of the zyx-Euler angles.
%
% The best derivation I've found for this transform is the short MS thesis
% "Gyroscope Calibration and Dead Reconing for an Autonomous Underwater
% Vehicle" by Aaron J Kapaldo.  I'm still looking for a good textbook
% reference.
%
function dEdt = BodyRates2EulerRates( pqr, omega )

%    phi   = roll  = "p"
%    theta = pitch = "q" 
%    psi   = yaw   = "r"

    % 
    sp = sin(pqr(1)); % roll phi
    cp = cos(pqr(1)); % roll
    cq = cos(pqr(2)); % pitch
    tq = tan(pqr(2)); % pitch
    cr = cos(pqr(3)); % yaw
    tr = tan(pqr(3)); % yaw

    T = [ 1,   sp*tq,   cp*tq;...
          0,      cp,     -sp;...
          0,   sp/cq,   cp/cq];

    dEdt = T*omega;

% Checking:
if 0
    syms p q r dp dq dr;

    pqr = [p;q;r];
    dEdT = [dp; dq; dr];

    sp = sin(pqr(1)); % roll phi
    cp = cos(pqr(1)); % roll
    sq = sin(pqr(2)); % pitch
    cq = cos(pqr(2)); % pitch
    sr = sin(pqr(3)); % pitch
    cr = cos(pqr(3)); % pitch

    Rxt = [  1     0    0 ;...
            0    cp   sp ; ...
            0   -sp   cp];

    Ryt = [  cq   0  -sq  ; ...
             0   1    0  ; ...
            sq   0   cq ];

    Rzt = [  cr    sr    0; ...
           -sr    cr    0; ...
             0     0    1];

% NB: The given orientation, Rnb = R(pqr), is "body-frame" in the
% "nav-frame".  To match A Kapaldo's derivation we will be using 
% Rbn = Rnb' = [RzRyRx]' = [Rx'Ry'Rz'] and hence the rotation matrices we
% compute here are Rx', Ry' and Rz' -- e.g. when compared to my Cart2R
% functions and standard zyx-Euler convetion. Basically, Kapaldo's "Rx" is
% really Rx'.

    omega =  [ dEdt(1);0;0] + Rxt*[ 0; dEdt(2); 0] + Rxt*Ryt*[ 0;0;dEdt(3) ];
    
    T = [ 1,   0,   -sq;...
          0,  cp, cq*sp;...
          0, -sp, cq*cp];

    simple( inv(T) ) % this is what we're after here:
      
end
    
end

