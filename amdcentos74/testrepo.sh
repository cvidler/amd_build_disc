#!/bin/bash
# runs a RPM test on the packages searching for issues

DEBUG=0

function debugecho {
	dbglevel=${2:-1}
	if [ $DEBUG -ge $dbglevel ]; then techo "*** DEBUG[$dbglevel]: $1 \e[39m"; fi
}

function techo {
	echo -e "[`date -u "+%Y-%m-%d %H:%M:%S"`]: $1" 
}

function quit {
	#cleanup temp dirs and exit passing exit code
	if [ -d "${TEMPDIR}" ]; then rm -rf "${TEMPDIR}"; fi
	exit $1
}

techo "\e[34mINFO:\e[39m Preparing to test repository dependencies."

TEMPDIR=`mktemp -d`
echo -e "\e[17mRPM Output"
rpm --initdb --dbpath $TEMPDIR 
rpm --test --nosignature --dbpath $TEMPDIR -Uvh disc/Packages/*.rpm
ERROR=$?
echo -e "\e[39m"
if [ $ERROR -ne 0 ]; then
	techo "\e[33mWARNING:\e[39m Errors found, review above output."
	quit 1
else
	techo "\e[32mPASS:\e[39m Repository dependency test OK."
fi

quit 0

