#!/bin/bash

fps=30

rm images/LeftCam-0000.depth

FILES=`ls images/*.depth`

for FILE in $FILES; do
  NUM=$(echo "$FILE" | sed 's/images\/LeftCam-0*\(.*\)\.depth/\1/g')
  SEC=$(echo "scale=6; ($NUM - 1) * (1 / $fps)" | bc -l)
  SEC=$(echo "x=$SEC; if (x < 1) print 0; if (x < 10) print 0; x" | bc -l)
  mv $FILE pgm/Left-$SEC.depth
done

mv pgm/Left-000.depth pgm/Left-00.000000.depth
