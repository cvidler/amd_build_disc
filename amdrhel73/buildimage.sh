#!/bin/bash

cd disc
mkisofs -U -A "MyLinux_1 x86_64 Disc 1" -V "RHEL-7.3 Server.x86_64" \
	    -volset "MyLinux_1 x86_64 Disc 1" -J -joliet-long -r -v -T -x ./lost+found -m TRANS.TBL \
	    -o ~/amd124_rhel73_mini.iso \
	    -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
	    -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot .
cd ..

