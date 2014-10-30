#include <stdio.h>
#include <string.h>
#include <math.h>

#include <mvl/image/image.h>
#include <mvl/matrix/matrix.h>
#include <mvl/kinematics/kinematics.h>
#include <mvl/camera/camera.h>
#include <mvl/stereo/stereo.h>

#include "mvl_camera_mex_utils.h"

#include "mex.h"

#define max(a,b) ( a > b ? a : b )
#define min(a,b) ( a < b ? a : b )

extern int errno;

/****************************************************************************/
/*
  matlab funciton: dispmap( DepthMap, LeftCam, LeftPose, RightCam, RightPose, DispMap );

  Fills in DispMap.

 */
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    /* right num args */
    if( nrhs != 6){ 
        printf("%d params\n", nrhs );
        mexErrMsgTxt("Expected 6 arguments: dispmap( DepthMap,"
                " LeftCam, LeftPose, RightCam, RightPose, DispMap )\n" );
    }

    // depth map
    double *DepthMap = mxGetPr( prhs[0] );
    int DepthMapWidth = mxGetN( prhs[0] );
    int DepthMapHeight = mxGetM( prhs[0] );

    // Left cam 
    mvl_camera_t *LeftCam = get_camera_model( prhs[1] );
    if( LeftCam == NULL ){
        mexErrMsgTxt("Failed to get the left camera model!\n" );
    }

    // Left cam pose
    double LeftPose[16];
    transposem_nd( mxGetPr( prhs[2] ), 4, 4, 4, 4, LeftPose );

    // Right cam
    mvl_camera_t *RightCam = get_camera_model( prhs[3] );
    if( RightCam == NULL ){
        mexErrMsgTxt("Failed to get the right camera model!\n" );
    }

    // Right cam pose
    double RightPose[16];
    transposem_nd( mxGetPr( prhs[4] ), 4, 4, 4, 4, RightPose );

    // uint16 disparity map
    unsigned short *DispMap = (unsigned short*)mxGetPr( prhs[5] );
    int DispMapWidth = mxGetN(prhs[5]);
    int DispMapHeight = mxGetM(prhs[5]);

    if( DepthMapWidth != DispMapWidth || DepthMapHeight != DispMapHeight ){
        mexErrMsgTxt("DepthMap and DispMap must be the same size\n" );
    }

    ///////////////////////////////////
    // comopute disparity map from range map
    double p3[3];
    double Kl[9];
    double Kr[9];
    double invKl[9];
    mvl_camera_model_to_projmat( LeftCam, Kl );
    mvl_camera_model_to_projmat( RightCam, Kr );

    assert(0); // fixme
//    inv_3d( Kl, 3, invKl );

    p3[0] = (RightPose[3] - LeftPose[3]);
    p3[1] = (RightPose[7] - LeftPose[7]);
    p3[2] = (RightPose[11] - LeftPose[11]);
    double baseline = normv_3d( p3 );

    double dxn, nxn, depth, disp;
    int x, y; 
    for( y = 0; y < DepthMapHeight; y++ ){
        for( x = 0; x < DepthMapWidth; x++ ){
            if( DepthMap[ x*DepthMapHeight + y ] < 1000 ){

                // inverse projection
                depth = DepthMap[ x*DepthMapHeight + y ];
                p3[0] = invKl[0]*x + invKl[1]*y + invKl[2];
                p3[1] =              invKl[4]*y + invKl[5];
                dxn = p3[0]*p3[0] + p3[1]*p3[1] + 1; // dot(xn,xn);
                nxn = sqrt( dxn ); // norm(xn)

                // normalize, multiply by depth; this gives a 3D point in the computer vision frame
                p3[0] = depth*p3[0]/nxn;
                p3[1] = depth*p3[1]/nxn;
                p3[2] = depth*1/nxn;

                // report results in robotics frame 
                double tmp[3];
                tmp[0] = p3[2];
                tmp[1] = p3[0];
                tmp[2] = p3[1];

                // project into right image
                /* K*R'(pt - twrc) */
                p3[0] -= baseline;

                // project into right image (x pixel value anyway)
                double rx = (Kr[0]*p3[0] + Kr[1]*p3[1] + Kr[2]*p3[2])/p3[2];
                disp = ((double)x) - (Kr[0]*p3[0] + Kr[1]*p3[1] + Kr[2]*p3[2])/p3[2];

                if( x-disp >= 0 ){ // in right image?
                    DispMap[ x*DepthMapHeight + y ] = disp*MVL_DISPARITY_SCALE;
/*
                    // check that re-triangulated result isn't too bad after truncation due to scaling 
                    unsigned short nDisp = DispMap[ x*DepthMapHeight + y ];
                    hpose_compound_point_op_d( LeftPose, tmp, tmp);

                    printm_nd( Kl, 3, 3, 3, 1, 1, " Kl = " );
                    printm_nd( Kr, 3, 3, 3, 1, 1, " Kr = " );
                    printm_nd( LeftPose, 4, 4, 4, 1, 1, " Twlc = " );
                    printm_nd( RightPose, 4, 4, 4, 1, 1, " Twrc = " );

                    printf("lpx = [%f %f]  rpx = [%f %f]  started with disp %f (%d) (scale %d), [%f, %f, %f]",
                            (double)x, (double)y, ((double)x)-disp, (double)y,
                            disp, nDisp, MVL_DISPARITY_SCALE, tmp[0], tmp[1], tmp[2] );
                    disp = ((float)nDisp)/((float)MVL_DISPARITY_SCALE);
                    disparity_to_xyz_at_pose_d( x, y, disp, LeftPose, baseline, LeftCam, RightCam, tmp );
                    printf("; via disp %f,  ended up with [%f, %f, %f]\n", disp, tmp[0], tmp[1], tmp[2] );
                    return;
*/
                    /*
                       double ry = (              Kr[4]*p3[1] + Kr[5]*p3[2])/p3[2];
                       printf("[%d %d] = %f --> [%f %f %f] --> [%f %f] -->%f\n", x, y, 
                       DepthMap[ x*DepthMapHeight + y ],
                       p3[0], p3[1], p3[2], rx, ry, x - rx );
                     */
                }
            }
        }
    }

    mxFree( LeftCam );
    mxFree( RightCam );

    return;
}

