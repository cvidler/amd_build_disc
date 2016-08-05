#!/bin/bash
# AMD Installer
# Chris Vidler - Dynatrace Expert Services
#
# Follows from RHEL KickStart install, installs extra dependencies (rpms), and starts AMD installer.

# Install RPMs copied from install disc
rpm --replacepkgs --nodeps --nosignature -Ui /tmp/*.rpm

# Install AMD
cd /tmp
# Execute latest (sort by version number) AMD installation
./`ls upgrade-amd-amdos6-x86_64-ndw-* | tail -n 1`

