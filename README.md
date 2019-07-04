# AMD Build Disc


## Current Release Downloads
https://github.com/cvidler/amd_build_disc/releases

 
## Release Notes
A customised boot menu will ask you to install an AMD or an Endace AMD (no more remembering to enter the kick-start script command line, and swapping discs).  From the 12.4/RHEL7+ build images theres no more Endace option (Endace now supply their own build) And be automatic from there. Noting it’ll destroy anything and everything on disk on whatever server you boot it on, this is why the default boot menu is a harmless ‘boot local disk’ option. So no accidental destroying servers by leaving the disk in.
 
- Automated installation.
- First boot script:
- Once rebooted, at first logon there’s an amdinstall.sh script in the /root/ folder, run it to finish the job – will automatically install dependencies and start off the AMD installer.
 
## Production Install / Installation Number / Red Hat Subscription?

If the customer has valid Red Hat subscription, you can turn this buld into a valid supported RHEL build with the subscription manager command.



The Subscription/Installation number is a concept that no longer applies to RHEL6 (it stopped in RHEL5). It’s now managed through the Red Hat customer portal, and the subscription manager command.



In 6 and newer, the subscription-manger command is used.
https://access.redhat.com/solutions/253273



Note: This build was intended for POC (temporary) installations only, use for production customer installs should only be done if it is sure the customer has Red Hat licensing. Failing to do so is a breach of Red Hat licensing and Dynatrace/I do not want to be held responsible for licensing breaches.

 
 
### Successful Platforms
- Cisco UCS C240 M3S
- Dell 2950
- Dell R720
- Dell R730
- HPE DL360 Gen9
- HP DL380p Gen8
- HP DL380 Gen9
- VMWare ESXi 5.1
- VMWare Workstation 9



#### Platforms of Note
**VMWare**

Note, to install create your VM with the following options:
-	Guest Operating System, choose Red Hat Enterprise Linux 6 64-bit or 7 64-bit if available (VMWare Workstation 9 doesn’t have 7 as an option, 6 works fine.).
-	Disk Space: at least 30GB, thin provisioned is fine, but the installer needs to see sufficient space to install.
-	E1000 virtual NICs (at least two, one for communicaitons, one for capture)

Then when running rtminst to configure monitoring ports, be sure to change the driver type to Native, Customised won’t work with the virtual NICs.	



**HP Gen9 Servers**

These servers run an UEFI style BIOS by default, the build will not work unless the BIOS style is changed back to the ‘Legacy BIOS’ style. This can be done through the BIOS/Platform configuration. This is fixed with the RHEL7.3 builds, see below.


**UEFI Support**

UEFI support is available for testing in the RHEL7.3 disc build.
	 
 
### Unsuccessful Platforms
None currently known.
 
 

## Issues 
Please report successes and failures (especially on platforms officially supported by DCRUM) using the Issues track on GitHub. https://github.com/cvidler/amd_build_disc/issues



Thanks

Chris
