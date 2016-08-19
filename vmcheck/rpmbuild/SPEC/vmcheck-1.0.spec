# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing
%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Summary: A script to check for virtualisation and if virtualised adjust kernel parameters for best performance of an AMD. For use with Dynatrace Data Center Real User Monitoring.
Name: vmcheck
Version: 1.0.0
Release: 1%{?dist}
License: GPL
SOURCE0 : %{name}-%{version}.tar.gz
URL: https://github.com/cvidler/amd_build_disc
BuildArch: x86_64
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
Requires: bash >= 4.2,virt-what,coreutils,grep


%postun
cat /etc/rc.local | grep -v "vmcheck.sh" | tee /etc/rc.local


%post
RESULT=`grep "vmcheck.sh" /etc/rc.local`
if [ "$RESULT" == "" ]; then
	echo -e "/sbin/vmcheck.sh      #check for virtualisation and adjust kernel as needed" | tee -a /etc/rc.local
fi;
chmod +x /etc/rc.d/rc.local


%description
%{summary}


%prep
%setup -q


%build
# Empty section.


%install
rm -rf %{buildroot}
mkdir -p %{buildroot}

# in builddir
cp -a * %{buildroot}


%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
#%config(noreplace) %{_sysconfdir}/%{name}/%{name}.conf
#%{_bindir}/*
/sbin/*


%changelog
* Fri Aug 19 2016  Chris Vidler <christopher.vidler@dynatrace.com> 1.0.0-1
- First Build release.

