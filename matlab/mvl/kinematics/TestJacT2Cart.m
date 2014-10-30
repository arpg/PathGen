%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here's how you test Jacobians, both numerically and symbolically.
% NB I make use of the "vec" operator to simplify Jacobians.
function TestJacT2Cart

    xyzrpq = 100*randn(6,1);
    T = Cart2T( xyzrpq );
    xyzrpq = T2Cart( T ); % go backwards to "round" the randn

    % 1) By hand:
    J = JacT2Cart( T )

    % 2) Finite differences:
    vecT = reshape(T,numel(T),1); % original input
    fdJ = FiniteDiff( @VecT2Cart, vecT )

    % 3) Double check with Maple:
    syms T11 T12 T13 T14 T21 T22 T23 T24 T31 T32 T33 T34 T41 T42 T43 T44;
    symT = [T11, T12, T13, T14; T21, T22, T23, T24; T31, T32, T33, T34; T41, T42, T43, T44 ];
    symVecT = reshape( symT, 16,  1);
    symJ =  simple( jacobian( VecT2Cart(symVecT), symVecT ) );
    fin = inline( char(symJ), 'T11','T12','T13','T14','T21','T22','T23',...
                       'T24','T31','T32','T33','T34','T41','T42','T43','T44' );
    symJ = eval( subs( symJ, symVecT, vecT ) )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VecT2Cart:16->6 computes Euler-xyz fixed pose from vec(T)
function xyzrpq = VecT2Cart( vecT )
    xyzrpq = T2Cart( reshape(vecT,4,4) );

