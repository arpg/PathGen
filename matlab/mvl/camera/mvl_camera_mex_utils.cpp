#include <stdio.h>
#include <string.h>
#include <math.h>

#include <mvl/matrix/matrix.h>
#include <mvl/kinematics/kinematics.h>
#include <mvl/camera/camera.h>

#include "mvl_camera_mex_utils.h"

#include "mex.h"

extern int errno;

/****************************************************************************/

double *simple_copy( 
        const mxArray *mxin,
        char *name, 
        void *dst,
        int n
        )
{
    double *pr;
    mxArray *mx;
    char errtxt[64];

    mx = mxGetField( mxin, 0, name );
    if( !mx ){
        snprintf( errtxt, 64, "Couldn't find \"%s\" feild!\n", name );
        mexErrMsgTxt( errtxt );
    }
    pr = mxGetPr( mx );
    if( !pr ){
        snprintf( errtxt, 64, "Couldn't get pointer to \"%s\" feild!\n", name );
        mexErrMsgTxt( errtxt );
    }
 
    memcpy( dst, pr, n );
 
    //printf( "Got field %p,  %s = %f\n", dst, name, *(double*)dst );

    return pr;
}


/****************************************************************************/
mvl_camera_t* get_linear_camera_model( 
        const mxArray *mxcmod
        )
{
    mvl_camera_t *cmod = (mvl_camera_t*)mxCalloc(sizeof(mvl_camera_t), 1);

    if( !cmod ){
        mexErrMsgTxt( "Couldn't allocate a camera model!" ); 
    }
 
    simple_copy( mxcmod, "RDF",    cmod->RDF, 9*sizeof(double) );
    transposem_inplace_3d( cmod->RDF );

    double w;
    simple_copy( mxcmod, "width",  &w,         sizeof(double) );
    cmod->width = w;

    double h;
    simple_copy( mxcmod, "height", &h,        sizeof(double) );
    cmod->height = h;

    simple_copy( mxcmod, "fx",     &cmod->linear.fx,     sizeof(double) );
    simple_copy( mxcmod, "fy",     &cmod->linear.fy,     sizeof(double) );
    simple_copy( mxcmod, "cx",     &cmod->linear.cx,     sizeof(double) );
    simple_copy( mxcmod, "cy",     &cmod->linear.cy,     sizeof(double) );
    simple_copy( mxcmod, "sx",     &cmod->linear.sx,     sizeof(double) );
    
    return cmod;
}

/****************************************************************************/
mvl_camera_t* get_warped_camera_model(
        const mxArray *mxcmod
        )
{
    mvl_camera_t *cmod = (mvl_camera_t*)mxCalloc(sizeof(mvl_camera_t), 1);
    if( !cmod ){
        mexErrMsgTxt( "Couldn't allocate a camera model!" ); 
    }
    
    simple_copy( mxcmod, "RDF",    cmod->RDF, 9*sizeof(double) );
    transposem_inplace_3d( cmod->RDF );

    double w;
    simple_copy( mxcmod, "width",  &w,         sizeof(double) );
    cmod->width = w;

    double h;
    simple_copy( mxcmod, "height", &h,        sizeof(double) );
    cmod->height = h;

    simple_copy( mxcmod, "fx",     &cmod->warped.fx,     sizeof(double) );
    simple_copy( mxcmod, "fy",     &cmod->warped.fy,     sizeof(double) );
    simple_copy( mxcmod, "cx",     &cmod->warped.cx,     sizeof(double) );
    simple_copy( mxcmod, "cy",     &cmod->warped.cy,     sizeof(double) );
    simple_copy( mxcmod, "sx",     &cmod->warped.sx,     sizeof(double) );
    simple_copy( mxcmod, "tau1",   &cmod->warped.tau1,   sizeof(double) );
    simple_copy( mxcmod, "tau2",   &cmod->warped.tau2,   sizeof(double) );
    simple_copy( mxcmod, "kappa1", &cmod->warped.kappa1, sizeof(double) );
    simple_copy( mxcmod, "kappa2", &cmod->warped.kappa2, sizeof(double) );
    simple_copy( mxcmod, "kappa3", &cmod->warped.kappa3, sizeof(double) );

    return cmod;
}

/****************************************************************************/
mvl_camera_t* get_camera_model(
        const mxArray *cmod_array
        )
{
    mxArray *mx;
    mvl_camera_t *cmod = NULL;

    if (mxGetClassID( cmod_array) != mxSTRUCT_CLASS){ 
        mexErrMsgTxt("Expected a strucutre"); 
    }

    /* figure out type */
    char type_string[64];
    mx = mxGetField( cmod_array, 0, "type" );  
    if( mx == NULL ) {
        mexErrMsgTxt("couldn't find \"type\" feild!\n");
    }
    mxGetString( mx, type_string, 64 );

    if( strcasecmp( type_string, "MVL_CAMERA_LINEAR") == 0 ){  
        cmod = get_linear_camera_model( cmod_array );
        if( cmod ){
            cmod->type = MVL_CAMERA_LINEAR;
        }
    }
    else if( strcasecmp( type_string, "MVL_CAMERA_WARPED") == 0 ){ 
        cmod = get_warped_camera_model( cmod_array );    
        if( cmod ){
            cmod->type = MVL_CAMERA_WARPED;
        }
    }
 
    if( cmod ){
        /* figure out what camera model version this is */
        /*
        char ver_string[64];
        mx = mxGetField( cmod_array, 0, "version" );  
        if( !mx ){
            char buf[128];
            snprintf( buf, 128, "ERROR: Couldn't find \"version\" field\n" );
            mexErrMsgTxt(buf);
        }
        cmod->version = atoi( ver_string );
        if( cmod->version < CURRENT_CMOD_XML_FILE_VERSION ) 
        {
            char buf[128];
            snprintf( buf, 128, "ERROR: Expected \"version\" %d. You should update your model file.\n", 
                    CURRENT_CMOD_XML_FILE_VERSION );
            mexErrMsgTxt( buf );
        }
        */

        /* get camera id */
        mx = mxGetField( cmod_array, 0, "name" );
        if( mx==NULL ) {
            mexErrMsgTxt("couldn't find \"name\" feild!\n");
        }
        mxGetString( mx, cmod->name, MAX_NAME_LEN );
    }
    else{
        mexErrMsgTxt("couldn't allocate a camera model!\n");
    }

    return cmod;
}

