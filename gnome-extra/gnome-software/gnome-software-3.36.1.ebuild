# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="GNOME utility for installing and updating applications"
HOMEPAGE="https://wiki.gnome.org/Apps/Software https://gitlab.gnome.org/GNOME/gnome-software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="flatpak +firmware gnome gtk-doc spell sysprof udev"

RDEPEND="
	>=dev-libs/appstream-glib-0.7.14:0
	>=x11-libs/gdk-pixbuf-2.32.0:2
	>=dev-libs/libxmlb-0.1.7:=
	net-libs/gnome-online-accounts:=
	>=x11-libs/gtk+-3.22.4:3
	>=dev-libs/glib-2.56:2
	>=dev-libs/json-glib-1.2.0
	>=net-libs/libsoup-2.52.0:2.4
	gnome? ( >=gnome-base/gsettings-desktop-schemas-3.18.0 )
	spell? ( app-text/gspell:= )
	sys-auth/polkit
	firmware? ( >=sys-apps/fwupd-1.0.3 )
	flatpak? (
		>=sys-apps/flatpak-1.0.4
		dev-util/ostree
	)
	udev? ( dev-libs/libgudev )
	>=gnome-base/gsettings-desktop-schemas-3.11.5
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
"

src_prepare() {
	xdg_src_prepare
	sed -i -e '/install_data.*README\.md.*share\/doc\/gnome-software/d' meson.build || die
	# We don't need language packs download support, and it fails tests in 3.34.2 for us (if they are enabled)
	sed -i -e '/subdir.*fedora-langpacks/d' plugins/meson.build || die
	# Trouble talking to spawned gnome-keyring socket for some reason, even if wrapped in dbus-run-session
	sed -i -e '/g_test_add_func.*gs_auth_secret_func/d' lib/gs-self-test.c || die
}

src_configure() {
	local emesonargs=(
		-Dtests=false
		$(meson_use spell gspell)
		$(meson_use gnome gnome_desktop) # Honoring of GNOME date format settings.
		-Dman=true
		-Dpackagekit=false
		-Dpackagekit_autoremove=false
		-Dpolkit=true
		-Deos_updater=false # Endless OS updater
		$(meson_use firmware fwupd)
		$(meson_use flatpak)
		-Dmalcontent=false
		-Drpm_ostree=false
		-Dodrs=false
		$(meson_use udev gudev)
		-Dsnap=false
		-Dexternal_appstream=false
		-Dvalgrind=false
		$(meson_use gtk-doc gtk_doc)
		-Dhardcoded_popular=true
		-Ddefault_featured_apps=false # Shows some apps under installed (probably due to /usr/share/app-info), but interacting with them is broken
		-Dmogwai=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
