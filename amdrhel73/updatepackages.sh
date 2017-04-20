#!/bin/bash
#
# Copies updated required packages from provided source directory to current directory


#required package list
FILELIST=acl,acpid,alsa-lib,apache-commons-collections,apache-commons-daemon,apache-commons-dbcp,apache-commons-logging,apache-commons-pool,apr,apr-util,atk,attr,audit-libs,authconfig,autogen-libopts,avahi-autoipd,avahi-libs,avalon-framework,avalon-logkit,basesystem,bash,bind-libs,bind-libs-lite,bind-license,binutils,biosdevname,blktrace,boost,boost-atomic,boost-chrono,boost-context,boost-date-time,boost-filesystem,boost-graph,boost-iostreams,boost-locale,boost-math,boost-program-options,boost-python,boost-random,boost-regex,boost-serialization,boost-signals,boost-system,boost-test,boost-thread,boost-timer,boost-wave,bridge-utils,bzip2,bzip2-libs,ca-certificates,cairo,chkconfig,coreutils,cpio,cpp,cracklib,cracklib-dicts,cronie,cronie-noanacron,crontabs,cryptsetup-libs,cups-libs,curl,cyrus-sasl-lib,dbus,dbus-glib,dbus-libs,dbus-python,desktop-file-utils,device-mapper,device-mapper-event,device-mapper-event-libs,device-mapper-libs,device-mapper-persistent-data,dhclient,dhcp-common,dhcp-libs,diffutils,dmidecode,dmraid,dmraid-events,dnsmasq,dracut,dracut-config-rescue,dracut-network,dyninst,e2fsprogs,e2fsprogs-libs,ebtables,ecj,efibootmgr,efivar-libs,elfutils,elfutils-libelf,elfutils-libs,emacs-filesystem,ethtool,expat,file,filesystem,findutils,finger,fipscheck,fipscheck-lib,flac-libs,fontconfig,fontpackages-filesystem,freetype,gawk,gcc,gdbm,gdk-pixbuf2,geronimo-jms,geronimo-jta,gettext,gettext-libs,giflib,glib2,glibc,glibc-common,glibc-devel,glibc-headers,glib-networking,gmp,gnupg2,gnutls,gobject-introspection,gpgme,gpm-libs,graphite2,grep,groff-base,grub2,grub2-efi,grub2-tools,grubby,gsettings-desktop-schemas,gsm,gtk2,gzip,hardlink,harfbuzz,hicolor-icon-theme,hostname,hwdata,info,initscripts,iproute,iprutils,iptables,iputils,irqbalance,jansson,jasper-libs,java-1.7.0-openjdk,java-1.7.0-openjdk-devel,java-1.8.0-openjdk,java-1.8.0-openjdk-headless,javamail,javapackages-tools,jbigkit-libs,json-c,kbd,kbd-legacy,kbd-misc,kernel,kernel-devel,kernel-headers,kernel-tools,kexec-tools,keyutils-libs,kmod,kmod-libs,kpartx,krb5-libs,lcms2,less,libacl,libaio,libassuan,libasyncns,libattr,libblkid,libcap,libcap-ng,libcom_err,libcroco,libcurl,libdaemon,libdb,libdb-utils,libdrm,libdwarf,libedit,libestr,libffi,libfontenc,libgcc,libgcrypt,libgomp,libgpg-error,libgudev1,libICE,libicu,libidn,libjpeg-turbo,libmnl,libmodman,libmpc,libndp,libnetfilter_conntrack,libnfnetlink,libnl,libnl3,libnl3-cli,libogg,libpcap,libpciaccess,libpipeline,libpng,libproxy,libpwquality,libreport-filesystem,libselinux,libselinux-python,libselinux-utils,libsemanage,libsepol,libSM,libsndfile,libsoup,libss,libssh2,libstdc++,libsysfs,libtasn1,libteam,libthai,libtiff,libunistring,libusbx,libuser,libutempter,libuuid,libverto,libvorbis,libX11,libX11-common,libXau,libxcb,libXcomposite,libXcursor,libXdamage,libXext,libXfixes,libXfont,libXft,libXi,libXinerama,libxml2,libxml2-python,libXrandr,libXrender,libxslt,libXxf86vm,linux-firmware,lm_sensors,lm_sensors-libs,log4j,logrotate,lsof,lua,lvm2,lvm2-libs,lzo,m2crypto,mailcap,mailx,make,man-db,man-pages,mariadb-libs,mc,mdadm,mesa-libEGL,mesa-libgbm,mesa-libGL,mesa-libglapi,microcode_ctl,mozjs17,mpfr,ncurses,ncurses-base,ncurses-libs,net-snmp,net-snmp-agent-libs,net-snmp-libs,net-snmp-perl,net-snmp-utils,nettle,net-tools,newt,newt-python,nspr,nss,nss-softokn,nss-softokn-freebl,nss-sysinit,nss-tools,nss-util,ntp,ntpdate,ntsysv,numactl,numactl-libs,opencryptoki,opencryptoki-libs,opencryptoki-swtok,openldap,openssh,openssh-clients,openssh-server,openssl098e,openssl,openssl-libs,os-prober,p11-kit,p11-kit-trust,pam,pango,passwd,patch,pciutils,pciutils-libs,pcre,perl,perl-Business-ISBN,perl-Business-ISBN-Data,perl-Carp,perl-Compress-Raw-Bzip2,perl-Compress-Raw-Zlib,perl-constant,perl-Data-Dumper,perl-Digest,perl-Digest-MD5,perl-Encode,perl-Encode-Locale,perl-Env,perl-Exporter,perl-File-Listing,perl-File-Path,perl-File-Temp,perl-Filter,perl-Getopt-Long,perl-HTML-Parser,perl-HTML-Tagset,perl-HTTP-Cookies,perl-HTTP-Daemon,perl-HTTP-Date,perl-HTTP-Message,perl-HTTP-Negotiate,perl-HTTP-Tiny,perl-IO-Compress,perl-IO-HTML,perl-IO-Socket-IP,perl-IO-Socket-SSL,perl-libs,perl-libwww-perl,perl-LWP-MediaTypes,perl-macros,perl-Net-HTTP,perl-Net-LibIDN,perl-Net-SSLeay,perl-parent,perl-PathTools,perl-Pod-Escapes,perl-podlators,perl-Pod-Perldoc,perl-Pod-Simple,perl-Pod-Usage,perl-Scalar-List-Utils,perl-Socket,perl-Storable,perl-Switch,perl-Text-ParseWords,perl-threads,perl-threads-shared,perl-TimeDate,perl-Time-HiRes,perl-Time-Local,perl-URI,perl-WWW-RobotRules,perl-XML-NamespaceSupport,perl-XML-Parser,perl-XML-SAX,perl-XML-SAX-Base,perl-XML-Simple,pinentry,pixman,pkgconfig,plymouth,plymouth-core-libs,plymouth-scripts,policycoreutils,polkit,polkit-pkla-compat,popt,postfix,ppp,prelink,procps-ng,psmisc,pth,pulseaudio-libs,pygobject2,pygobject3-base,pygpgme,pyliblzma,pyOpenSSL,python,python-backports,python-backports-ssl_match_hostname,python-chardet,python-configobj,python-dateutil,python-decorator,python-dmidecode,python-ethtool,python-gudev,python-hwdata,python-iniparse,python-javapackages,python-kitchen,python-libs,python-lxml,python-pycurl,python-pyudev,python-rhsm,python-setuptools,python-six,python-slip,python-slip-dbus,python-urlgrabber,pyxattr,qrencode-libs,rdma,readline,Red_Hat_Enterprise_Linux-Release_Notes-7-en-US,redhat-logos,redhat-release-server,redhat-support-lib-python,redhat-support-tool,rhn-check,rhn-client-tools,rhnlib,rhnsd,rhn-setup,rootfiles,rpm,rpm-build-libs,rpm-libs,rpm-python,rsync,rsyslog,sed,setup,sgpio,shadow-utils,shared-mime-info,slang,smartmontools,snappy,sos,sqlite,strace,stunnel,subscription-manager,sudo,systemd,systemd-libs,systemd-sysv,systemtap-runtime,sysvinit-tools,tar,tbb,tcpdump,tcp_wrappers,tcp_wrappers-libs,teamd,time,tmpwatch,tomcat-el,tomcat-jsp,tomcat-lib,tomcat-servlet,traceroute,trousers,ttmkfdir,tuned,tzdata,tzdata-java,unzip,usbutils,usermode,ustr,util-linux,vim-minimal,virt-what,wget,which,xalan-j2,xdg-utils,xerces-c,xerces-j2,xml-commons-apis,xml-commons-resolver,xorg-x11-fonts-Type1,xorg-x11-font-utils,xz,xz-libs,yum,yum-metadata-parser,yum-rhn-plugin,yum-utils,zlib,ant,antlr-tool,apache-commons-io,apache-commons-codec,bea-stax,bea-stax-api,dom4j,easymock2,hamcrest,hsqldb,isorelax,jaxen,jdom,junit

set -euo pipefail
IFS=$',\n\t'

exists() { [[ -f $1 ]]; }


SOURCE=${1:-}
if [ ! -d $SOURCE ]; then
	echo -e "FATAL: Source dir: $SOURCE not found or inaccessible."
	exit
fi

TOTAL=0
COUNT=0
for FILE in $FILELIST; do
	TOTAL=$((TOTAL + 1))

	if exists $SOURCE/$FILE*.x86_64.rpm ; then 
		cp "$SOURCE/$FILE-"*".x86_64.rpm" . > /dev/null
		if [ $? -ne 0 ]; then
			echo -e "WARNING: Can't copy pakcage $FILE"
			continue
		fi 
		COUNT=$((COUNT + 1))
	fi

	if exists $SOURCE/$FILE*.noarch.rpm ; then
		cp "$SOURCE/$FILE-"*".noarch.rpm" . > /dev/null
		if [ $? -ne 0 ]; then
			echo -e "WARNING: Can't copy package $FILE"
			continue
		fi
		COUNT=$((COUNT + 1))
	fi
	#echo $FILE
	
done

echo -e "INFO: Copied $COUNT of $TOTAL packages"
if [ $COUNT -lt $TOTAL ]; then
	echo -e "WARNING: Incomplete copy"
fi


