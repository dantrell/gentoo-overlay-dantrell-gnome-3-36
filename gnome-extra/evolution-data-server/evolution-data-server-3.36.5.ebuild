# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit cmake-utils db-use flag-o-matic gnome2 systemd vala virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution https://gitlab.gnome.org/GNOME/evolution-data-server"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) BSD Sleepycat"
SLOT="0/62-24-20" # subslot = libcamel-1.2/libedataserver-1.2/libebook-1.2.so soname version
KEYWORDS="*"

IUSE="berkdb +gnome-online-accounts google +gtk gtk-doc +introspection ldap kerberos oauth vala +weather"
REQUIRED_USE="vala? ( introspection )"

# Some tests fail due to missing locales.
# Also, dbus tests are flaky, bugs #397975 #501834
# It looks like a nightmare to disable those for now.
RESTRICT="test !test? ( test )"

# gdata-0.17.7 soft required for new gdata_feed_get_next_page_token API to handle more than 100 google tasks
# berkdb needed only for migrating old addressbook data from <3.13 versions, bug #519512
RDEPEND="
	>=app-crypt/gcr-3.4:0=
	>=app-crypt/libsecret-0.5[crypt]
	>=dev-db/sqlite-3.7.17:=
	>=dev-libs/glib-2.46:2
	>=dev-libs/libgdata-0.10:=
	>=dev-libs/libical-3.0.7:=[introspection?]
	>=dev-libs/libxml2-2
	>=dev-libs/nspr-4.4:=
	>=dev-libs/nss-3.9:=
	>=net-libs/libsoup-2.58:2.4

	dev-libs/icu:=
	sys-libs/zlib:=
	virtual/libiconv

	berkdb? ( >=sys-libs/db-4:= )
	gtk? (
		>=app-crypt/gcr-3.4:0=[gtk]
		>=x11-libs/gtk+-3.10:3
		>=media-libs/libcanberra-0.25[gtk3]
	)
	google? (
		>=dev-libs/json-glib-1.0.4
		>=dev-libs/libgdata-0.17.7:=
		>=net-libs/webkit-gtk-2.11.91:4
	)
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8:= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	weather? ( >=dev-libs/libgweather-3.10:2= )
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/gperf
	gtk-doc? ( >=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.1.2 )
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	vala? ( $(vala_depend)
		net-libs/libsoup:2.4[vala]
		dev-libs/libical[vala]
	)
"

# global scope PATCHES or DOCS array mustn't be used due to double default_src_prepare call
src_prepare() {
	# Make CMakeLists versioned vala enabled
	eapply "${FILESDIR}"/${PN}-3.24.2-assume-vala-bindings.patch

	use vala && vala_src_prepare
	cmake-utils_src_prepare
	gnome2_src_prepare

	eapply "${FILESDIR}"/${PN}-3.36.5-gtk-doc-1.32-compat.patch
}

src_configure() {
	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	use berkdb && append-cppflags "-I$(db_includedir)"

	# phonenumber does not exist in tree
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		-DENABLE_GTK_DOC=$(usex gtk-doc)
		-DWITH_PRIVATE_DOCS=$(usex gtk-doc)
		-DENABLE_SCHEMAS_COMPILE=OFF
		-DENABLE_INTROSPECTION=$(usex introspection)
		-DWITH_KRB5=$(usex kerberos)
		-DWITH_KRB5_INCLUDES=$(usex kerberos "${EPREFIX}"/usr "")
		-DWITH_KRB5_LIBS=$(usex kerberos "${EPREFIX}"/usr/$(get_libdir) "")
		-DWITH_OPENLDAP=$(usex ldap)
		-DWITH_PHONENUMBER=OFF
		-DENABLE_SMIME=ON
		-DENABLE_GTK=$(usex gtk)
		-DENABLE_CANBERRA=$(usex gtk)
		-DENABLE_OAUTH2=$(usex oauth)
		-DENABLE_EXAMPLES=OFF
		-DENABLE_GOA=$(usex gnome-online-accounts)
		-DENABLE_UOA=OFF
		-DWITH_LIBDB=$(usex berkdb "${EPREFIX}"/usr OFF)
		-DENABLE_IPV6=ON
		-DENABLE_WEATHER=$(usex weather)
		-DENABLE_GOOGLE=$(usex google)
		-DENABLE_LARGEFILE=ON
		-DENABLE_VALA_BINDINGS=$(usex vala)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	virtx cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	if use ldap; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema
		dosym ../../../usr/share/${PN}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst
	if ! use berkdb; then
		ewarn "You will need to enable berkdb USE for migrating old"
		ewarn "(pre-3.13 evolution versions) addressbook data"
	fi
}
