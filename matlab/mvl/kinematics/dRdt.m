%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% See Modeling and Control of Robot Manipulators. Sec. 3.1.1.
%
function d = dRdt( R, w )
    d = Skew( w )*R;

