#include <math.h>
#include "mex.h"
#include "matrix.h"

double angle_wrap( double angle )
{
    while( angle > M_PI ){
        angle = angle - 2*M_PI;
    }
    while( angle < -M_PI ){
        angle = angle + 2*M_PI;
    }
}

// tac = tcomp( tab, tbc )
void mexFunction(int nlhs, mxArray *plhs[ ],int nrhs, const mxArray *prhs[ ])
{
    double* tab = (double *)mxGetPr( prhs[0] );
    if( mxGetM( prhs[0] ) == 6 ){
        mexErrMsgTxt("Error: write me\n");
    }
    double* tbc = (double *)mxGetPr( prhs[1] );
    if( mxGetM( prhs[1] ) == 6 ){
        mexErrMsgTxt("Error: write me\n");
    }

    if( mxGetM( prhs[0] ) == 3 ){
        plhs[0] = mxCreateDoubleMatrix( 3, 1, mxREAL );
        double *tac = mxGetPr( plhs[0] ); 
        double s = sin(tab[2]);
        double c = cos(tab[2]);
        double result = tab[2]+tbc[2];

        if( result > M_PI | result <= -M_PI ){
            result = angle_wrap(result) ;
        }

        tac[0] = tab[0] + c*tbc[0] - s*tbc[1];
        tac[1] = tab[1] + s*tbc[0] + c*tbc[1];
        tac[2] = result;
    }
    else{
        mexErrMsgTxt("Error: tcomp only supports 3x1 poses now...\n");
    }
}



 
