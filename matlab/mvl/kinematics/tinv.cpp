#include <math.h>
#include "mex.h"
#include "matrix.h"

// tba = tinv( tab )
void mexFunction(int nlhs, mxArray *plhs[ ],int nrhs, const mxArray *prhs[ ])
{
    double* tab = (double *)mxGetPr( prhs[0] );
    if( mxGetM( prhs[0] ) == 6 ){
        mexErrMsgTxt("Error: write me\n");
    }
    if( mxGetM( prhs[0] ) == 3 ){
        plhs[0] = mxCreateDoubleMatrix( 3, 1, mxREAL );
        double *tba = mxGetPr( plhs[0] ); 
        double s = sin(tab[2]);
        double c = cos(tab[2]);

        tba[0] = -tab[0]*c - tab[1]*s;
        tba[1] =  tab[0]*s - tab[1]*c;
        tba[2] = -tab[2];
    }
    else{
        mexErrMsgTxt("Error: tinv only supports 3x1 poses now...\n");
    }
}

