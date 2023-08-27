# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/LizardByte/Sunshine.git"
	EGIT_SUBMODULES=( '*' )
	inherit git-r3
else
	SRC_URI="https://github.com/LizardByte/Sunshine/archive/refs/tags/v${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

inherit cmake

DESCRIPTION="Self-hosted game stream host for Moonlight"
HOMEPAGE="https://github.com/LizardByte/Sunshine"

LICENSE="GPL-3"
SLOT="0"
IUSE="cuda +kms +systray wayland X"

RDEPEND="
		dev-libs/boost
		dev-libs/openssl
		systray? ( dev-libs/libappindicator )
		dev-libs/libevdev
		media-libs/intel-mediasdk
		media-libs/libpulse
		media-libs/libva
		media-libs/opus
		kms? ( sys-libs/libcap )
		sys-process/numactl
		kms? ( x11-libs/libdrm )
		x11-libs/libvdpau
		wayland? ( dev-libs/wayland )
		X? ( x11-libs/libX11 x11-libs/libxcb x11-libs/libXfixes x11-libs/libXrandr x11-libs/libXtst )
"
DEPEND="${RDEPEND}"
BDEPEND="
		net-libs/nodejs:=[npm]
		cuda? ( dev-util/nvidia-cuda-toolkit )
"

src_configure() {
		local mycmakeargs=(
			-DSUNSHINE_ENABLE_WAYLAND="$(usex wayland)"
			-DSUNSHINE_ENABLE_X11="$(usex X)"
			-DSUNSHINE_ENABLE_CUDA="$(usex cuda)"
			-DSUNSHINE_ENABLE_TRAY="$(usex systray)"
			-DSUNSHINE_ENABLE_DRM="$(usex kms)"
			-DCMAKE_INSTALL_PREFIX="/usr"
			-DSUNSHINE_EXECUTABLE_PATH="/usr/bin/sunshine"
			-DSUNSHINE_ASSETS_DIR="share/sunshine_assets"
		)
		CMAKE_BUILD_TYPE=Release
		cmake_src_configure
}

src_prepare() {
	npm install # network-sandbox needs to be disabled
	cmake_src_prepare
}

DESKTOP_FILE="[Desktop Entry]
Type=Application
Name=Sunshine
Exec=sunshine
Version=1.0
Comment=Sunshine is a self-hosted game stream host for Moonlight
Icon=sunshine
Categories=Utility;
Terminal=true"

src_install() {
	echo "${DESKTOP_FILE}" > sunshine.desktop
	install -D -m 0644 sunshine.desktop "${D}/usr/share/applications/sunshine.desktop"
	default
}
