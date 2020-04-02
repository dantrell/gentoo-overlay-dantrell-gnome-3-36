# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome.org readme.gentoo-r1 meson xdg

DESCRIPTION="JavaScript extensions for GNOME Shell"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell/Extensions"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="test"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.26:2
	>=gnome-base/libgtop-2.28.3[introspection]
	>=app-eselect/eselect-gnome-shell-extensions-20180306
"
RDEPEND="${COMMON_DEPEND}
	>=dev-libs/gjs-1.29
	dev-libs/gobject-introspection:=
	dev-libs/atk[introspection]
	gnome-base/gnome-menus:3[introspection]
	>=gnome-base/gnome-shell-3.36
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	x11-themes/adwaita-icon-theme
	>=x11-wm/mutter-3.32[introspection]
"
DEPEND="${COMMON_DEPEND}
	dev-lang/sassc
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( dev-lang/spidermonkey:60 )
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="Installed extensions installed are initially disabled by default.
To change the system default and enable some extensions, you can use
# eselect gnome-shell-extensions

Alternatively, to enable/disable extensions on a per-user basis,
you can use the https://extensions.gnome.org/ web interface, the
gnome-extra/gnome-tweaks GUI, or modify the org.gnome.shell
enabled-extensions gsettings key from the command line or a script."

src_prepare() {
	# Provided by gnome-base/gnome-shell-common
	sed -e '/.*calendar-today.svg.*/d' \
		-i data/meson.build || die "sed failed"

	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dextension_set=all
		-Dclassic_mode=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst

	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?

	readme.gentoo_print_elog
}
