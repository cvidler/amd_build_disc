#!/bin/bash
# updates to repo data files to reflect added/removed packages

echo -e "\e[34mINFO:\e[39m Preparing to update repo data."

mv repodata/*-comps.xml repodata/comps.xml
createrepo -g repodata/comps.xml .
if [ $? -ne 0 ]; then
	echo -e "\e[33mWARNING:\e[39m Repo data update failed."
else
	echo -e "\e[32mPASS:\e[39m Repo data updated successfully."
fi


