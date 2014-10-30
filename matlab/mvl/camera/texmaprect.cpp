#include <stdio.h>
#include <string.h>
#include <math.h>

#include <mvl/image/image.h>
#include <mvl/matrix/matrix.h>
#include <mvl/kinematics/kinematics.h>
#include <mvl/camera/camera.h>

#include "mvl_camera_mex_utils.h"

#include "mex.h"

#ifndef max
#define max(a,b) ( a > b ? a : b )
#endif
#ifndef min
#define min(a,b) ( a < b ? a : b )
#endif

extern int errno;

/****************************************************************************/
/*
    matlab funciton: texmaprect( P, N, M, TEX, IMG, ZBUFFER, HPOSE, CMOD );
 */
void mexFunction( int, mxArray *[], int nrhs, const mxArray *prhs[] )
{
    int x, y;
    int u, v;
    double rectwidth;
    double rectheight;
    double Rt[9];
    double pt[3];
    double ray[3];
    double res[3];
    double px[2];

    double  *P; /* plane top left corner */
    double  *N; /* vector along top edge of plane */
    double  *M; /* vector down left side of plane */
    unsigned char *texdata; /* plane texture */
    int      texwidth;
    int      texheight;
    unsigned char *img;     /* output image */
    int      imgwidth;
    int      imgheight;
    double   campose[16];
    double   normal[3];
    double   Pts[4][3];/* corners of rectangle in 3d, clockwise order */
    //double   pts[4][2]; /* corners of rectangle in the image, clockwise order */
    double   forward[3];

    unsigned char backtex[] = { 
        100,100,100,100,55,55,55,55,100,100,100,100,55,55,55,55,
        100,100,100,100,55,55,55,55,100,100,100,100,55,55,55,55,
        100,100,100,100,55,55,55,55,100,100,100,100,55,55,55,55,
        100,100,100,100,55,55,55,55,100,100,100,100,55,55,55,55,
        55,55,55,55,100,100,100,100,55,55,55,55,100,100,100,100,
        55,55,55,55,100,100,100,100,55,55,55,55,100,100,100,100,
        55,55,55,55,100,100,100,100,55,55,55,55,100,100,100,100,
        55,55,55,55,100,100,100,100,55,55,55,55,100,100,100,100,
        100,100,100,100,55,55,55,55,100,100,100,100,55,55,55,55,
        100,100,100,100,55,55,55,55,100,100,100,100,55,55,55,55,
        100,100,100,100,55,55,55,55,100,100,100,100,55,55,55,55,
        100,100,100,100,55,55,55,55,100,100,100,100,55,55,55,55,
        55,55,55,55,100,100,100,100,55,55,55,55,100,100,100,100,
        55,55,55,55,100,100,100,100,55,55,55,55,100,100,100,100,
        55,55,55,55,100,100,100,100,55,55,55,55,100,100,100,100,
        55,55,55,55,100,100,100,100,55,55,55,55,100,100,100,100
    };
/*
    unsigned char backtex[] = { 
        128,128,128,128,  128,128,128,128,  128,128,128,128,  128,128,128,128, 
        128,128,  0,  0,    0,  0,  0,  0,    0,  0,  0,  0,    0,  0,128,128, 
        128,  0,128,  0,    0,  0,  0,  0,    0,  0,  0,  0,    0,128,  0,128, 
        128,  0,  0,128,    0,  0,  0,  0,    0,  0,  0,  0,  128,  0,  0,128, 

        128,  0,  0,  0,  128,  0,  0,  0,    0,  0,  0,128,    0,  0,  0,128, 
        128,  0,  0,  0,    0,128,  0,  0,    0,  0,128,  0,    0,  0,  0,128, 
        128,  0,  0,  0,    0,  1,128,  0,    0,128,  0,  0,    0,  0,  0,128, 
        128,  0,  0,  0,    0,  0,  0,128,  128,  0,  0,  0,    0,  0,  0,128, 

        128,  0,  0,  0,    0,  0,  0,128,  128,  0,  0,  0,    0,  0,  0,128, 
        128,  0,  0,  0,    0,  0,128,  0,    0,128,  0,  0,    0,  0,  0,128, 
        128,  0,  0,  0,    0,128,  0,  0,    0,  0,128,  0,    0,  0,  0,128, 
        128,  0,  0,  0,  128,  0,  0,  0,    0,  0,  0,128,    0,  0,  0,128, 

        128,  0,  0,128,    0,  0,  0,  0,    0,  0,  0,  0,  128,  0,  0,128, 
        128,  0,128,  0,    0,  0,  0,  0,    0,  0,  0,  0,    0,128,  0,128, 
        128,128,  0,  0,    0,  0,  0,  0,    0,  0,  0,  0,    0,  0,128,128, 
        128,128,128,128,  128,128,128,128,  128,128,128,128,  128,128,128,128, 
    };
    */
    int backtex_width = 16;
    int backtex_height = 16;

    /* right num args */
    if( nrhs != 8){ 
        printf("%d params\n", nrhs );
        mexErrMsgTxt("Expected 7 arguments: "
                "texmaprect( P, N, M, TEX, IMG, ZBUF, CAMPOSE, CMOD )\n" );
    }

    // P
    if( !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0])
      || mxGetM(prhs[0]) != 3 || mxGetN(prhs[0]) != 1 ) {
        mexErrMsgTxt("'P' must be a [3 x 1] vector.");
    }
    P = mxGetPr( prhs[0] );
    
    // N
    if( !mxIsDouble(prhs[1]) || mxIsComplex(prhs[1])
      || mxGetM(prhs[1]) != 3 || mxGetN(prhs[1]) != 1 ) {
        mexErrMsgTxt("'N' must be a [3 x 1] vector.");
    }
    N = mxGetPr( prhs[1] );

    // M
    if( !mxIsDouble(prhs[2]) || mxIsComplex(prhs[2])
      || mxGetM(prhs[2]) != 3 || mxGetN(prhs[2]) != 1 ) {
        mexErrMsgTxt("'M' must be a [3 x 1] vector.");
    }
    M = mxGetPr( prhs[2] );
 
    // tex 
    texdata = (unsigned char*)mxGetPr( prhs[3] );
    texwidth = mxGetN(prhs[3]);
    texheight = mxGetM(prhs[3]);

    // img 
    img = (unsigned char*)mxGetPr( prhs[4] );
    imgwidth = mxGetN(prhs[4]);
    imgheight = mxGetM(prhs[4]);

    // z buffer 
    double *zbuf = mxGetPr( prhs[5] );
    //int zbufwidth = mxGetN(prhs[5]);
    int zbufheight = mxGetM(prhs[5]);

    // cam pose	
    transposem_nd( mxGetPr( prhs[6] ), 4, 4, 4, 4, campose );

    // get camera model (allocates an mvl_camera_t)
    // DONT FORGET TO FREE
    mvl_camera_t *cmod = get_camera_model( prhs[7] );
    if( cmod == NULL ){
        mexErrMsgTxt("Failed ot get the camera model!\n" );
    }

    ///////////////////////////////////

    forward[0] = campose[0];
    forward[1] = campose[4];
    forward[2] = campose[8];

    rectwidth = normv_3d( N );
    rectheight = normv_3d( M );
    cross_3d( M, N, normal );
    normalizev_3d( normal, normal );



    double cam_center[3];
	cam_center[0] = campose[3];
	cam_center[1] = campose[7];
	cam_center[2] = campose[11];

    // ray from center to some corner of polygon
    subvv_3d( 1.0, P, cam_center, Pts[0] );
    if( dot_3d( normal, Pts[0] ) > 0 ){
//        printf("dot_3d( normal, Pts[0] ) > 1e-9 %f\n", dot_3d( normal, Pts[0] ) );
        texdata = backtex;
        texwidth = backtex_width;
        texheight = backtex_height;
    }

    if( dot_3d( N, M ) > 1e-9  ){
        printf("angle between vectors is %e\n", 180.0*dot_3d( N, M )/M_PI );
        mexErrMsgTxt("Expected perpendicular N and M vectors\n" );
    }

    // hack
    double maxx = imgwidth;
    double maxy = imgheight;
    double miny = 0;
    double minx = 0;
#if 0

    This code is broken, fix later.

    /* first, calc bounding box in the image */
    memcpy( Pts[0], P, sizeof(double)*3 );
    addvv_3d( 1.0, P, N, Pts[1] );     /* P+N */
    addvv_3d( 1.0, Pts[1], M, Pts[2] );/* P+N+M */
    addvv_3d( 1.0, P, M, Pts[3] );     /* P+M */
 
/*
    printf( "Pts[0] = [ %f; %f; %f]\n", Pts[0][0], Pts[0][1],  Pts[0][2] );
    printf( "Pts[1] = [ %f; %f; %f]\n", Pts[1][0], Pts[1][1],  Pts[1][2] );
    printf( "Pts[2] = [ %f; %f; %f]\n", Pts[2][0], Pts[2][1],  Pts[2][2] );
    printf( "Pts[3] = [ %f; %f; %f]\n", Pts[3][0], Pts[3][1],  Pts[3][2] );
*/
    mvl_camera_3d_to_2d( cmod, campose, Pts[0], pts[0], NULL );
    mvl_camera_3d_to_2d( cmod, campose, Pts[1], pts[1], NULL );
    mvl_camera_3d_to_2d( cmod, campose, Pts[2], pts[2], NULL );
    mvl_camera_3d_to_2d( cmod, campose, Pts[3], pts[3], NULL );

    /*
    double K[9];
    mvl_camera_model_to_projmat( cmod, K );
    printm_nd( K, 3, 3, 3, 1, 1.0, "K = " );
    printm_nd( Pts[0], 3, 1, 1, 1, 1.0, "p3 = " );
    printm_nd( campose, 4, 4, 4, 1, 1.0, "Hl = " );
    printm_nd( pts[0], 2, 1, 1, 1, 1.0, "pixel = " );
    printf( "pts[0] = %f %f\n", pts[0][0], pts[0][1] );
    printf( "pts[1] = %f %f\n", pts[1][0], pts[1][1] );
    printf( "pts[2] = %f %f\n", pts[2][0], pts[2][1] );
    printf( "pts[3] = %f %f\n", pts[3][0], pts[3][1] );
*/

    double maxx = max( max( pts[0][0], pts[1][0] ), max( pts[2][0], pts[3][0] ) );
    double minx = min( min( pts[0][0], pts[1][0] ), min( pts[2][0], pts[3][0] ) );
    double maxy = max( max( pts[0][1], pts[1][1] ), max( pts[2][1], pts[3][1] ) );
    double miny = min( min( pts[0][1], pts[1][1] ), min( pts[2][1], pts[3][1] ) );

    maxx = min( maxx+1, imgwidth );
    maxy = min( maxy+1, imgheight );
    minx = max( minx-1, 0 );
    miny = max( miny-1, 0 );
/*
    printf("%f %f %f %f --> ", maxx, minx, maxy, miny );
	printf( "maxx = %f,  minx = %f,  maxy = %f,  miny = %f\n", 
			maxx, minx, maxy, miny );
*/
   if( minx > imgwidth || miny > imgheight ){
//        printf("not rendering!\n");
        mxFree( cmod );
        return;
    }
 

/*
    printf(" pts = [ %f\t%f\t%f\t%f ; \n",  
            pts[0][0],  pts[1][0], pts[2][0], pts[3][0] );
    printf("         %f\t%f\t%f\t%f ];\n",  
            pts[0][1],  pts[1][1], pts[2][1], pts[3][1] );
    printf("imw %d, imh %d\n", imgwidth, imgheight );
    printf("%f %f %f %f\n", maxx, minx, maxy, miny );
*/
#endif


    /* transpose of rotation matrix of plane */
    normalizev_3d( N, Rt );
    normalizev_3d( M, &Rt[3] );
    cross_3d( Rt, &Rt[3], &Rt[6] );

    /* now project points inside */
    /* recall that matlab is col major */
    double n[3], depth;
    for( y = (int)miny; y < (int)maxy; y++ ){
        for( x = (int)minx; x < (int)maxx; x++ ){
            px[ 0 ] = (double)x;
            px[ 1 ] = (double)y;

            mvl_camera_2d_to_3d( cmod, campose, px, ray, NULL );

            pt[ 0 ] = cam_center[ 0 ] + ray[ 0 ];
            pt[ 1 ] = cam_center[ 1 ] + ray[ 1 ];
            pt[ 2 ] = cam_center[ 2 ] + ray[ 2 ];

            line_plane_interesect_d( cam_center, pt, P, normal, res );
/*
          printf(" P [%f %f %f]  normal [%f %f %f]  cam [%f %f %f], pt [%f %f %f] res [%f %f %f]\n", 
                    P[0], P[1], P[2], normal[0], normal[1], normal[2],
                    cam_center[0], cam_center[1], cam_center[2], pt[0], pt[1],
                    pt[2], res[0], res[1], res[2] );
*/

            /* in front of the camera and best in zbuffer? */
            depth = normv_3d( subvv_3d( 1.0, res, cam_center, n ) );

            normalizev_3d( n, n );
/*
            printf("n [%f %f %f] forward [%f %f %f]  ", n[0], n[1], n[2], 
                   forward[0], forward[1], forward[2] ); 
            printf("%d %d to [%f %f %f], dot is %f.  ", x, y, res[0], res[1],
                    res[2], 180.0*dot_3d( n, forward )/M_PI );
            printf("depth is %f (vs %f in zbuf)\n", depth, zbuf[y*zbufwidth+x]);
*/
            if( dot_3d( n, forward ) > 0 ){
                /* compute texture coordinates R'*(res - P) */
                subvv_3d( 1.0, res, P, res );
                multmv_3d( Rt, res, pt ); /* reuse pt */
                u = (int)(texwidth*( pt[0]/rectwidth));
                v = (int)(texheight*( pt[1]/rectheight));
                /* in the rectangle? */
                if( u >= 0 && u < texwidth && v >= 0 && v < texheight ){
//                    printf("IN %d %d is %d %d inside texture\n", x, y, u, v );
                    /* zbuffer check */ 
                    if( zbuf[ x*zbufheight + y ] > depth ){
                        /* update zbuffer */
                        zbuf[ x*zbufheight + y ] = depth;
                        /* update image */
                        img[ x*imgheight + y ] = texdata[ u*texheight + v ];
                        //printf("img(%d, %d) = tex(%d, %d) = %d\n", x, y, u, v,
                        //           texdata[(int)(floor(u)*texheight + floor(v))] );
                        //img[ x*imgheight + y ] = 128;
                    }
                    else{
    /*
                        printf("depth = %f > zbuf = %f\n",
                                depth, zbuf[x*zbufheight+y]);
                        img[ x*imgheight + y ] = 128;
                */
                    }
                }
                else{
                /*
                    img[ x*imgheight + y ] = 128;
                printf("OUT %d %d is %d %d outside texture\n", x, y, u, v );
                    printf( "u < 0 or u >= texwidth or v < 0 or v >="
                            " texheight\n");
                */
                }
            }
            /*
            else{
                printf("n = [%f %f %f],  3dPt = [%f %f %f],  forward = [%f %f %f],  dot_3d( n, forward ) > 0 == %f\n", 
                        n[0], n[1], n[2], 
                        res[0], res[1], res[2], 
                        forward[0], forward[1], forward[2],
                        180.0*dot_3d( n, forward)/M_PI );
            }
            */
        }
    }

    mxFree( cmod );

    return;
}

