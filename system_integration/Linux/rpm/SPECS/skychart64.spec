Summary: Skychart / Cartes du Ciel planetarium software
Name: skychart
Version: 3
Release: 1
Group: Sciences/Astronomy
License: GPLv2+
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: x86_64
Provides: skychart
Requires: libpasastro gtk2 glib2 pango mesa-libGLU libjpeg libpng sqlite xplanet espeak
AutoReqProv: no

%description
Planetarium software for the advanced amateur astronomer.

%files
%defattr(-,root,root)
/usr/bin/skychart
/usr/bin/cdcicon
/usr/bin/varobs
/usr/bin/varobs_lpv_bulletin
/usr/share/metainfo/skychart.appdata.xml
/usr/share/applications/skychart.desktop
/usr/share/pixmaps/skychart.png
/usr/share/icons/hicolor/48x48/apps/skychart.png
/usr/share/icons/hicolor/scalable/apps/skychart.svg
/usr/share/doc/skychart
/usr/share/skychart

