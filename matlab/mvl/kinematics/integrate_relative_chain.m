%
% [p,d] = integrate_relative_chain( RelativeChain, StartPose )
%
% Convert chain of relative transforms into a path in a single coordinate
% frame.
%
% NB: x,y,th code uses +y forward, +x right while 6DOF code uses xyz-fixed
% frame (+x forward, +y right, +z down).
%
function [p,d] = integrate_relative_chain( rel, startpose )
    p = startpose;
    d = 0;
    
    if( size(p,1) == 6  )
        for ii = 1:size(rel,2)
            Tw1 = Cart2T(p(:,ii));
            T12 = Cart2T(rel(:,ii));
            Tw2 = Tw1*T12;
            p(:,ii+1) = T2Cart( Tw2 );
            d = d + norm( rel(1:2,ii) );
        end
    elseif( size(p,1) == 3 )
        for ii = 1:size(rel,2)
%        Tab = Cart2T(p(:,ii));
%        Tbc = Cart2T(rel(:,ii));
%        p(:,ii+1) = T2Cart( Tab*Tbc );
            p(:,ii+1) = tcomp( p(:,ii), rel(:,ii) );
            d = d + norm( rel(1:2,ii) );
        end

    end
    