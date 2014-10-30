% [ MODEL,HPOSE ] = MVL_CAMERA_READ loads a camera model and it's 4x4 
%   homogenous pose.

function [cmod,hpose] = mvl_camera_read( filename )

    cmod = [];
    hpose = eye(4);

    % xml file?
    if( findstr( '.xml', filename) )
        dom = xmlread( filename );

        cmod.type = get_elt_attr_val( dom, 'camera_model', 'type' );
        cmod.name = get_elt_attr_val( dom, 'camera_model', 'name' );
        cmod.index = get_elt_attr_val( dom, 'camera_model', 'index' );
        cmod.serialno = get_elt_attr_val( dom, 'camera_model', 'serialno' );
        xml_version = get_elt_attr_val( dom, 'camera_model', 'version' );

        if( str2num( xml_version ) ~= 7 )
            error('File "%s" is using an unsupported XML version (need version 7)', filename );
        end
                
        hpose = epose_to_hpose( str2num( get_elt_val( dom, 'pose' ) ) );

        if (strcmp( cmod.type, 'MVL_CAMERA_LINEAR' ) == true || strcmp( cmod.type, 'MVL_CAMERA_LUT' ) == true)
            forward = str2num( get_elt_val( dom, 'forward' ) );
            right   = str2num( get_elt_val( dom, 'right' ) );
            down    = str2num( get_elt_val( dom, 'down' ) );
            cmod.RDF     = [ right'; down'; forward' ]; 
            cmod.width   = str2num( get_elt_val( dom, 'width' ) );
            cmod.height  = str2num( get_elt_val( dom, 'height' ) );
            cmod.fx      = str2num( get_elt_val( dom, 'fx' ) );
            cmod.cx      = str2num( get_elt_val( dom, 'cx' ) );
            cmod.fy      = str2num( get_elt_val( dom, 'fy' ) );
            cmod.cy      = str2num( get_elt_val( dom, 'cy' ) );
            cmod.sx      = str2num( get_elt_val( dom, 'sx' ) );
        elseif strcmp( cmod.type, 'MVL_CAMERA_WARPED' ) == true
            forward = str2num( get_elt_val( dom, 'forward' ) );
            right   = str2num( get_elt_val( dom, 'right' ) );
            down    = str2num( get_elt_val( dom, 'down' ) );
            cmod.RDF     = [ right'; down'; forward' ]; 
            cmod.width  = str2num( get_elt_val( dom, 'width' ) );
            cmod.height = str2num( get_elt_val( dom, 'height' ) );
            cmod.fx     = str2num( get_elt_val( dom, 'fx' ) );
            cmod.cx     = str2num( get_elt_val( dom, 'cx' ) );
            cmod.fy     = str2num( get_elt_val( dom, 'fy' ) );
            cmod.cy     = str2num( get_elt_val( dom, 'cy' ) );
            cmod.sx     = str2num( get_elt_val( dom, 'sx' ) );
            cmod.kappa1 = str2num( get_elt_val( dom, 'kappa1' ) );
            cmod.kappa2 = str2num( get_elt_val( dom, 'kappa2' ) );
            cmod.kappa3 = str2num( get_elt_val( dom, 'kappa3' ) );
            cmod.tau1     = str2num( get_elt_val( dom, 'tau1' ) );
            cmod.tau2     = str2num( get_elt_val( dom, 'tau2' ) );
        else
			cmod
            error( sprintf('Error: %s unrecognized model type %s\n',...
						filename, cmod.type ) );
        end
    else
        % TODO: add functions to import camera models stored in different
        % formats.
        error( sprintf('Error: %s unrecognized file\n', filename ) );
    end

function val = get_elt_attr_val( dom, elt, attr );
    val = char( dom.getElementsByTagName(elt).item(0).getAttribute(attr) );

function val = get_elt_val( dom, name )

    elt = dom.getElementsByTagName(name).item(0);
    if( isempty(elt) )
        val = '';
    else
        val = elt.getFirstChild.getData;
    end

