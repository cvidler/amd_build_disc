#!/bin/bash
# Build ISO image from source 'disc' folder and add boot code for BIOS and UEFI.
# Chris Vidler - Dynatrace DCRUM SME

AMDVER="amd124"
RHELVER="rhel73"
DISCTYPE="mini"
VOLLABEL="RHEL-7.3 Server.x86_64"

OUTISO=`mktemp`
#echo "OUTISO: [$OUTISO]"

REV=""
if [ -r revision.txt ]; then 
    REV=`cat revision.txt` 
fi
if [ $REV == "" ]; then REV=1; fi
#echo "REV: [$REV]"

#implant version and disc label into postinstall
VER="${AMDVER}_${RHELVER}_${DISCTYPE}${REV}"
echo "[$VER]"
EFI="disc/amd/efiamdrhel7min.cfg"
BIOS="disc/amd/biosamdrhel7min.cfg"
EFI1=`mktemp`
BIOS1=`mktemp`
VERFIND="log \"AMD built with Dynatrace RHEL AMD Automated Installer.*"
VERREPLACE="log \"AMD built with Dynatrace RHEL AMD Automated Installer ${VER}\""
cat "$EFI" | sed "s/${VERFIND}/${VERREPLACE}/" > "$EFI1"
cat "$BIOS" | sed "s/${VERFIND}/${VERREPLACE}/" > "$BIOS1"
EFI2=`mktemp`
BIOS2=`mktemp`
LABELFIND="mount LABEL=\".*"
LABELREPLACE="mount LABEL=\"${VOLLABEL}\" \$SRC"
cat "$EFI1" | sed "s/${LABELFIND}/${LABELREPLACE}/" > "$EFI2"
cat "$BIOS1" | sed "s/${LABELFIND}/${LABELREPLACE}/" > "$BIOS2"

read

mv -f "$EFI2" "$EFI"
mv -f "$BIOS2" "$BIOS"
rm -f "$EFI1" "$EFI2" "$BIOS1" "$BIOS2"


# build EFI image
echo "1. Building new efiboot.img - sudo required, enter password when prompted"
rm efiboot-new.img > /dev/null
dd if=/dev/zero bs=1M count=10 of=efiboot-new.img
mkfs.fat -n "ANACONDA" efiboot-new.img
rm -rf newimage > /dev/null
mkdir newimage
sudo mount -o loop efiboot-new.img newimage
sudo mkdir newimage/EFI 
sudo cp -r disc/EFI/* newimage/EFI
sudo umount newimage
mv efiboot-new.img disc/images/efiboot.img
rm -rf newimage

echo "2. Building ISO image, ignore warnings"
# build base ISO image
cd disc
mkisofs -U -input-charset utf-8 -volset "$VOLLABEL" -V "$VOLLABEL" -J -joliet-long -r \
		-quiet -T -x ./lost+found -m TRANS.TBL -o $OUTISO \
	    -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
	    -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot .
ERROR=$?
cd ..

if [ ! $ERROR -eq 0 ]; then
	rm -f $OUTISO
	echo "mkisofs failed!"
	exit 1
fi

# make is USB bootable
echo "3. Adding USB boot support"
isohybrid --uefi $OUTISO
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	rm -f $OUTISO
	echo "isohybrid failed!"
	exit 1
fi

# implant internal checksum
echo "4. Implanting MD5 checksums"
implantisomd5 --supported-iso  $OUTISO
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	rm -f $OUTISO
	echo "implantisomd5 failed!"
	exit 1
fi


echo "5. Creating ISO checksum"
HASH=`md5sum $OUTISO`
HASH=${HASH:0:32}
#echo "HASH: [$HASH]"

NEWISO="/tmp/${AMDVER}_${RHELVER}_${DISCTYPE}${REV}_${HASH}.iso"
mv $OUTISO $NEWISO
ERROR=$?
if [ ! $ERROR -eq 0 ]; then
	echo "Could not rename ISO, ISO exists as: $OUTISO"
	exit 1
fi

# git commit changes
echo "6. Updating GIT"
git commit --all --message "buildimage.sh run built image $NEWISO"


REV=$((REV + 1))
echo -E $REV > revision.txt
echo
echo "7. Created: $NEWISO"

