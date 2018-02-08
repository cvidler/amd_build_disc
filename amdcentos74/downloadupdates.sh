#!/bin/bash
#Use yum to update all packages on the build disc

PKGDIR="disc/Packages"


# sanity test
if [ ! -w $PKGDIR ]; then "No write permissions to $PKGDIR, cannot continue."; exit 1; fi


# build package list
# list already available rpm files and extract the package name from them, append the list to send to yum.
#REGEX="^([a-zA-Z0-9\_\-\+]+?)(?=-(?:[0-9][a-z0-9\.-]+?)(?:\.el7[_[0-9\.]*)(?:\.centos)?(?:\.[0-9])?(?:\.noarch|\.x86_64)\.rpm$)"
#REGEX="^([a-zA-Z0-9\_\-\+\.]+)(-api)?(?=-(?:[0-9][a-z0-9\.-]+?)(?:\.el7[_[0-9\.]*)(?:\.centos)?(?:\.[0-9])?(?:\.noarch|\.x86_64)\.rpm$)"
REGEX="^([a-zA-Z0-9\_\-\+\.]+?(?:-[0-9\.]+-api|-1\.8\.0-openjdk[-a-z]*?)?)(?=-(?:[0-9][a-z0-9\.-]+?)(?:\.el7[_[0-9\.]*)(?:\.centos)?(?:\.[0-9])?(?:\.noarch|\.x86_64)\.rpm$)"
PKGLISTNL=$(cd "$PKGDIR/" && ls -1 | grep -Po "$REGEX")
PKGLIST=$(echo -e "${PKGLISTNL}" | tr '\n' ' ')
#echo -e "$PKGLIST"


# Get yum to download all packages from the built package list
TMPDIR=$(mktemp -d)
TMPROOT=$(mktemp -d)
echo -e "\e[34mINFO:\e[39m Downloading packages to: ${TMPDIR}\nWill take a few minutes..."
#YUMOUT=$(sudo yum update --disableplugin=deltarpm --downloadonly --downloaddir=${TMPDIR} ${PKGLIST})
YUMOUT=$(yum clean all && yumdownloader --archlist=x86_64 -x "*i686" --destdir ${TMPDIR} ${PKGLIST})
RC=$?
echo -e "\e[32mPASS:\e[39m Download Complete."
if [ $RC -ne 0 ]; then echo -e "\e[33mWARNING:\e[39m Error indicated in yum output:\n ${YUMOUT}"; fi


# Copy new rpms to the build disc folder
# iterate list of packages, find matching (old and new) versions and remove the old, replacing with new version.
while read -r PKG; do
	OLDFILE=""
	NEWFILE=""
	OLDFILE=$(ls $PKGDIR/$PKG-* 2>&1 | head -n 1)
	NEWFILE=$(ls $TMPDIR/$PKG-* 2>&1 | head -n 1)
	#echo -e "PKG:[$PKG] - OLDFILE:[$OLDFILE] - NEWFILE:[$NEWFILE]"

	if [ ! -f "$OLDFILE" ]; then OLDFILE=""; fi
	if [ ! -f "$NEWFILE" ]; then NEWFILE=""; fi
	#echo -e "PKG:[$PKG] - OLDFILE:[$OLDFILE] - NEWFILE:[$NEWFILE]"

	if [ "$OLDFILE" == "" ] && [ "$NEWFILE" == "" ]; then echo "shit's broke!"; exit 255; fi


	# check for updated package
	if [ "$NEWFILE" == "" ]; then
		# new package file doesn't exist
		echo -e "\e[34mINFO:\e[39m $(basename $OLDFILE) has no update!"
		continue;
	fi

	if [ "$OLDFILE" == "" ] && [ -r "$NEWFILE" ]; then
		# old file doesn't exist - new package
		echo -e "\e[34mINFO:\e[39m New package $(basename $NEWFILE)"
		cp $NEWFILE $PKGDIR
		if [ $? -ne 0 ]; then echo -e "\e[33mWARNING:\e[39m Couldn't copy new package $NEWFILE to $PKGDIR!"; exit 1; fi
		continue;
	fi

	# check for same version
	if [ "$(basename $OLDFILE)" == "$(basename $NEWFILE)" ]; then
		# package files match, skip, nothing to do
		continue;
	fi

	# copy update package and remove the old package.
	echo -e "\e[34mINFO:\e[39m Updating $(basename $OLDFILE) to $(basename $NEWFILE)"
	cp "$NEWFILE" "$PKGDIR" && rm -f "$OLDFILE"
	if [ $? -ne 0 ]; then echo -e "\e[33mWARNING:\e[39m Couldn't update package $NEWFILE to $PKGDIR and remove $OLDFILE"; exit 1; fi	

done < <(echo -e "$PKGLISTNL")

# cleanup
rm -rf ${TMPDIR} ${TMPROOT}



# after, use existing scripts to update repo info.
./testrepo.sh
RC=$?
if [ $RC -ne 0 ]; then
	echo -e "\e[33mWARNING:\e[39m Repository test failed, need manual intevention to fix dependencies."
	exit 1
fi

./updaterepo.sh
RC=$?
if [ $RC -ne 0 ]; then
	echo -e "\e[33mWARNING:\e[39m Repository update failed, need manual intevention."
	exit 1
fi

echo -e "\e[32mPASS:\e[39m Package update process complete."

# done
