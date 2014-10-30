%-------------------------------------------------------
% composes two transformations
%
% Author:  Jose Neira
% Version: 1.0, 7-Dic-2000
%-------------------------------------------------------
% History: Gabe Sibley -- 2004 added 6DOF equations.
%-------------------------------------------------------
function tac=tcomp(tab,tbc),

if size(tab,1) == 6
    tac = compound_op( tab,tbc );
    return;
end

if size(tab,1) ~= 3
   error('TCOMP: tab is not a transformation!!!');
end;

if size(tbc,1) ~= 3,
   error('TCOMP: tbc is not a transformation!!!');
end;

result = tab(3)+tbc(3);

if result > pi | result <= -pi
   result = angle_wrap(result) ;
end

s = sin(tab(3));
c = cos(tab(3));
%a = tab(3);
%s = a - a^3/6;
%c = 1 - a^2/2;

%tac = [tab(1:2)+ [c -s; s c]*tbc(1:2);
%       result];
tac(1,1) = tab(1) + c*tbc(1) - s*tbc(2);
tac(2,1) = tab(2) + s*tbc(1) + c*tbc(2);
tac(3,1) = result;
   
