
function epose = GetPathAlighment( x )

    c = mean( x' )';
    A = x - repmat( c, 1, size(x,2) ) ;
    M = A*A.';

    [U,S,V] =  svd( M );

    pqr = rotmat_to_eulerPQR( V );

    epose = [ c; pqr ];

