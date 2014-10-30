% function [Jx1,Jx2] = jac_compound_op( x1, x2 )
% Compute the Jacobian of the compound operation wrt to x1 and x2.  One
% assumption here is that the euler orientations in x1 and x2 are between -pi
% and pi.

function [Jx1,Jx2] = jac_compound_op( x1, x2 )
%  compound op is:  x12 = [ R1*x2(1:3) + x1(1:3); rotmat_to_eulerRPY(R1*R2)];
%
%  assuming the rotations in R1 and R2 are small, rotmat_to_eulerRPY(R1*R2)
%  reduces to:
%
%  mat = R1*R2
%
%  below we will need these parts of mat:
%  mat(1,1) = R1(1,1)*R2(1,1) + R1(1,2)*R2(2,1) + R1(1,3)*R2(3,1)
%  mat(2,1) = R1(2,1)*R2(1,1) + R1(2,2)*R2(2,1) + R1(2,3)*R2(3,1)
%
%  and the bottom row:
%  mat(3,1) = R1(3,1)*R2(1,1) + R1(3,2)*R2(2,1) + R1(3,3)*R2(3,1) 
%  mat(3,2) = R1(3,1)*R2(1,2) + R1(3,2)*R2(2,2) + R1(3,3)*R2(3,2)
%  mat(3,3) = R1(3,1)*R2(1,3) + R1(3,2)*R2(2,3) + R1(3,3)*R2(3,3)
%
%  r = atan2( mat(3,2), mat(3,3) );
%  p = -asin( mat(3,1) );
%  q = atan2( mat(2,1), mat(1,1) );
%

% WARNING: the notation here is "rpq" not "pqr"

    R1 = eulerPQR_to_rotmat(x1(4:6));
    R2 = eulerPQR_to_rotmat(x2(4:6));
    [dR1dr,dR1dp,dR1dq] = eulerPQR_jacR( R1, x1(4:6) );
    [dR2dr,dR2dp,dR2dq] = eulerPQR_jacR( R2, x2(4:6) );

    % f = mat(3,2)
    % g = mat(3,3)
    % D( atan(f/g) ) = (1/(1+(f/g)^2)) * ( g*df - f*dg)/g^2
    f = R1(3,:)*R2(:,2);
    g = R1(3,:)*R2(:,3);

    df = dR1dr(3,:)*R2(:,2);
    dg = dR1dr(3,:)*R2(:,3);
    drdr = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
    df = dR1dp(3,:)*R2(:,2);
    dg = dR1dp(3,:)*R2(:,3);
    drdp = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
    df = dR1dq(3,:)*R2(:,2);
    dg = dR1dq(3,:)*R2(:,3);
    drdq = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );

    % f = mat(3,1) = R1(3,1)*R2(1,2) + R1(3,2)*R2(2,2) + R1(3,3)*R2(3,2)
    % D( -asin( f ) ) = (1/sqrt(1-f^2)) * df
    dasin = -(1/sqrt(1-(R1(3,:)*R2(:,1))^2));
    dpdr =  dasin * dR1dr(3,:)*R2(:,1);
    dpdp = dasin * dR1dp(3,:)*R2(:,1);
    dpdq = dasin * dR1dq(3,:)*R2(:,1);

    % f = mat(2,1)
    % g = mat(1,1)
    % D( atan(f/g) ) = (1/(1+(f/g)^2)) * ( g*df - f*dg)/g^2
    f = R1(2,:)*R2(:,1);
    g = R1(1,:)*R2(:,1);
    df = dR1dr(2,:)*R2(:,1);
    dg = dR1dr(1,:)*R2(:,1);
    dqdr = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
    df = dR1dp(2,:)*R2(:,1);
    dg = dR1dp(1,:)*R2(:,1);
    dqdp = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
    df = dR1dq(2,:)*R2(:,1);
    dg = dR1dq(1,:)*R2(:,1);
    dqdq = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );

    Jx1 = [ eye(3),   dR1dr*x2(1:3),   dR1dp*x2(1:3),   dR1dq*x2(1:3) ; ...
            zeros(3),   [ drdr drdp drdq ; dpdr dpdp dpdq; dqdr dqdp dqdq ] ];

    % also compute Jacobian wrt x2 ?
    if( nargout == 2 )

        % f = mat(3,2)
        % g = mat(3,3)
        % D( atan(f/g) ) = (1/(1+(f/g)^2)) * ( g*df - f*dg)/g^2
        f = R1(3,:)*R2(:,2);
        g = R1(3,:)*R2(:,3);

        df = R1(3,:)*dR2dr(:,2);
        dg = R1(3,:)*dR2dr(:,3);
        drdr = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
        df = R1(3,:)*dR2dp(:,2);
        dg = R1(3,:)*dR2dp(:,3);
        drdp = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
        df = R1(3,:)*dR2dq(:,2);
        dg = R1(3,:)*dR2dq(:,3);
        drdq = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );

        % f = mat(3,1) = R1(3,1)*R2(1,2) + R1(3,2)*R2(2,2) + R1(3,3)*R2(3,2)
        % D( -asin( f ) ) = (1/sqrt(1-f^2)) * df
        dasin = -(1/sqrt(1-(R1(3,:)*R2(:,1))^2));
        dpdr = dasin * R1(3,:)*dR2dr(:,1);
        dpdp = dasin * R1(3,:)*dR2dp(:,1);
        dpdq = dasin * R1(3,:)*dR2dq(:,1);

        % f = mat(2,1)
        % g = mat(1,1)
        % D( atan(f/g) ) = (1/(1+(f/g)^2)) * ( g*df - f*dg)/g^2
        f = R1(2,:)*R2(:,1);
        g = R1(1,:)*R2(:,1);
        df = R1(2,:)*dR2dr(:,1);
        dg = R1(1,:)*dR2dr(:,1);
        dqdr = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
        df = R1(2,:)*dR2dp(:,1);
        dg = R1(1,:)*dR2dp(:,1);
        dqdp = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
        df = R1(2,:)*dR2dq(:,1);
        dg = R1(1,:)*dR2dq(:,1);
        dqdq = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );

        %  compound op is:  x12 = [ R1*x2(1:3) + x1(1:3); rotmat_to_eulerRPY(R1*R2)];
        Jx2 = [ R1 zeros(3) ; zeros(3) ...
                [ drdr drdp drdq; dpdr dpdp dpdq; dqdr dqdp dqdq ] ];
    end

% verification:

%    syms x1x x1y x1z x1r x1p x1q x2x x2y x2z x2r x2p x2q;
%    x1 = [ x1x x1y x1z x1r x1p x1q ].';
%    x2 = [ x2x x2y x2z x2r x2p x2q ].';

%    R1 = eulerRPY_to_rotmat(x1(4:6));
%    R2 = eulerRPY_to_rotmat(x2(4:6));
%    [dR1dr,dR1dp,dR1dq] = eulerRPY_jacR( R1, x1(4:6) );
%    [dR2dr,dR2dp,dR2dq] = eulerRPY_jacR( R2, x2(4:6) );

%    R12 = R1*R2;

%    r = atan( R12(3,2)/R12(3,3) );
%    p = -asin( R12(3,1) );
%    q = atan( R12(2,1)/R12(1,1) );

%    fcompound = [ R1*x2(1:3) + x1(1:3) ; r; p; q ];

    % f = mat(3,2)
    % g = mat(3,3)
    % D( atan(f/g) ) = (1/(1+(f/g)^2)) * ( g*df - f*dg)/g^2
%    f = R1(3,:)*R2(:,2);
%    g = R1(3,:)*R2(:,3);

%    df = dR1dr(3,:)*R2(:,2);
%    dg = dR1dr(3,:)*R2(:,3);    
%    drdr = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
%    df = dR1dp(3,:)*R2(:,2);
%    dg = dR1dp(3,:)*R2(:,3);
%    drdp = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
%    df = dR1dq(3,:)*R2(:,2);
%    dg = dR1dq(3,:)*R2(:,3);
%    drdq = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );

    % f = mat(3,1) = R1(3,1)*R2(1,2) + R1(3,2)*R2(2,2) + R1(3,3)*R2(3,2)
    % D( -asin( f ) ) = (1/sqrt(1-f^2)) * df
%    dasin = -(1/sqrt(1-(R1(3,:)*R2(:,1))^2));
%    dpdr =  dasin * dR1dr(3,:)*R2(:,1);
%    dpdp = dasin * dR1dp(3,:)*R2(:,1);
%    dpdq = dasin * dR1dq(3,:)*R2(:,1);

    % f = mat(2,1)
    % g = mat(1,1)
    % D( atan(f/g) ) = (1/(1+(f/g)^2)) * ( g*df - f*dg)/g^2
%    f = R1(2,:)*R2(:,1);
%    g = R1(1,:)*R2(:,1);
%    df = dR1dr(2,:)*R2(:,1);
%    dg = dR1dr(1,:)*R2(:,1);
%    dqdr = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
%    df = dR1dp(2,:)*R2(:,1);
%    dg = dR1dp(1,:)*R2(:,1);
%    dqdp = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
%    df = dR1dq(2,:)*R2(:,1);
%    dg = dR1dq(1,:)*R2(:,1);
%    dqdq = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );

%    Jx1 = [   eye(3),   dR1dr*x2(1:3),   dR1dp*x2(1:3),   dR1dq*x2(1:3) ; ...
%              zeros(3),   [ drdr drdp drdq ; dpdr dpdp dpdq; dqdr dqdp dqdq ] ];

   % see if matlab agrees
%    simplify( Jx1 - jacobian( fcompound, x1 ) ) 


    % now calc Jacobian wrt to x2    
%    f = R1(3,:)*R2(:,2);
%    g = R1(3,:)*R2(:,3);

%    df = R1(3,:)*dR2dr(:,2);
%    dg = R1(3,:)*dR2dr(:,3);
%    drdr = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
%    df = R1(3,:)*dR2dp(:,2);
%    dg = R1(3,:)*dR2dp(:,3);
%    drdp = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
%    df = R1(3,:)*dR2dq(:,2);
%    dg = R1(3,:)*dR2dq(:,3);
%    drdq = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );

    % f = mat(3,1) = R1(3,1)*R2(1,2) + R1(3,2)*R2(2,2) + R1(3,3)*R2(3,2)
    % D( -asin( f ) ) = (1/sqrt(1-f^2)) * df
%    dasin = -(1/sqrt(1-(R1(3,:)*R2(:,1))^2));
%    dpdr = dasin * R1(3,:)*dR2dr(:,1);
%    dpdp = dasin * R1(3,:)*dR2dp(:,1);
%    dpdq = dasin * R1(3,:)*dR2dq(:,1);

    % f = mat(2,1)
    % g = mat(1,1)
    % D( atan(f/g) ) = (1/(1+(f/g)^2)) * ( g*df - f*dg)/g^2
%    f = R1(2,:)*R2(:,1);
%    g = R1(1,:)*R2(:,1);
%    df = R1(2,:)*dR2dr(:,1);
%    dg = R1(1,:)*dR2dr(:,1);
%    dqdr = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
%    df = R1(2,:)*dR2dp(:,1);
%    dg = R1(1,:)*dR2dp(:,1);
%    dqdp = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );
%    df = R1(2,:)*dR2dq(:,1);
%    dg = R1(1,:)*dR2dq(:,1);
%    dqdq = (1/ (1+(f/g)^2) )* ((g*df - f*dg) / g^2 );

%    Jx2 = [ R1 zeros(3) ; zeros(3) ...
%            [ drdr drdp drdq; dpdr dpdp dpdq; dqdr dqdp dqdq ] ];

%    simplify( Jx2 - jacobian( fcompound, x2 ) )

