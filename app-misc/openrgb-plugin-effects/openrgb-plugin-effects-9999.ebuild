# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qmake-utils git-r3

DESCRIPTION="Plugin for OpenRGB with various Effects that can be synced across devices"
HOMEPAGE="https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin"

EGIT_REPO_URI="https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=app-misc/openrgb-0.9:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5[-gles2-only]
	dev-qt/qtwidgets:5[-gles2-only]
	media-libs/openal
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
"

PATCHES=(
	"${FILESDIR}/openrgb-plugin-effects-0.9-dep.patch"
)

src_prepare() {
	default

	filter-lto # Bug 927749

	rm -r OpenRGB || die
	ln -s "${ESYSROOT}/usr/include/OpenRGB" . || die
	sed -e '/^GIT_/d' -i *.pro || die

	# Because of -Wl,--export-dynamic in app-misc/openrgb, this resources.qrc
	# conflicts with the openrgb's one. So rename it.
	sed -e 's/ resources.qrc/ resources_effects_plugin.qrc/' -i *.pro || die
	mv --no-clobber resources.qrc resources_effects_plugin.qrc || die
}

src_configure() {
	eqmake5 \
		INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann"
}

src_install() {
	exeinto /usr/$(get_libdir)/OpenRGB/plugins
	doexe libOpenRGBEffectsPlugin.so
}
