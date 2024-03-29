#!/bin/bash
# Program
#	Users input a scale number to calculate pi number.
# History:
# 2022/09/01	Louise First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
echo -e "This program will calculate pi value. \n"
echo -e "You should input a float number to calculate pi value.\n"
read -p "The scale number (10~10000) ?" number
num=${number:-"10"}
echo -e "Starting to calculate pi value. Be patient."
time echo "scale=${num}; 4*a(1)" | bc -lq
