%%
%  [rel,startpose] = path_to_rel( p )
%  Convert a path into a chain of relative transforms
%
% NB: x,y,th code uses +y forward, +x right while 6DOF code uses xyz-fixed
% frame (+x forward, +y right, +z down).
%
function [rel,startpose] = make_relative_chain( p )
    startpose = p(:,1);

    rel = zeros( size(p,1), size(p,2)-1 );
    
    if( size(p,1) == 6 )
        Tw1 = Cart2T(p(:,1));
        for ii = 1:size(p,2)-1
            Tw2 = Cart2T(p(:,ii+1));
            T12 = inv(Tw1)*Tw2;
            rel(:,ii) = T2Cart(T12);
            Tw1 = Tw2; % for next loop
        end
    else
        for ii = 1:size(p,2)-1
            rel(:,ii) = tcomp( tinv(p(:,ii)), p(:,ii+1) ); 
        end
    end
