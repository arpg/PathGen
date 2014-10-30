
    % check code for 3d_to_2d
    clear all;
    syms fx cx fy cy sx width height p1 p2 p3 pt3;
    syms pose1 pose2 pose3 pose4 pose5 pose6 pose;
    pt3 = [p1; p2; p3];
    pose = [pose1;pose2;pose3;pose4;pose5;pose6];

    Rwc = eulerRPY_to_rotmat( pose(4:6) );

    % compute directly
    xcp = Rwc.'*( pt3 - pose(1:3) );
    pt2_direct(1,1) = ( fx*xcp(2)/xcp(1) + sx*xcp(3)/xcp(1) + cx );
    pt2_direct(2,1) = ( fy*xcp(3)/xcp(1) + cy );

    % OR, compute using the "K" matrix way
    K = [  1,     0,     0; ...
          cx,    fx,  sx; ...
          cy,     0,    fy ];

    invK = inv( K )

    % projection...
    lx = K*Rwc.'*( pt3 - pose(1:3) );
    gx = lx(1);

    % ...and divide by range
    hx(1,1) = lx(2)/gx(1);
    hx(2,1) = lx(3)/gx(1);

    % verify
    simplify( hx - pt2_direct )

    % OK, now compute Jacobian of 3d_to_2d wrt pt3
    % sensor model, hx = lx/gx = 3d_to_2d
    % where lx = K*Rwc'( pt3 - pose )
    % and gx = range component of lx.
    % So first compute dldx from
    % lx = K*(Rwc'*pt3 - Rwc'*pose )
    % so
    % dldx = K*Rwc'
    % and hence
    % dgdx = range component of Jhx (top row in the robotics convention),
    % dgdx = dldx(1,:)
    % so, using the quotient rule
    % dhdx = (gx*dldx - lx*dgdx)/gx^2

    dldx = K*Rwc.';
    dgdx = dldx(1,:);
    dhdx = (gx*dldx - lx*dgdx)/(gx^2);
    dhdx = dhdx(2:3,:); % ignore top row

    % calc K*Rwc.' directly
    dldx_direct(1,1) = Rwc(1,1);
    dldx_direct(2,1) = cx*Rwc(1,1) + fx*Rwc(1,2) + sx*Rwc(1,3);
    dldx_direct(3,1) = cy*Rwc(1,1) + fy*Rwc(1,3);

    dldx_direct(1,2) = Rwc(2,1);
    dldx_direct(2,2) = cx*Rwc(2,1) + fx*Rwc(2,2) + sx*Rwc(2,3); 
    dldx_direct(3,2) = cy*Rwc(2,1) + fy*Rwc(2,3); 

    dldx_direct(1,3) = Rwc(3,1);
    dldx_direct(2,3) = cx*Rwc(3,1) + fx*Rwc(3,2) + sx*Rwc(3,3); 
    dldx_direct(3,3) = cy*Rwc(3,1) + fy*Rwc(3,3); 

    % verify
    dldx - dldx_direct

    % verify
    simplify( jacobian( hx, pt3 ) - dhdx )

