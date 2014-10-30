%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  J = FiniteDiff( f, x )
    %  perturb each dimension of x, for each Col of J
    dEps = 1e-4;
    y = feval( f, x );
    J = zeros( numel(y), numel(x) );
    for ii = 1:numel(x)
        xPlus = x;    
        xPlus(ii) = xPlus(ii) + dEps;
        yPlus = feval( f, xPlus );

        xMinus = x;
        xMinus(ii) = xMinus(ii) - dEps;
        yMinus = feval( f, xMinus );

        % centeral difference slope:
        J(:,ii) = (yPlus - yMinus)./(2*dEps);
    end

