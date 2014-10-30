
function d = path_integral( p )

    d = zeros(1,size(p,2));
    if( size(p,1) == 3 )
        for ii = 2:size(p,2)
           %d = [ d, d+norm( p(1:2,ii)-p(1:2,ii-1) ) ];
           d(ii) = d(ii-1) + norm( p(1:2,ii)-p(1:2,ii-1) );
        end
    elseif( size(p,1) == 6 )
        for ii = 2:size(p,2)
           %d = [ d, d+norm( p(1:3,ii)-p(1:3,ii-1) ) ];
           d(ii) = d(ii-1) + norm( p(1:3,ii)-p(1:3,ii-1) );
        end
    else
        error 'path must be 6xN or 3xN';
    end

