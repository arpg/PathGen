% pt = mvl_camera_K_3d_to_3d( pt3, hpose, K, RDF )

function pt = mvl_camera_K_3d_to_3d( pt3, hpose, K, RDF )

    pt = K*RDF*hpose(1:3,1:3)'*( pt3 - hpose(1:3,4) );
    pt = pt/pt(3);
    pt(3) = []; 
