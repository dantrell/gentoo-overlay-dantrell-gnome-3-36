# Distributed under the terms of the GNU General Public License v2

EAPI="7"
VALA_MIN_API_VERSION="0.40"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Play the classic two-player boardgame of chess"
HOMEPAGE="https://wiki.gnome.org/Apps/Chess https://gitlab.gnome.org/GNOME/gnome-chess"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="+engines"

RDEPEND="
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.20.0:3
	>=gnome-base/librsvg-2.32.0:2
	engines? (
		games-board/crafty
		games-board/gnuchess
		games-board/sjeng
		games-board/stockfish
	)
"
DEPEND="${RDEPEND}
	gnome-base/librsvg:2[vala]
"
BDEPEND="
	$(vala_depend)
	dev-util/itstool
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
