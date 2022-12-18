# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python{3_8,3_9,3_10,3_11} )
PYTHON_REQ_USE="xml(+)"
VALA_MIN_API_VERSION="0.28"

inherit gnome2 meson multilib python-single-r1 vala

DESCRIPTION="Official plugins for gedit"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit/ThirdPartyPlugins"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="charmap git terminal"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=app-editors/gedit-3.16
	>=dev-libs/glib-2.32:2
	>=dev-libs/libpeas-1.7.0[gtk]
	>=x11-libs/gtk+-3.9:3
	>=x11-libs/gtksourceview-4.0.2:4

	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=app-editors/gedit-3.16[introspection,python,${PYTHON_SINGLE_USEDEP}]
		dev-libs/libpeas[python,${PYTHON_SINGLE_USEDEP}]
		>=dev-python/dbus-python-0.82[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	')
	>=x11-libs/gtk+-3.9:3[introspection]
	>=x11-libs/gtksourceview-3.14:3.0[introspection]
	x11-libs/pango[introspection]
	x11-libs/gdk-pixbuf:2[introspection]

	charmap? ( >=gnome-extra/gucharmap-3:2.90[introspection] )
	git? ( >=dev-libs/libgit2-glib-0.0.6 )
	terminal? ( >=x11-libs/vte-0.52:2.91[introspection] )

	$(vala_depend)
" # vte-0.52+ for feed_child API compatibility
DEPEND="${RDEPEND}
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-D plugin_bookmarks=true
		-D plugin_bracketcompletion=true
		$(meson_use charmap plugin_charmap)
		-D plugin_codecomment=true
		-D plugin_colorpicker=true
		-D plugin_colorschemer=true
		-D plugin_commander=true
		-D plugin_drawspaces=true
		-D plugin_findinfiles=true
		$(meson_use git plugin_git)
		-D plugin_joinlines=true
		-D plugin_multiedit=true
		-D plugin_sessionsaver=true
		-D plugin_smartspaces=true
		$(meson_use terminal plugin_terminal)
		-D plugin_textsize=true
		-D plugin_translate=true
		-D plugin_wordcompletion=true
		-D plugin_zeitgeist=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# FIXME: crazy !!!
	find "${ED}"/usr/share/gedit -name "*.py*" -delete || die
	find "${ED}"/usr/share/gedit -type d -empty -delete || die
}
