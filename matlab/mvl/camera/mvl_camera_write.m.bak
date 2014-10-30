% MVL_CAMERA_WRITE( FILENAME, HHPOSE, CAMERA_MODEL)
%    save CAMERA_MODEL to XML file FILENAME.  HHPOSE is a 4x4 homogeneous pose
%    matrix.

function mvl_camera_write( filename, hpose, cmod )

    if( cmod.type == 'MVL_CAMERA_LINEAR' )
        mvl_camera_linear_write( filename, hpose, cmod );
    elseif( cmod.type == 'MVL_CAMERA_LINEAR' )
        mvl_camera_warped_write( filename, hpose, cmod );
    end

function mvl_camera_linear_write( filename, hpose, cmod )

    fid = fopen( filename, 'w' );

    epose = hpose_to_epose( hpose );

    fprintf( fid, '<!--MVL camera model\n%s-->\n\n', date);
    fprintf( fid, '<camera_model type="MVL_CAMERA_LINEAR"');
    fprintf( fid, ' camid=\"%s\"', cmod.serialno );
    fprintf( fid, ' version=\"%d\">\n', 5 ); 

    fprintf( fid, '    <right  >  %d; %d; %d  </right>\n', cmod.RDF(1,1:3) );
    fprintf( fid, '    <down   >  %d; %d; %d  </down>\n', cmod.RDF(2,1:3) );
    fprintf( fid, '    <forward>  %d; %d; %d  </forward>\n', cmod.RDF(3,1:3) );

    fprintf( fid, '    <pose  > %f; %f; %f; %f; %f; %f </pose>\n', epose );
    fprintf( fid, '    <width > %d </width>\n', cmod.width );
    fprintf( fid, '    <height> %d </height>\n', cmod.height );
    fprintf( fid, '    <fx    > %f </fx>\n', cmod.fx );
    fprintf( fid, '    <cx    > %f </cx>\n', cmod.cx );
    fprintf( fid, '    <fy    > %f </fy>\n', cmod.fy );
    fprintf( fid, '    <cy    > %f </cy>\n', cmod.cy );
    fprintf( fid, '    <sx    > %f </sx>\n', cmod.sx );
    fprintf( fid, '</camera_model>\n'); 

    fclose( fid );


function mvl_camera_warped_write( filename, hpose, cmod )

    fid = fopen( filename, 'w+' );

    epose = hpose_to_epose( hpose );

    fprintf( fid, '<!--MVL camera model\n%s-->\n\n', date);
    fprintf( fid, '<camera_model type="MVL_CAMERA_WARPED"');
    fprintf( fid, ' camid=\"%s\"', cmod.camid );
    fprintf( fid, ' version=\"%d\">\n', 5 );

    fprintf( fid, '    <right  >  %d; %d; %d  </right>\n', cmod.RDF(1,1:3) );
    fprintf( fid, '    <down   >  %d; %d; %d  </down>\n', cmod.RDF(2,1:3) );
    fprintf( fid, '    <forward>  %d; %d; %d  </forward>\n', cmod.RDF(3,1:3) );

    fprintf( fid, '    <pose   type="double">%f; %f; %f; %f; %f; %f </pose>\n', epose );
    fprintf( fid, '    <width  type="double">%d</width>\n', cmod.width );
    fprintf( fid, '    <height type="double">%d</height>\n', cmod.height );
    fprintf( fid, '    <fx     type="double">%f</fx>\n', cmod.fx );
    fprintf( fid, '    <cx     type="double">%f</cx>\n', cmod.cx );
    fprintf( fid, '    <fy     type="double">%f</fy>\n', cmod.fy );
    fprintf( fid, '    <cy     type="double">%f</cy>\n', cmod.cy );
    fprintf( fid, '    <sx     type="double">%f</sx>\n', cmod.sx );
    fprintf( fid, '    <kappa1 type="double">%f</kappa1>\n', cmod.kappa1 );
    fprintf( fid, '    <kappa2 type="double">%f</kappa2>\n', cmod.kappa2 );
    fprintf( fid, '    <kappa3 type="double">%f</kappa3>\n', cmod.kappa3 );
    fprintf( fid, '    <tau1   type="double">%f</tau1>\n', cmod.tau1 );
    fprintf( fid, '    <tau2   type="double">%f</tau2>\n', cmod.tau2 );
    fprintf( fid, '</camera_model>\n');

    fclose( fid );
