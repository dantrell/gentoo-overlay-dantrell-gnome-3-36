# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson vala

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gcr"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0/1" # subslot = suffix of libgcr-3
KEYWORDS="*"

IUSE="gtk gtk-doc +introspection"

RDEPEND="
	>=app-crypt/p11-kit-0.19
	>=dev-libs/glib-2.44:2
	>=dev-libs/libgcrypt-1.2.2:0=
	>=dev-libs/libtasn1-1:=
	>=sys-apps/dbus-1
	gtk? ( >=x11-libs/gtk+-3.12:3[X,introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-1.34:= )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/gdbus-codegen
	gtk-doc? ( dev-util/gtk-doc )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		$(meson_use gtk)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
