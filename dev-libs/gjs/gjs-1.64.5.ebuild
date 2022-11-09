# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome.org meson pax-utils

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs https://gitlab.gnome.org/GNOME/gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
KEYWORDS="*"

IUSE="+cairo examples readline sysprof test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.58.0
	>=dev-libs/gobject-introspection-1.61.2:=

	readline? ( sys-libs/readline:0= )
	dev-lang/spidermonkey:68=
	dev-libs/libffi:=
	cairo? ( x11-libs/cairo[X] )
	sysprof? ( >=dev-util/sysprof-3.33.32 )
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		sys-apps/dbus
		x11-libs/gtk+:3
	)
"

src_configure() {
	local emesonargs=(
		$(meson_feature cairo)
		$(meson_feature readline)
		$(meson_feature sysprof profiler)
		-D installed_tests=false
		-D dtrace=false
		-D systemtap=false
		-D bsymbolic_functions=false
		-D spidermonkey_rtti=false
		-D skip_dbus_tests=$(usex test false true)
		-D skip_gtk_tests=$(usex test false true)
		-D verbose_logs=false
	)
	meson_src_configure
}

src_install() {
	# Installation sometimes fails in parallel
	meson_src_install -j1

	if use examples; then
		dodoc -r examples
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}

src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}"
}
