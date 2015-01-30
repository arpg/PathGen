#!/usr/bin/python

###############################################################################
## This program converts the "euclidean" depth provided by POV-ray
## into a z-coordinate depth (like Kinect) typically used in image
## alignment algorithms.


## Define focal length.
f = 134.2559

## Define image parameters.
width = 320
height = 240


###############################################################################
###############################################################################
###############################################################################

from array import array
import math
import numpy
import os

for file in os.listdir("."):
    if file.endswith(".depth"):
        depths = numpy.loadtxt(file)

        for jj in range(height):
            for ii in range(width):
                d = depths[width*jj + ii]
                u = ii - width/2
                v = jj - height/2
                l = d*d / (u*u + f*f + v*v)
                depths[width*jj + ii] = f * math.sqrt(l)

        # Export file to pdm.
        fileName, fileExtension = os.path.splitext(file)
        pdm_file = open(fileName + ".pdm", 'w')
        pdm_file.write('P7\n')
        pdm_file.write(str(width) + " " + str(height) + "\n")
        pdm_file.write('1234567890\n')
        pdm_file.close()
        pdm_file = open(fileName + ".pdm", 'ab')

        z_depths = array('f', depths)
        z_depths.tofile(pdm_file)

        print 'Generating ' + fileName
        pdm_file.close()
