# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome.org gnome2-utils meson multilib-minimal xdg

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/glib-networking"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="+gnome +libproxy +ssl test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.63.0:2[${MULTILIB_USEDEP}]
	libproxy? ( >=net-libs/libproxy-0.4.11-r1:=[${MULTILIB_USEDEP}] )
	>=net-libs/gnutls-3.6.5:=[${MULTILIB_USEDEP}]
	ssl? ( app-misc/ca-certificates )
	gnome? ( gnome-base/gsettings-desktop-schemas )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test? ( sys-apps/dbus )
"

multilib_src_configure() {
	local emesonargs=(
		-Dgnutls=enabled
		-Dopenssl=disabled
		$(meson_feature libproxy)
		$(meson_feature gnome gnome_proxy)
		-Dinstalled_tests=false
		-Dstatic_modules=false
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_test() {
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

pkg_postinst() {
	xdg_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	multilib_foreach_abi multilib_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm

	multilib_pkg_postrm() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	multilib_foreach_abi multilib_pkg_postrm
}
