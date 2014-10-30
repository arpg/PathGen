function l = T2Cart( T )
    if( size(T,1) == 4 && size(T,2) == 4 )
        l = hpose_to_epose( T );
    elseif( size(T,1) == 3 && size(T,2) == 3 )
        l(1) = T(1,3);
        l(2) = T(2,3);
        l(3) = acos(T(1,1));
    else
        error('T2Cart -- incorrect matrix size, must be 4x4 or 3x3');
    end
