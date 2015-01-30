#!/bin/bash

fps=60

rm -rf pgm
mkdir pgm
convert images/*.png pgm/Camera-%04d.pgm
rm pgm/Camera-0000.pgm

FILES=`ls pgm`

for FILE in $FILES; do
  NUM=$(echo "$FILE" | sed 's/Camera-0*\(.*\)\.pgm/\1/g')
  SEC=$(echo "scale=6; ($NUM - 1) * (1 / $fps)" | bc -l)
  SEC=$(echo "x=$SEC; if (x < 1) print 0; if (x < 10) print 0; x" | bc -l)
  mv pgm/$FILE pgm/Camera-$SEC.pgm
done

mv pgm/Camera-000.pgm pgm/Camera-00.000000.pgm
