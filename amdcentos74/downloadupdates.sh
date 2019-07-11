#!/bin/bash
#Use yum to update all packages on the build disc

PKGDIR="disc/Packages"
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
	if [ -d "${TMPDIR}" ]; then rm -rf "${TMPDIR}"; fi
	if [ -d "${TMPROOT}" ]; then rm -rf "${ROOTDIR}"; fi
	exit $1
}

# command line arguments
while getopts ":d" OPT; do
	case $OPT in
		d)
			DEBUG=$((DEBUG + 1))
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


# sanity test
if [ ! -w $PKGDIR ]; then techo "\e[31mERROR:\e[39m No write permissions to $PKGDIR, cannot continue."; quit 1; fi


# build package list
# list already available rpm files and extract the package name from them, append the list to send to yum.
#REGEX="^([a-zA-Z0-9\_\-\+]+?)(?=-(?:[0-9][a-z0-9\.-]+?)(?:\.el7[_[0-9\.]*)(?:\.centos)?(?:\.[0-9])?(?:\.noarch|\.x86_64)\.rpm$)"
#REGEX="^([a-zA-Z0-9\_\-\+\.]+)(-api)?(?=-(?:[0-9][a-z0-9\.-]+?)(?:\.el7[_[0-9\.]*)(?:\.centos)?(?:\.[0-9])?(?:\.noarch|\.x86_64)\.rpm$)"
REGEX="^([a-zA-Z0-9\_\-\+\.]+?(?:-[0-9\.]+-api|-1\.8\.0-openjdk[-a-z]*?)?)(?=-(?:[0-9][a-z0-9\.-]+?)(?:\.el7[_[0-9\.]*)(?:\.centos)?(?:\.[0-9])?(?:\.noarch|\.x86_64)\.rpm$)"
PKGLISTNL=$(cd "$PKGDIR/" && ls -1 | grep -Po "$REGEX")
PKGLIST=$(echo -e "${PKGLISTNL}" | tr '\n' ' ')
PKGCOUNT=$(echo -e "${PKGLISTNL}" | wc -l)
debugecho "PKGLIST: [[$PKGLIST]]" 3
debugecho "PKGCOUNT: [[$PKGCOUNT]]" 2


# Get yum to download all packages from the built package list
TMPDIR=$(mktemp -d)
TMPROOT=$(mktemp -d)
techo "\e[34mINFO:\e[39m Check for Updates for ${PKGCOUNT} packages and Downloading to: ${TMPDIR}"
techo "Will take a few minutes..."
#YUMOUT=$(sudo yum update --disableplugin=deltarpm --downloadonly --downloaddir=${TMPDIR} ${PKGLIST})
YUMOUT=$(yum clean all && yumdownloader --archlist=x86_64 -x "*i686" --destdir ${TMPDIR} ${PKGLIST})
RC=$?
debugecho "RC: [[$RC]] YUMOUT: [[$YUMOUT]]" 3
techo "\e[32mPASS:\e[39m Download Complete."
if [ $RC -ne 0 ]; then techo "\e[33mWARNING:\e[39m Error indicated in yum output:\n ${YUMOUT}"; quit $RC; fi


# Copy new rpms to the build disc folder
# iterate list of packages, find matching (old and new) versions and remove the old, replacing with new version.
PKGI=0
while read -r PKG; do
	PKGI=$((PKGI + 1))
	OLDFILE=""
	NEWFILE=""
	OLDFILE=$(ls $PKGDIR/$PKG-* 2>&1 | head -n 1)
	NEWFILE=$(ls $TMPDIR/$PKG-* 2>&1 | head -n 1)
	debugecho "PKGI: [[$PKGI]] PKG: [[$PKG]] - OLDFILE: [[$OLDFILE]] - NEWFILE: [[$NEWFILE]]" 3

	if [ ! -f "$OLDFILE" ]; then OLDFILE=""; fi
	if [ ! -f "$NEWFILE" ]; then NEWFILE=""; fi
	debugecho "PKGI: [[$PKGI]] PKG: [[$PKG]] - OLDFILE: [[$OLDFILE]] - NEWFILE: [[$NEWFILE]]" 3

	if [ "$OLDFILE" == "" ] && [ "$NEWFILE" == "" ]; then techo "PKG: [[$PKG]] shit's broke!"; quit 255; fi


	# check for updated package
	if [ "$NEWFILE" == "" ]; then
		# new package file doesn't exist
		debugecho "\e[34mINFO:\e[39m #$PKGI/$PKGCOUNT $(basename $OLDFILE) has no update!" 2
		continue;
	fi

	if [ "$OLDFILE" == "" ] && [ -r "$NEWFILE" ]; then
		# old file doesn't exist - new package
		debugecho "\e[34mINFO:\e[39m #$PKGI/$PKGCOUNT New package $(basename $NEWFILE)" 1
		cp $NEWFILE $PKGDIR
		if [ $? -ne 0 ]; then techo -e "\e[33mWARNING:\e[39m Couldn't copy new package $NEWFILE to $PKGDIR!"; quit 1; fi
		continue;
	fi

	# check for same version
	if [ "$(basename $OLDFILE)" == "$(basename $NEWFILE)" ]; then
		# package files match, skip, nothing to do
		debugecho "\e[34mINFO:\e[39m #$PKGI/$PKGCOUNT $(basename $OLDFILE) and $(basename $NEWFILE) are identical - no update!" 3
		continue;
	fi

	# copy update package and remove the old package.
	techo "\e[34mINFO:\e[39m #$PKGI/$PKGCOUNT Updating $(basename $OLDFILE) to $(basename $NEWFILE)"
	cp "$NEWFILE" "$PKGDIR" && rm -f "$OLDFILE"
	if [ $? -ne 0 ]; then techo "\e[33mWARNING:\e[39m #$PKGI/$PKGCOUNT Couldn't update package $NEWFILE to $PKGDIR and remove $OLDFILE"; quit 1; fi	

done < <(echo -e "$PKGLISTNL")


# after, use existing scripts to update repo info.
./testrepo.sh
RC=$?
if [ $RC -ne 0 ]; then
	techo "\e[33mWARNING:\e[39m Repository test failed, need manual intevention to fix dependencies."
	quit $RC
fi

./updaterepo.sh
RC=$?
if [ $RC -ne 0 ]; then
	techo "\e[33mWARNING:\e[39m Repository update failed, need manual intevention."
	quit $RC
fi

techo "\e[32mPASS:\e[39m Package update process complete."

# done
quit 0

