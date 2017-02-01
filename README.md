# AMD Build Disc


## Current Release Downloads

### RHEL 7 x86_64 DC RUM 12.4.x

**AMD 12.4 Build Disc – Build mini6**

- RHEL 7.2 (stripped to bare minimum for AMD)
- AMD 12.4.2 (build 24)
- Extra dependencies added since 12.4 GA.
- New Logos
- Supports 12.4.0-12 classic or high speed AMD.



**Download:** https://www.dropbox.com/s/nlqlz6inp6gxw1k/amd124_rhel72_autoinstaller_mini6_8d696d35dc6a3344fd91ae50bfa6a92d.iso?dl=0 

**Size:** approx. 870MB

**MD5SUM:** 8d696d35dc6a3344fd91ae50bfa6a92d



### RHEL 6 x86_64 DC RUM 12.3.x and 12.4.x

**AMD 12.3 Build Disc – Build mini8**

- RHEL 6.6 (stripped to bare minimum for AMD)
- AMD 12.3. GA


**Downoad:** https://www.dropbox.com/s/osnkahgqt2kxjof/amd123_rhel66_autoinstaller_mini8_b5014a4094cc407045dfc2a8cbdb2d96.iso?dl=0

**Size:** approx. 705MB

**MD5SUM:** b5014a4094cc407045dfc2a8cbdb2d96 (also on the end of the file name)



## Older Releases

**AMD 12.4 Build Disc – Build mini3**
- RHEL 7.2 (stripped to bare minimum for AMD)
- AMD 12.4 GA (build 1308)



https://www.dropbox.com/s/poqftfgaoqtb652/amd124_rhel72_autoinstaller_mini3_faf6bae4d7946944cdbc83fb1343c84c.iso?dl=0

Size: approx. 846MB

MD5SUM: faf6bae4d7946944cdbc83fb1343c84c



**AMD Build Disc - Build mini7**

- RHEL 6.6 (stripped to bare minimum for AMD)
- AMD 12.3 GA


 
https://www.dropbox.com/l/TCI1vydnjz9jAx2UkbQ5mu

Size:           approx. 752MB

MD5SUM:  d0ba413c0dcfbb14c815cd0f9a002303 (also on the end of the file name)


 
## Release Notes
A customised boot menu will ask you to install an AMD or an Endace AMD (no more remembering to enter the kick-start script command line, and swapping discs).  From the 12.4/RHEL7.2 build images theres no more Endace option (Endace now supply their own build) And be automatic from there. Noting it’ll destroy anything and everything on disk on whatever server you boot it on, this is why the default boot menu is a harmless ‘boot local disk’ option. So no accidental destroying servers by leaving the disk in.
 
- Automated installation.
- First boot script:
- Once rebooted, at first logon there’s an amdinstall.sh script in the /root/ folder, run it to finish the job – will automatically install dependencies and start off the AMD installer.
 
## Production Install / Installation Number / Red Hat Subscription?

If the customer has valid Red Hat subscription, you can turn this buld into a valid supported RHEL build with the subscription manager command.



The Subscription/Installation number is a concept that no longer applies to RHEL6 (it stopped in RHEL5). It’s now managed through the Red Hat customer portal, and the subscription manager command.



In 6 and newer, the subscription-manger command is used.
https://access.redhat.com/solutions/253273



Note: This build was intended for POC (temporary) installations only, use for production customer installs should only be done if it is sure the customer has Red Hat licensing. Failing to do so is a breach of Red Hat licensing and Dynatrace/I do not want to be held responsible for licensing breaches.

 

## Version History
- RHEL7.2 AMD12.4 Mini 6
- Update to 12.4 SP2 (build 24).
- Added dependencies since 12.4 GA.
- Update boot screen with new Dynatrace logos.



RHEL7.2 AMD12.4 Mini 4-5
- Unreleased. New 12.4.2 dependency resolution.



RHEL7.2 AMD12.4 Mini 3
- Initial release.



RHEL7.2 AMD12.4 Mini 1-2
- Beta builds, unreleased.
- RHEL 7.2 to support new 12.4 features, and newest server platforms.
- 12.4 GA included.
- Includes fixes from previous RHEL6 builds.
- Endace support removed, Endace are providing their own builds now.



RHEL7.1 AMD 12.4 Mini1-11
- Beta builds, only supported on 12.4 Beta. GA increased minimum RHEL version to 7.2.



RHEL6.6 AMD12.3 Mini 8
- Release fixes, large HDD boot issue. Otherwise unchanged from mini7, which you can keep using if you’re installing on servers with bootable HDD spac e <2TB.



RHEL6.6 AMD12.3 Mini7
- This release fixes an issue where if multiple CD drives are detected/present (e.g. a real one, and a virtual one provided by a DRAC/ILO) may prevent proper completion. Thanks to Kevin Leng for identifying and helping me squash this bug.


 
RHEL6.6 AMD12.3 Mini6
- First release.


 
RHEL6.6 AMD12.3 Mini1-5
- Beta builds.
 

 
### Successful Platforms
- Cisco UCS C240 M3S
- Dell 2950
- Dell R720
- Dell R730
- HP DL380p Gen8
- HP DL380 Gen9
- VMWare ESXi 5.1
- VMWare Workstation 9



#### Platforms of Note
**VMWare**

Note, to install create your VM with the following options:
-	Guest Operating System, choose Red Hat Enterprise Linux 6 64-bit or 7 64-bit if available (VMWare Workstation 9 doesn’t have 7 as an option, 6 works fine.).
-	Disk Space: at least 20GB, thin provisioned is fine, but the installer needs to see sufficient space to install.
-	E1000 virtual NICs (at least two, one for communicaitons, one for capture)

Then when running rtminst to configure monitoring ports, be sure to change the driver type to Native, Customised won’t work with the virtual NICs.	



**HP Gen9 Servers**

These servers run an UEFI style BIOS by default, the build will not work unless the BIOS style is changed back to the ‘Legacy BIOS’ style. This can be done through the BIOS/Platform configuration.

	 
 
### Unsuccessful Platforms
None currently known.
 
 

## Issues 
Please report successes and failures (especially on platforms officially supported by DCRUM) using the Issues track on GitHub. https://github.com/cvidler/amd_build_disc/issues



Thanks

Chris
