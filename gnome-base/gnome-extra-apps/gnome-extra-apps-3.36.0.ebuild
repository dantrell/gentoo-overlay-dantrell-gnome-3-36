# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Metapackage for GNOME applications"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="*"

IUSE="anjuta +bijiben boxes builder california +celluloid +dino empathy epiphany +evolution flashback +foliate +fonts +games geary gnote latexila multiwriter +recipes +share +shotwell simple-scan +todo +tracker +usage"

# Cantarell doesn't provide support for modern emojis so we pair it with Noto,.Symbola, and Unifont:
#
# 	https://bugzilla.gnome.org/show_bug.cgi?id=762890
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=app-admin/gnome-system-log-20170809
	>=app-arch/file-roller-${PV}
	>=app-dicts/gnome-dictionary-3.26
	>=gnome-base/dconf-editor-${PV}
	>=gnome-extra/gconf-editor-3
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-3.32.0
	>=gnome-extra/gnome-clocks-${PV}
	>=gnome-extra/gnome-getting-started-docs-${PV}
	>=gnome-extra/gnome-power-manager-3.32.0
	>=gnome-extra/gnome-search-tool-3.6
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweaks-3.33.0
	>=gnome-extra/gnome-weather-${PV}
	>=gnome-extra/gucharmap-11.0.0:2.90
	>=gnome-extra/nautilus-sendto-3.8.5
	>=gnome-extra/sushi-3.34.0
	>=media-gfx/gnome-font-viewer-3.33.0
	>=media-gfx/gnome-screenshot-${PV}
	>=media-sound/gnome-sound-recorder-3.34.0
	>=media-sound/sound-juicer-3.24
	>=media-video/cheese-3.34.0
	>=net-analyzer/gnome-nettool-3.8
	>=net-misc/vinagre-3.22
	>=net-misc/vino-3.22
	>=sci-geosciences/gnome-maps-${PV}
	>=sys-apps/baobab-3.34.0
	>=sys-apps/gnome-disk-utility-${PV}

	anjuta? ( >=dev-util/anjuta-3.34 )
	bijiben? ( >=app-misc/bijiben-${PV} )
	boxes? ( >=gnome-extra/gnome-boxes-${PV} )
	builder? ( >=dev-util/gnome-builder-${PV} )
	california? ( >=gnome-extra/california-0.4.0 )
	celluloid? ( >=media-video/celluloid-0.16 )
	dino? ( >=net-im/dino-0.0.20190412 )
	empathy? ( >=net-im/empathy-3.12.13 )
	epiphany? ( >=www-client/epiphany-${PV} )
	evolution? ( >=mail-client/evolution-${PV} )
	flashback? ( >=gnome-base/gnome-flashback-${PV} )
	foliate? ( >=app-text/foliate-1.5.3 )
	fonts? (
		>=media-fonts/noto-20181024
		>=media-fonts/symbola-9.17
		>=media-fonts/unifont-10.0.06 )
	games? (
		>=games-arcade/gnome-nibbles-${PV}
		>=games-arcade/gnome-robots-${PV}
		>=games-board/aisleriot-3.22.0
		>=games-board/four-in-a-row-${PV}
		>=games-board/gnome-chess-${PV}
		>=games-board/gnome-mahjongg-${PV}
		>=games-board/gnome-mines-${PV}
		>=games-board/iagno-${PV}
		>=games-board/tali-${PV}
		>=games-puzzle/atomix-3.34.0
		>=games-puzzle/five-or-more-3.32.0
		>=games-puzzle/gnome2048-${PV}
		>=games-puzzle/gnome-klotski-${PV}
		>=games-puzzle/gnome-sudoku-${PV}
		>=games-puzzle/gnome-taquin-${PV}
		>=games-puzzle/gnome-tetravex-${PV}
		>=games-puzzle/hitori-${PV}
		>=games-puzzle/lightsoff-${PV}
		>=games-puzzle/quadrapassel-${PV}
		>=games-puzzle/swell-foop-3.34.0 )
	geary? ( >=mail-client/geary-0.12.4 )
	gnote? ( >=app-misc/gnote-${PV} )
	latexila? ( >=app-editors/gnome-latex-${PV} )
	multiwriter? ( >=gnome-extra/gnome-multi-writer-3.32.0 )
	recipes? ( >=gnome-extra/gnome-recipes-1.6.2 )
	share? ( >=gnome-extra/gnome-user-share-3.34.0 )
	shotwell? ( >=media-gfx/shotwell-0.24 )
	simple-scan? ( >=media-gfx/simple-scan-${PV} )
	todo? ( >=app-office/gnome-todo-3.28 )
	tracker? (
		>=app-misc/tracker-2:0=
		>=app-misc/tracker-miners-2:0=
		>=gnome-extra/gnome-documents-3.33.0
		>=media-gfx/gnome-photos-3.34.0
		>=media-sound/gnome-music-${PV} )
	usage? ( >=sys-process/gnome-usage-3.33.0 )
"
DEPEND=""

S="${WORKDIR}"
