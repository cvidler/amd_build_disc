#!/bin/bash
# updates to repo data files to reflect added/removed packages

DEBUG=0

function debugecho {
	dbglevel=${2:-1}
	if [ $DEBUG -ge $dbglevel ]; then techo "*** DEBUG[$dbglevel]: $1 \e[39m"; fi
}

function techo {
	echo -e "[`date -u "+%Y-%m-%d %H:%M:%S"`]: $1" 
}

function quit {
	#cleanup and exit passing exit code
	cd $OLDPATH
	exit $1
}


OLDPATH=$(pwd)
techo "\e[34mINFO:\e[39m Preparing to update repository database."

if [ ! -d disc ]; then techo "\e[31mERROR:\e[39m 'disc' subdirectory not found. wrong current path?"; quit 1; fi
cd disc

mv repodata/*-comps*.xml repodata/comps.xml
RC=$?
if [ $RC -ne 0 ]; then
	techo "\e[31mERROR:\e[39m Repository comp.xml update failed with exit code $RC."
	quit $RC
fi

techo "\e[34mINFO:\e[39m Updating the repository database, this may take a few minutes."
OUTPUT=$(createrepo -g repodata/comps.xml .)
RC=$?
if [ $RC -ne 0 ]; then
	techo "\e[31mERROR:\e[39m Repository database update failed with exit code $RC."
	techo "Command output:\n$OUTPUT"
	quit $RC
else
	techo "\e[32mPASS:\e[39m Repository database updated successfully."
fi

quit 0

