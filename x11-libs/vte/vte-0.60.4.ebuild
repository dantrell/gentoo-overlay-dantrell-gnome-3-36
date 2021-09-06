# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.48"
VALA_MAX_API_VERSION="0.52"

inherit gnome2 meson vala

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/VTE"

LICENSE="LGPL-2+"
SLOT="2.91"
KEYWORDS="~*"

IUSE="bidi +crypt debug doc glade +introspection systemd vala vanilla-notify"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/icu-4.8
	>=dev-libs/glib-2.40:2
	>=dev-libs/libpcre2-10.21
	>=x11-libs/gtk+-3.16:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	sys-libs/zlib

	bidi? ( dev-libs/fribidi )
	crypt? ( >=net-libs/gnutls-3.2.7:0= )
	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	vala? ( $(vala_depend) )
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
"

src_prepare() {
	if ! use vanilla-notify; then
		# From Fedora:
		# 	https://src.fedoraproject.org/rpms/vte291/tree/f32
		eapply "${FILESDIR}"/${PN}-0.60.0-cntnr-precmd-preexec-scroll.patch
	fi

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-D a11y=false
		$(meson_use debug debugg)
		$(meson_use doc docs)
		$(meson_use introspection gir)
		$(meson_use bidi fribidi)
		$(meson_use crypt gnutls)
		-D gtk3=true
		-D gtk4=false
		-D icu=true
		$(meson_use systemd _systemd)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${ED}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
