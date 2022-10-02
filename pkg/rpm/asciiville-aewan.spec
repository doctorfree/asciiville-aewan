Name: asciiville-aewan
Version:    %{_version}
Release:    %{_release}%{?dist}
BuildArch:  x86_64
Requires:   ncurses, zlib
URL:        https://github.com/doctorfree/asciiville-aewan
Vendor:     Doctorwhen's Bodacious Laboratory
Packager:   ronaldrecord@gmail.com
License     : GPL2
Summary     : NCurses Ascii Art Editor

%global __os_install_post %{nil}

%description
Aewan is a curses-based program for the creation and editing of ascii art

%prep

%build

%install
cp -a %{_sourcedir}/usr %{buildroot}/usr

%pre

%post

%preun

%files
/usr
%exclude %dir /usr/share/doc
%exclude %dir /usr/share
%exclude %dir /usr/bin

%changelog
