#!/bin/bash
# Program:
#   Use loop to calculate "1+2+3+...+100" 
# History:
# 2022/09/10    Louise  First Release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

s=0
i=0
while [ "${i}" != "100" ]
do
    i=$(($i+1))
    s=$(($s+$i))
done
echo "The result of '1+2+3+...+100' is ==> $s"

