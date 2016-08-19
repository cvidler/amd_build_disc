#! /bin/bash
# VMWare kernel adjustments for AMD probe
# Chris Vidler - Dynatrace DC RUM SME 2016

set -u

RESULT=`virt-what`
#echo -e "[$RESULT]"

if [ "$RESULT" == "" ]; then
    #echo -e "No virtualisation found, no changes made"
    exit 0
else
    #virtualisation found

    if [ "$RESULT" == "vmware" ]; then
        #disable VMXNET3 LRO
	rmmod vmxnet3 2> /dev/null
	insmod vmxnet3 disable_lro=1 2> /dev/null

	#adjust kernel params
	sysctl -w net.core.rmem_max=16000000 > /dev/null
	sysctl -w net.core.rmem_default=16000000 > /dev/null

	echo -e "Adjusted kernel for VMWare guest"
        exit 0
    fi

    echo -e "Unknown virtualisation in use!"
    exit 1

fi


