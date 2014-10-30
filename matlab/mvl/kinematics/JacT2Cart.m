%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  J = JacT2Cart( T )
%  Compute the 6x16 Jacoboian of T wrt to vec(T).
function J = JacT2Cart( T )

    % Error if det(R) ~= 1
    if( abs( det(T(1:3,1:3)) - 1) > 1e-9 )
        det(T(1:3,1:3))
        error('Error: JacT2Cart( T ) -- det(T(1:3,1:3)) ~= 1 ' );
    end

    % Recall
    % T = [      cp*cq, -cr*sq+sr*sp*cq,  sr*sq+cr*sp*cq,  x; ...
    %            cp*sq,  cr*cq+sr*sp*sq, -sr*cq+cr*sp*sq,  y; ...
    %              -sp,           sr*cp,           cr*cp,  z; ...
    %                0,               0,               0,  1];
    % This is rotation about the fixed frame. 
    % see eqn 2.20 of Modelling and Control of Robot Manip.
    %
    % ds = c
    % dc = -s
    % 
    % Also, T2Cart is (for small rpq, which we assume!):
    %
    %  x =  T(1,4)
    %  y =  T(2,4)
    %  z =  T(3,4)
    %  r =  atan2( T(3,2), T(3,3) );
    %  p = -asin( T(3,1));
    %  q =  atan2( T(2,1), T(1,1) );
    %
    % J = { \partial vec(T2Cart(T)) } \over {\parital vec(T)' }
    % So J is mostly zeros then:
    J = zeros(6,16);

    % vec(T):  T(1,1) = 1 
    %          T(2,1) = 2 
    %          T(3,1) = 3 
    %          T(4,1) = 4 

    %          T(1,2) = 5 
    %          T(2,2) = 6 
    %          T(3,2) = 7 
    %          T(4,2) = 8 

    %          T(1,3) = 9 
    %          T(2,3) = 10 
    %          T(3,3) = 11 
    %          T(4,3) = 12 

    %          T(1,4) = 13 
    %          T(2,4) = 14 
    %          T(3,4) = 15 
    %          T(4,4) = 16

    % 1/x = x^-1, d(1/x) = -x^-2
    % r = atan( y / x ) = atan(g(y,x)), g(y,x) = y/x
    % datan/dg = 1/(1+g^2)
    % 
    %   dg/dy = 1/x
    %   dr/dy = datan/dg * dg/dy
    %         =  1/(1+g^2) * 1/x 
    % and,
    %   dg/dx = -y/(x^2)
    %   dr/dx = datan/dg * dg/dy
    %         =  -1/(1+g^2) * y/(x^2)

    J( 1, 13 ) = 1;  % x: Depends on T(1,4), which is the 13 element
    J( 2, 14 ) = 1;  % y: Depends on T(2,4), which is the 14 element
    J( 3, 15 ) = 1;  % z: Depends on T(3,4), which is the 15 element
    x = T(3,3); y = T(3,2); g = y/x;
    J( 4, 7  ) = 1/(1+g^2) * 1/x; % r: This is d/x7[ atan( x7 / x11 ) ];
    J( 4, 11 ) = -1/(1+g^2) * y/(x^2); % r: This is d/x11[ atan( x7 / x11 ) ];

    J( 5, 3 )  = 1/sqrt(1-T(3,1)^2);% p: depends on T(3,1) or "x3", d/dx3(asin(x3)) = 1/sqrt(1-x^2)

    x = T(2,1); y = T(1,1); g = y/x;
    J( 6, 1 ) = 1/(1+g^2) * 1/x; % r: This is d/x1[ atan( x2 / x1 ) ];
    J( 6, 2 ) = -1/(1+g^2) * y/(x^2); % r: This is d/x2[ atan( x2 / x1 ) ];


    % so that's J


