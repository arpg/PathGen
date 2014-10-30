
function d = relative_path_integral( r, s )

    d = zeros(1,size(r,2));
    if( size(r,1) == 3 )
        for ii = 2:size(r,2)
           d(ii) = d(ii-1)+norm( r(1:2,ii) );
        end
    elseif( size(r,1) == 6 )
        for ii = 2:size(r,2)
           d(ii) = d(ii-1)+norm( r(1:3,ii) );
        end
    else
        error 'path must be 6xN or 3xN';
    end

