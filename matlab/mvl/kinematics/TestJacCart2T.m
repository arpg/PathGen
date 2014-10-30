%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here's how you test Jacobians, both numerically and symbolically.
% NB I make use of the "vec" operator to simplify Jacobians.
function TestJacCart2T

    X = 100*randn(6,1);
    vecT = reshape( Cart2T( X ), 16, 1 );

    % 1) By hand:
    J = JacCart2T( X )

    % 2) Finite differences:
    fdJ = FiniteDiff( @Cart2VecT, X )

    J - fdJ
    return
    
    % 3) Double check with Maple:
    syms x y z r p q;
    symX = [x;y;z;r;p;q];
    symJ =  simple( jacobian( Cart2VecT(symX), symX ) )

    fin = inline( char(symJ), 'x', 'y', 'z', 'r', 'p', 'q' );
    symJ = eval( subs( symJ, symX, X ) )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cart2VecT: 6->16 computes vec(t) from Euler-xyz fixed pose 
function vecT = Cart2VecT( x )
    vecT = reshape( Cart2T( x ), 16, 1 );

