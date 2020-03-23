# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2 meson

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gsettings-desktop-schemas"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="+introspection vanilla-fonts"

RDEPEND="
	>=dev-libs/glib-2.31:2
	introspection? ( >=dev-libs/gobject-introspection-1.31.0:= )
	vanilla-fonts? ( media-fonts/source-pro )
	!<gnome-base/gdm-3.8
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	if ! use vanilla-fonts; then
		# From GNOME:
		# 	https://gitlab.gnome.org/GNOME/gsettings-desktop-schemas/commit/965062de47f5171727c1e4f7f0aac2ad40e3484a
		eapply -R "${FILESDIR}"/${PN}-3.31.90-schemas-change-default-monospaced-and-document-fonts.patch
	fi

	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
	)
	meson_src_configure
}
