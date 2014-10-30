%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% m = MoveFrames( xwi, p )
%
% Move a trajectory by some initial transform.
%
function m = MoveFrames( xwi, p )
    Twi = Cart2T(xwi);
    m = zeros(size(p));
    for ii = 1:size(p,2)
        m(:,ii) = T2Cart( Twi*Cart2T(p(:,ii)) );
    end
end

