
% cam2str( cmod, pose )   write camera model to XML string.

function str = cam2str( cmod, pose )
    tmp = strcat( tempname, '.xml' );
    mvl_camera_write( pose, cmod, tmp );
    f = fopen( tmp, 'r' );
    str = [];
    l = fgets(f);
    while ischar(l)
        str = sprintf( '%s%s', str, l );
        l = fgets(f);
    end

