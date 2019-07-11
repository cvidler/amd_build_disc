#!/bin/bash
# Build ISO image from source 'disc' folder and add boot code for BIOS and UEFI.
# Chris Vidler - Dynatrace DCRUM SME

AMDVER="probe18"
RHELVER="centos76"
DISCTYPE="mini"
VOLLABEL="CentOS 7 x86_64"
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
	if [ -f "${OUTISO}" ]; then rm -rf "${OUTISO}"; fi
	if [ -f "${EFI1}" ]; then rm -rf "${EFI1}"; fi
	if [ -f "${BIOS1}" ]; then rm -rf "${BIOS1}"; fi
	exit $1
}

OUTISO=`mktemp`
debugecho "OUTISO: [$OUTISO]"

REV=""
if [ -r revision.txt ]; then 
    REV=`cat revision.txt` 
fi
if [ "$REV" == "" ]; then REV=1; fi
debugecho "REV: [$REV]"

#implant version and disc label into postinstall
VER="${AMDVER}_${RHELVER}_${DISCTYPE}${REV}"
debugecho "[$VER]"
EFI="disc/amd/efiamdrhel7min.cfg"
BIOS="disc/amd/biosamdrhel7min.cfg"
EFI1=`mktemp`
BIOS1=`mktemp`
VERFIND="echo \"AMD built with Dynatrace CentOS AMD Automated Installer.*"
VERREPLACE="echo \"AMD built with Dynatrace CentOS AMD Automated Installer ${VER}\""
cat "$EFI" | sed "s/${VERFIND}/${VERREPLACE}/" > "$EFI1"
cat "$BIOS" | sed "s/${VERFIND}/${VERREPLACE}/" > "$BIOS1"

mv -f "$EFI1" "$EFI"
mv -f "$BIOS1" "$BIOS"
rm -f "$EFI1" "$BIOS1"


# build EFI image
techo "\e[34mINFO:\e[39m 1. Building new efiboot.img - sudo required, enter password when prompted"

if [ -e efiboot-new.img ]; then rm efiboot-new.img ; fi
OUTPUT=$(dd if=/dev/zero bs=1M count=10 of=efiboot-new.img)
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m dd failed!"
	techo $OUTPUT
	quit $ERROR
fi

OUTPUT=$(mkfs.fat -n "ANACONDA" efiboot-new.img)
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m mkfs.fat failed!"
	techo $OUTPUT
	quit $ERROR
fi

if [ -e newimage ]; then rm -rf newimage ; fi
mkdir newimage
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m mkisofs failed!"
	quit $ERROR
fi


sudo mount -o loop efiboot-new.img newimage
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m mount efiboot failed!"
	quit $ERROR
fi

sudo mkdir newimage/EFI 
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m mkdir failed!"
	quit $ERROR
fi

sudo cp -r disc/EFI/* newimage/EFI
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m cp failed!"
	quit $ERROR
fi

sudo umount newimage
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m umount failed!"
	quit $ERROR
fi

mv efiboot-new.img disc/images/efiboot.img
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m mv failed!"
	quit $ERROR
fi

rm -rf newimage
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m rm failed!"
	quit $ERROR
fi


techo "\e[34mINFO:\e[39m 2. Building ISO image, ignore warnings"
# build base ISO image
cd disc
OUTPUT=$(mkisofs -U -input-charset utf-8 -volset "$VOLLABEL" -V "$VOLLABEL" -J -joliet-long -r \
		-quiet -T -x ./lost+found -m TRANS.TBL -o $OUTISO \
	    -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
	    -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot .)
ERROR=$?
cd ..

if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m mkisofs failed!"
	techo "$OUTPUT"
	quit $ERROR
fi


# make it USB bootable
techo "\e[34mINFO:\e[39m 3. Adding USB boot support"
OUTPUT=$(isohybrid --uefi $OUTISO)
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m isohybrid failed!"
	techo "$OUTPUT"
	quit $ERROR
fi

# implant internal checksum
techo "\e[34mINFO:\e[39m 4. Implanting MD5 checksums"
OUTPUT=$(implantisomd5 --supported-iso  $OUTISO)
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m implantisomd5 failed!"
	techo "$OUTPUT"
	quit $ERROR
fi


techo "\e[34mINFO:\e[39m 5. Creating ISO checksum"
HASH=`md5sum $OUTISO`
HASH=${HASH:0:32}
debugecho "HASH: [$HASH]"

NEWISO="/tmp/${AMDVER}_${RHELVER}_${DISCTYPE}${REV}_${HASH}.iso"
mv $OUTISO $NEWISO
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[31m***FATAL:\e[0m Could not move/rename ISO"
	quit $ERROR
fi

# git commit changes
techo "\e[34mINFO:\e[39m 6. Updating GIT"
git commit --all --message "buildimage.sh run built image $NEWISO"
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	techo "\e[33m***WARNING:\e[0m Could not update git"
fi


REV=$((REV + 1))
echo -E $REV > revision.txt

techo "\e[32mPASS:\e[39m 7. Created: $NEWISO"

quit 0

