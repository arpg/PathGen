function y = Aero2Vision( x )

    % Given 4x4 Tr and 3x1 xr in robo frame, how to convert Tr and xr to the vision frame (call them Tv and xv)?
    % We know that xv = M*xr where M is the robo_to_vis RDF matrix.  So xr is easy. 
    %
    % For Tv, think of the projection in vision frame: 
    %
    % uvw = K*inv(Tv)*xv
    %     = K*M*inv(Tr)*xr
    %     = K*M*inv(Tr)*inv(M)*M*xr
    %     = K*[M*inv(Tr)*inv(M)]*xv
    %
    % So, inv(Tv) = M*inv(Tr)*inv(M), and working backwards, Tv = M*Tr*M'.
    %


    % aero to vision RDf 
    RDF = [ 0 1 0;...
            0 0 1;...
            1 0 0 ];...

    if( size(x,1) == 3 )
        y = RDF*x(1:3,:);
    elseif( size(x,1) == 4 && size(x,2) == 4 )
        y  = [ RDF*x(1:3,1:3)*RDF',  RDF*x(1:3,4); 0 0 0 1 ];
    else
        error('x must be 3xN or 4x4');
    end

