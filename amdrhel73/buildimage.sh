#!/bin/bash
# Build ISO image from source 'disc' folder and add boot code for BIOS and UEFI.
# Chris Vidler - Dynatrace DCRUM SME

AMDVER=amd124
RHELVER=rhel73
DISCTYPE=mini
VOLLABEL="RHEL-7.3 Server.x86_64"

OUTISO=`mktemp`
#echo "OUTISO: [$OUTISO]"

REV=""
if [ -r revision.txt ]; then 
    REV=`cat revision.txt` 
fi
if [ $REV == "" ]; then REV=1; fi
#echo "REV: [$REV]"


cd disc
mkisofs -U -A "$VOLLABEL" -V "$VOLLABEL" -volset "$VOLLABEL" -J -joliet-long \
		-r -quiet -T -x ./lost+found -m TRANS.TBL -o $OUTISO \
	    -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
	    -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot .
ERROR=$?
cd ..

if [ ! $ERROR -eq 0 ]; then
	rm -f $OUTISO
	echo "mkisofs failed!"
	exit 1
fi

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
REV=$((REV + 1))
echo -E $REV > revision.txt
echo "Created: $NEWISO"

