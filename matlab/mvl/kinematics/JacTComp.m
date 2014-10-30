% [J1, J2] = JacTComp( tab, tbc )

function  [J1, J2] = JacTComp( tab, tbc )
    cq = cos(attitude(3));
    cp = cos(attitude(2));
    cr = cos(attitude(1));

    sq = sin(attitude(3));
    sp = sin(attitude(2));
    sr = sin(attitude(1));

    Rz = [  cq   -sq    0; ...
            sq    cq    0; ...
               0       0    1];

    Ry = [  cp   0   sp  ; ...
              0   1     0  ; ...
          -sp   0   cp ];

    Rx = [  1       0      0 ;...
            0    cr  -sr ; ...
            0    sr   cr];

    R = Rz*Ry*Rx;

    tbc = T2Cart(Tab*Tbc);

    J1 =  


