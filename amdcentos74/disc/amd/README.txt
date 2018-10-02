***
*** Dynatrace NAM Probe Build Disc Instructions
***


*** Networking configuration

  NetworkManager is now used to configure network connections on the NAM probe. 
Previously rtminst would allow you to configure the network settings, this is 
no longer the case. NetworkManager is configured with the nmtui command. It 
provides a text mode wizard interface.

nmtui



*** NAM Probe installation

  Supplied copies of the NAM Probe installation package can be found in /tmp, 
if you require a newer or different version of the installer upload it using 
Secure Copy Protocol (e.g. scp from another Linux platform, or WinSCP from 
Windows).  You'll need to configure networking first.

upgrade-amd-amdos7-x86_64-ndw-18-00-00-1192-b001.bin --manual \
  --licenses-type eservices --install-deps-from-media



*** NAM Probe configuration

  As usual rtminst provides a wizard based configuration tool.

rtminst

  Once complete, run ndstat to confirm the NAM Probe daemons are running.

ndstat



