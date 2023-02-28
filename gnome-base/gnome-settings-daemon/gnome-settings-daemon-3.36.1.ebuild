# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_9,3_10,3_11} )

inherit gnome.org gnome2-utils python-any-r1 meson udev virtualx xdg

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-settings-daemon"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="+colord +cups debug elogind input_devices_wacom modemmanager networkmanager smartcard systemd test +udev vanilla-inactivity wayland"
REQUIRED_USE="
	?? ( elogind systemd )
	input_devices_wacom? ( udev )
	wayland? ( udev )
"

RESTRICT="!test? ( test )"

# >=polkit-0.114 for ITS translation rules of .policy files
COMMON_DEPEND="
	>=sci-geosciences/geocode-glib-3.10:0
	>=dev-libs/glib-2.53.0:2
	>=gnome-base/gnome-desktop-3.11.1:3=
	>=gnome-base/gsettings-desktop-schemas-3.33.0
	>=x11-libs/gtk+-3.15.3:3[X,wayland?]
	>=dev-libs/libgweather-3.9.5:2=
	colord? (
		>=x11-misc/colord-1.0.2:=
		>=media-libs/lcms-2.2:2 )
	media-libs/libcanberra[gtk3]
	>=app-misc/geoclue-2.3.1:2.0
	>=x11-libs/libnotify-0.7.3
	>=media-sound/pulseaudio-2[glib]
	>=sys-auth/polkit-0.114
	>=sys-power/upower-0.99.8:=
	x11-libs/libX11
	x11-libs/libXtst
	udev? ( dev-libs/libgudev:= )
	wayland? ( dev-libs/wayland )
	input_devices_wacom? ( >=dev-libs/libwacom-0.7
		>=x11-libs/pango-1.20.0
		x11-libs/gdk-pixbuf:2 )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	cups? ( >=net-print/cups-1.4[dbus] )
	modemmanager? (
		>=app-crypt/gcr-3.7.5:0=
		>=net-misc/modemmanager-1.0
	)
	networkmanager? ( >=net-misc/networkmanager-1.0:= )
	media-libs/alsa-lib
	x11-libs/libXi
	x11-libs/libXext
	media-libs/fontconfig
"
# consolekit or logind needed for power and session management, bug #464944
# gnome-session-3.27.90 and gdm-3.27.9 adapt to A11yKeyboard component removal (moved to shell dealing with it)
# dbus[user-session] for user services support (functional screen sharing setup)
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd
		sys-apps/dbus[user-session] )
	!<gnome-base/gnome-session-3.27.90
	!<gnome-base/gdm-3.27.90
"
# rfkill requires linux/rfkill.h, thus linux-headers dep, not os-headers. If this package wants to work on other kernels, we need to make rfkill conditional instead
DEPEND="${COMMON_DEPEND}
	sys-kernel/linux-headers
	dev-util/gdbus-codegen
	x11-base/xorg-proto
	${PYTHON_DEPS}
	test? (
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/python-dbusmock[${PYTHON_USEDEP}]')
		gnome-base/gnome-session )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

python_check_deps() {
	if use test; then
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# Make colord, networkmanager, udev and wacom optional
	eapply "${FILESDIR}"/${PN}-3.34.0-optional.patch

	if ! use vanilla-inactivity; then
		# From GNOME:
		# 	https://gitlab.gnome.org/GNOME/gnome-settings-daemon/commit/2fdb48fa3333638cee889b8bb80dc1d2b65aaa4a
		eapply "${FILESDIR}"/${PN}-3.30.1.2-power-dont-default-to-suspend-after-20-minutes-of-inactivity.patch
	fi

	# From Ben Wolsieffer:
	# 	https://bugzilla.gnome.org/show_bug.cgi?id=734964
	eapply "${FILESDIR}"/${PN}-3.34.0-optionally-allow-suspending-with-multiple-monitors-on-lid-close.patch

	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dudev_dir="$(get_udevdir)"
		$(meson_use systemd)
		-Dalsa=true
		$(meson_use udev gudev)
		$(meson_use colord color)
		$(meson_use cups)
		$(meson_use networkmanager network_manager)
		-Drfkill=true
		$(meson_use smartcard)
		$(meson_use input_devices_wacom wacom)
		$(meson_use wayland)
		$(meson_use modemmanager wwan)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
