%-------------------------------------------------------
% calculates the inverse of one or more transformations
%
% Author:  Jose Neira
% Version: 1.0, 7-Dic-2000
%-------------------------------------------------------
% History:
%-------------------------------------------------------
%-------------------------------------------------------
function tba=tinv(tab)
%
% calculates the inverse of one transformations
%-------------------------------------------------------
if size(tab,1) == 6
    tba = inverse_op(tab);
    return;
end

s = sin(tab(3));
c = cos(tab(3));
tba = [-tab(1)*c - tab(2)*s;
        tab(1)*s - tab(2)*c;
       -tab(3)];


