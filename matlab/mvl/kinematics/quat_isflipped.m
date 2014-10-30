
function bool = quat_isflipped( q1, q2 )

    bool = false;
    if( norm( q1+q2 ) < 10 * eps )
        bool = true;
    end
