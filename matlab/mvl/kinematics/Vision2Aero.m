function y = Visin2Aero( x )

    % vision to aero RDf 
    RDF = [ 0 0 1;...
            1 0 0;...
            0 1 0 ];...
    if( size(x,1) == 3 )
        y = RDF*x(1:3,:); 
    elseif( size(x,1) == 4 && size(x,2) == 4 )    
        y  = [ RDF*x(1:3,1:3)*RDF',  RDF*x(1:3,4); 0 0 0 1 ];
    else
        error('x must be 3xN or 4x4');
    end

