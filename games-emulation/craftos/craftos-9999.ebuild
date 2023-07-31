# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/MCJack123/craftos2.git"
	EGIT_SUBMODULES=( '*' )
	inherit git-r3
else
	SRC_URI="https://github.com/MCJack123/craftos2/archive/refs/tags/v${PV}.tar.gz"
	KEYWORDS="amd64 arm64 ia64 ppc64"
	S="${WORKDIR}"
fi

DESCRIPTION="A fast, modern, and feature-filled ComputerCraft emulator written in C++"
HOMEPAGE="https://www.craftos-pc.cc"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
		media-libs/libpng
		media-libs/libwebp
		media-libs/libharu
		sys-libs/ncurses-compat:=[tinfo]
		sys-libs/ncurses:=[tinfo]
		media-libs/sdl-mixer

		media-libs/libsdl
		dev-libs/openssl
		dev-libs/poco

		games-emulation/craftos-rom
"
DEPEND="${RDEPEND}"
BDEPEND="
		sys-devel/make
		dev-util/patchelf
		app-arch/unzip
"

inherit flag-o-matic

src_prepare() {
	mkdir icons
	unzip resources/linux-icons.zip -d icons
	default
}

src_configure() {
	append-ldflags -ltinfo
	econf --prefix="${D}/usr"
}

src_compile() {
	emake -C craftos2-lua linux
	default
}

src_install() {
	mkdir -p "${D}/usr/bin"
	DEST_DIR="${D}/usr/bin" emake install
	mv "${D}/usr/craftos" "${D}/usr/bin/craftos"
	install -D -m 0755 craftos2-lua/src/liblua.so "${D}/usr/lib64/libcraftos2-lua.so"
	patchelf --replace-needed craftos2-lua/src/liblua.so libcraftos2-lua.so "${D}/usr/bin/craftos"
	mkdir -p "${D}/usr/include"
	cp -R api "${D}/usr/include/CraftOS-PC"
	sed -i '/Exec=craftos/c\Exec=craftos --rom /usr/local/share/craftos' icons/CraftOS-PC.desktop
	install -D -m 0644 icons/CraftOS-PC.desktop "${D}/usr/share/applications/CraftOS-PC.desktop"
	install -D -m 0644 icons/16.png "${D}/usr/share/icons/hicolor/16x16/apps/craftos.png"
	install -D -m 0644 icons/24.png "${D}/usr/share/icons/hicolor/24x24/apps/craftos.png"
	install -D -m 0644 icons/32.png "${D}/usr/share/icons/hicolor/32x32/apps/craftos.png"
	install -D -m 0644 icons/48.png "${D}/usr/share/icons/hicolor/48x48/apps/craftos.png"
	install -D -m 0644 icons/64.png "${D}/usr/share/icons/hicolor/64x64/apps/craftos.png"
	install -D -m 0644 icons/96.png "${D}/usr/share/icons/hicolor/96x96/apps/craftos.png"
	einstalldocs
}
