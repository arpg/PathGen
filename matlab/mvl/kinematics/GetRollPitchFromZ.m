%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Given a down "z-axis" figure out the equivalent roll and pitch that
% will point z in the same direction.
function pq = GetRollPitch( z )
    pq = [ -asin(z(2));  atan2( z(1), z(3) ) ];

