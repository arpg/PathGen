
function [dRdq0,dRdq1,dRdq2,dRdq3] = quat_jacR( R, quat )
    
    dRdq0 = 2*[  quat(1), -quat(4),  quat(3) ; ...
                quat(4),  quat(1), -quat(2) ; ...
               -quat(3),  quat(2),  quat(1) ];
    dRdq1 = 2*[  quat(2),  quat(3),  quat(4) ; ...
                quat(3), -quat(2), -quat(1) ; ...
                quat(4),  quat(1), -quat(2) ];
    dRdq2 = 2*[ -quat(3),  quat(2),  quat(1) ; ...
                quat(2),  quat(3),  quat(4) ; ...
               -quat(1),  quat(4), -quat(3) ];
    dRdq3 = 2*[ -quat(4), -quat(1),  quat(2) ; ...
                      quat(1), -quat(4),  quat(3) ; ...
                      quat(2),  quat(3),  quat(4) ];

    % this is the normalized derivative of R - e.g. R/(dot(q,q)), since 
    % dot(q,q)=1. dividing by dot(q,q) incorporates the unit constraint on q.
    % See "Iterative Estimation of Rotation and Translation using the 
    % Quaternion", by Mark D. Wheeler Katsushi Ikeuchi for more notes on 
    % Jacobians of rotation matrices wrt quaternions.

    dRdq0 = (dRdq0 - 2*R*quat(1));
    dRdq1 = (dRdq1 - 2*R*quat(2));
    dRdq2 = (dRdq2 - 2*R*quat(3));
    dRdq3 = (dRdq3 - 2*R*quat(4));


