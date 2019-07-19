#!/bin/bash
# Script to help automate install of DCRUM AMD/NAM Probe software
# Chris Vidler - Dynatrace SME 2019
#
# Makes some assumptions, which may not be right for your environment.
# These assumptions can be overridden.
#
# Assumtions made (defaults).
# - License type: capacity
# - Version: latest available in the /tmp folder
#


OPT_VER="*"
OPT_LIC=0
DEF_DIR=/tmp

DEBUG=0


function debugecho {
	dbglevel=${2:-1}
	if [ $DEBUG -ge $dbglevel ]; then techo "***DEBUG[$dbglevel]: $1 \e[39m"; fi
}

function techo {
	echo -e "[`date -u "+%Y-%m-%d %H:%M:%S"`]: $1" 
}

function quit {
	#cleanup and exit passing exit code
	exit $1
}


# command line arguments
OPTS=1
while getopts ":dv:l:" OPT; do
	case $OPT in
		d)
			DEBUG=$((DEBUG + 1))
			;;
        v)
			case ${OPTARG} in
				17|18|19)
					OPT_VER=$OPTARG
					;;
				*)
					techo "\e[31m***FATAL:\e[0m Unsupported version: $OPTARG"
					OPTS=0 #show help
					;;
			esac
			;;
		l)
			case ${OPTARG,,} in
				dlm)
					OPT_LIC=1
					;;
				com*)
					OPT_LIC=1
					;;
				ese*)
					OPT_LIC=0
					;;
				cap*)
					OPT_LIC=0
					;;
				*)
					techo "\e[31m***FATAL:\e[0m Unknown license type: $OPTARG"
					OPTS=0 #show help
					;; 
			esac			
			;;
		\?)
			OPTS=0 #show help
			techo "\e[31m***FATAL:\e[0m Invalid argument -$OPTARG."
			;;
		:)
			OPTS=0 #show help
			techo "\e[31m***FATAL:\e[0m argument -$OPTARG requires parameter."
			;;
	esac
done

if [ $OPTS -eq 0 ]; then
	techo "\e[34m***INFO:\e[0m Help/Usage"
	echo "$0 [-d] [-v #] [-l #]"
	echo "  -d	enable debugging output"
	echo "  -v #	specify other version #, e.g. 17, 18, 19; default: latest available in $DEF_DIR"
	echo "  -l #	license type, dlm/eservices/component/capacity; default: capacity"
	echo "	license type is converted to the version specific type for the installer used"
	quit 1
fi

techo "\e[34m***INFO:\e[0m Dynatrace NAM Probe Installer Script"

# get all upgrade.bin files in the default directory
INSTALLER=$(ls -r1 ${DEF_DIR}/upgrade-amd-amdos7-x86_64-ndw-${OPT_VER}-* 2> /dev/null | head -n 1)
debugecho "INSTALLER: [[$INSTALLER]]" 1

if [ "${INSTALLER}" == "" ]; then techo "\e[31m***FATAL:\e[0m No installer found."; quit 1; fi


# get version from installer file
RXP_VER='-ndw-([0-9]{2})-([0-9]+)-([0-9]+)-'
[[ ${INSTALLER} =~ ${RXP_VER} ]]
INST_MAJ=${BASH_REMATCH[1]}
INST_MIN=${BASH_REMATCH[2]}
INST_SP=${BASH_REMATCH[3]}
debugecho "INST_MAJ [[$INST_MAJ]] INST_MIN [[$INST_MIN]] INST_SP [[$INST_SP]]" 1

# build version specific parameters
if [ $OPT_LIC -eq 1 ]; then LIC_TYPE="component"; else LIC_TYPE="capacity"; fi
CMD_OPTS="--automatic --install-deps-from-media"
case $INST_MAJ in
	17)				# 17
		if [ $OPT_LIC -eq 1 ]; then CMD_OPTS="${CMD_OPTS} --licenses-type eservices"; else CMD_OPTS="${CMD_OPTS} --licenses-type dlm"; fi
		;;
	1[89])			# 18 or 19
		if [ $OPT_LIC -eq 1 ]; then CMD_OPTS="${CMD_OPTS} --licenses-type component"; else CMD_OPTS="${CMD_OPTS} --licenses-type capacity"; fi
		;;
	*)
    	 # unsupported version bomb out
		quit 255
		;;
esac
debugecho "CMD_OPTS: [[${CMD_OPTS}]]" 1

techo "\e[34m***INFO:\e[0m Found installer for ${INST_MAJ}.${INST_MIN} SP${INST_SP} installing with ${LIC_TYPE} license mode."

CMD="${INSTALLER} ${CMD_OPTS}"
debugecho "CMD: [$CMD]" 1

# check executability
if [ ! -x $INSTALLER ]; then 
	chmod +x $INSTALLER
	RC=$?
	if [ $RC -ne 0 ]; then techo "\e[33m***WARNING:\e[0m $INSTALLER not executable and couldn't fix that." ; quit $RC ; fi
fi

# run installer
if [ $DEBUG -eq 0 ]; then 
	$CMD
	RC=$?
	if [ $RC -ne 0 ]; then techo "\e[33m***WARNING:\e[0m Non-zero exit code, check prior output for errors." ; quit $RC ; fi
fi

#finish up
techo "\e[32m***PASS:\e[0m Completed"
quit 0

