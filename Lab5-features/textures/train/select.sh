#! /bin/bash

img_dirs=$(ls -1)
for d in ${img_dirs[*]}
do
d_files=$(ls -1 $d | sort -r)
ten_files=$(echo $d_files | cut -d' ' -f1-10)
twenty_files=$(echo $d_files | cut -d' ' -f11-40)
cp $ten_files  ../test
cp  $twenty_files  ../train
done
