# Prevent brp-python-bytecompile from running
%define __os_install_post %{___build_post}

Summary: Vienna public transport schedule
Name: harbour-sailtovienna
Version: 0.0.4
Release: 1
Source: %{name}-%{version}.tar.gz
BuildArch: noarch
URL: https://github.com/kelvan/sailtoVienna/
License: GPLv3
Group: System/GUI/Other
Requires: pyotherside-qml-plugin-python3-qt5
Requires: sailfishsilica-qt5
Requires: libsailfishapp-launcher
Requires: python3-requests
BuildRequires: qt5-qmake
BuildRequires: pkgconfig(sailfishapp)

%description
Wienerlinien departure app for SailfishOS

%prep
%setup -q

%build
%qmake5
make %{?_smp_mflags}

%install
make INSTALL_ROOT=%{buildroot} install

%files
%defattr(-,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
