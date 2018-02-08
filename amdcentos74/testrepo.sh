#!/bin/bash
# runs a RPM test on the packages searchign for issues

echo -e "\e[34mINFO:\e[39m Preparing to test repo dependencies."

TEMPDIR=`mktemp -d`
echo -e "\e[17m"
rpm --initdb --dbpath $TEMPDIR 
rpm --test --nosignature --dbpath $TEMPDIR -Uvh disc/Packages/*.rpm
ERROR=$?
#echo $?
rm -rf $TEMPDIR
echo -e "\e[39m"
if [ $ERROR -ne 0 ]; then
	echo -e "\e[33mWARNING:\e[39m Errors found."
	exit 1
else
	echo -e "\e[32mPASS:\e[39m Everything OK."
fi
exit 0

