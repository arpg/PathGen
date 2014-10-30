%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jacobian of the inverse operator.  I am surprised at how complex this is.
% More reason to use error-state formulations.
function J = JInv( xab )

% recall:
%     R = Cart2R(xab(4:6));
%  xba = [-R'*xab(1:3); R2Cart(R')];

    R = Cart2R(xab(4:6));

%    syms cq;

    J11 = -R.';

    % this is derivative of -R' wrt x(4:6), times xab(1:3)
    sr = sin(xab(6));
    cr = cos(xab(6));

    G1 = R*[ 0   0   0 ; ...
             0   0  -1 ; ...
             0   1   0];
    G2 =   -[ 0   0  cr ; ...
             0   0  sr ; ...
           -cr -sr   0 ]*R;
    G3 =   [ 0  -1   0; ...
             1   0   0; ...
             0   0   0]*R;
    J12 = -[ G1.'*xab(1:3),  G2.'*xab(1:3),  G3.'*xab(1:3) ];

	% ok, now the hard part:
    R = R.';
    R11 = R(1,1);    R12 = R(1,2);    R13 = R(1,3);
    R21 = R(2,1);    R22 = R(2,2);    R23 = R(2,3);
    R31 = R(3,1);    R32 = R(3,2);    R33 = R(3,3);

    a = R33^2+R32^2;
    b = -1/(1-R31^2)^(1/2);
    c = R11^2+R21^2;

    a21 = (R33*R12*cos(xab(4)) - R32*R13*cos(xab(4)))/a;
    
    J22 = [ -R33/a*R22+R32/a*R23,                                    a21,             R33/a*R31;...
                          -b*R21,                               b*cr*R33,                -b*R32;...
                       R11/c*R31,             -R21/c*cr*R13+R11/c*cr*R23,   R21/c*R12-R11/c*R22];

	J = [ J11, J12; zeros(3), J22 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
function DeriveJInv

    syms p q r R11 R12 R13 R21 R22 R23 R31 R32 R33;
    R = [ R11 R12 R13; R21 R22 R23; R31 R32 R33 ];
    old = {'cos(r)*cos(q)', '-sin(r)*cos(p)+cos(r)*sin(q)*sin(p)',  'sin(r)*sin(p)+cos(r)*sin(q)*cos(p)'...
           'sin(r)*cos(q)',  'cos(r)*cos(p)+sin(r)*sin(q)*sin(p)', '-cos(r)*sin(p)+sin(r)*sin(q)*cos(p)'...
                ' -sin(q)',                       'cos(q)*sin(p)',                       'cos(p)*cos(q)'};
    new = {'R11','R12','R13','R21','R22','R23','R31','R32','R33'};

    x = [p;q;r];

    Fp = simplify( jacobian( R2Cart(R), R ) );
    Fp = subs( Fp, '(R33^2+R32^2)', 'a' );
    Fp = subs( Fp, '-1/(1-R31^2)^(1/2)', 'b' );
    Fp = subs( Fp, '(R11^2+R21^2)', 'c' );

    Gp = simplify( jacobian( R.', R ) );
    Hp = simplify( jacobian( Cart2R(x), x ) )
    J = simplify( Fp*Gp*Hp )
    J = simplify( jacobian( R2Cart(Cart2R(x).')) )
    Hpb = dCart2R_dx( x );
    J = simplify( Fp*Gp*Hpb )

    xab = randn(6,1);
    JInv( xab )
    FiniteDiff( @inverse_op, xab )

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% dgdx, where g = Cart2R(x)' = dRt/dx
function G = dCart2Rt_dx( x )
    R = Cart2R( x );

    syms cq R11 R12 R13 R21 R22 R23 R31 R32 R33;
    R = [ R11 R12 R13; R21 R22 R23; R31 R32 R33 ];

%	cq = sqrt( 1 - R(3,1)^2 );
	cr = R11/cq;
	sr = R21/cq;   
%    sq = -R(3,1);
%    cq = sqrt( 1 - sq^2 );
%    cq = cos(asin(sq));

    G1 = R*[ 0   0   0 ; ...
             0   0  -1 ; ...
             0   1   0];

    G2 =   [ 0   0  cr ; ...
             0   0  sr ; ...
           -cr -sr   0 ]*R;

    G3 =   [ 0  -1   0; ...
             1   0   0; ...
             0   0   0]*R;
    G = [ reshape(G1.',9,1),  reshape(G2.',9,1),  reshape(G3.',9,1) ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% dgdx, where g = Cart2R(x)' = dRt/dx
function G = dCart2R_dx( x )
    R = Cart2R( x );

    syms q;
    syms R11 R12 R13 R21 R22 R23 R31 R32 R33;
    R = [ R11 R12 R13; R21 R22 R23; R31 R32 R33 ];

    cr = R(1,1)/cos(q);
	sr = R(2,1)/cos(q);

    G1 = R*[ 0   0   0 ; ...
             0   0  -1 ; ...
             0   1   0];

    G2 =   [ 0   0  cr ; ...
             0   0  sr ; ...
           -cr -sr   0 ]*R;

    G3 =   [ 0  -1   0; ...
             1   0   0; ...
             0   0   0]*R;
    G = [ reshape(G1,9,1),  reshape(G2,9,1),  reshape(G3,9,1) ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Same as above, but not for transpose
% dgdx, where g = Cart2R(x) = dR/dx
function J = dCart2R_dx_at_x0( x, x0 )
    R = Cart2R( x );

    syms cq;
  	cr = R(1,1)/cq;
	sr = R(2,1)/cq;

    G1 = R*[ 0   0   0 ; ...
             0   0  -1 ; ...
             0   1   0];

    G2 =   [ 0   0  cr ; ...
             0   0  sr ; ...
           -cr -sr   0 ]*R;

    G3 =   [ 0  -1   0; ...
             1   0   0; ...
             0   0   0]*R;
    
    J = [ G1.'*x0,  G2.'*x0,  G3.'*x0 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%
%    f(g(h(x))
%    f = R2Cart(g)
%    g = h'
%    h = Cart2R(x)
%    
%    df/dx = df/dg       * dg/dh  * dh/dx
%          = dR2Cart/dRt * dRt/dR * dR/dx
%
%   dRt/dR is a 9x9 mapping. but all it does is permute? right
%
%   output  input
%   R11 = R11
%   R21 = R12
%   R31 = R13
%   R12 = R21
%   R22 = R22
%   R32 = R23
%   R13 = R31
%   R23 = R32
%   R33 = R33
%
%   So, dRt/dt is
%
%   dRt/dt = [ 1, 0, 0,  0, 0, 0,  0, 0, 0;...
%              0, 0, 0,  1, 0, 0,  0, 0, 0;...
%              0, 0, 0,  0, 0, 0,  1, 0, 0;...
%
%              0, 1, 0,  0, 0, 0,  0, 0, 0;...
%              0, 0, 0,  0, 1, 0,  0, 0, 0;...
%              0, 0, 0,  0, 0, 0,  0, 1, 0;...
%
%              0, 0, 1,  0, 0, 0,  0, 0, 0;...
%              0, 0, 0,  0, 0, 1,  0, 0, 0;...
%              0, 0, 0,  0, 0, 0,  0, 0, 1 ];
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the Jacobian of R2Cart, wrt R
function F = dR2Cart_dR( R )
    a = (R(3,3)^2+R(3,2)^2)
    b = -1/(1-R(3,1)^2)^(1/2)
    c = (R(1,1)^2+R(2,1)^2)
    syms a b c
    F = [         0,         0,  0,  0,  0, R(3,3)/a,  0,  0, -R(3,2)/a ;...
                  0,         0,  b,  0,  0,        0,  0,  0,         0 ;...
          -R(2,1)/c,  R(1,1)/c,  0,  0,  0,        0,  0,  0,         0 ];
