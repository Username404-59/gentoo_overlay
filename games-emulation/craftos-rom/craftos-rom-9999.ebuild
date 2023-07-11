# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/MCJack123/craftos2-rom.git"
	EGIT_SUBMODULES=( '*' )
	inherit git-r3
else
	SRC_URI="https://github.com/MCJack123/craftos2-rom/archive/refs/tags/v${PV}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 loong m68k mips ppc ppc64 riscv s390 sparc x86"
	S="${WORKDIR}"
fi

DESCRIPTION="ROM package for CraftOS-PC 2"
HOMEPAGE="https://www.craftos-pc.cc"

LICENSE="MIT"
SLOT="0"
IUSE=""

src_install() {
    mkdir -p "${D}/usr/local/share/craftos"
    cp -R * "${D}/usr/local/share/craftos/"
}
