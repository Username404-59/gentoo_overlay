# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 systemd git-r3

DESCRIPTION="Generate rEFInd manual boot stanzas from Btrfs snapshots"
HOMEPAGE="https://github.com/Venom1991/refind-btrfs"
EGIT_REPO_URI="https://github.com/Venom1991/refind-btrfs"

LICENSE="GPL-3"
SLOT="0"

IUSE="systemd"

BDEPEND="sys-apps/sed"
DEPEND="
    sys-boot/refind
    sys-fs/btrfs-progs
    dev-python/antlr4-python3-runtime[${PYTHON_USEDEP}]
    dev-python/btrfsutil[${PYTHON_USEDEP}]
    dev-python/injector[${PYTHON_USEDEP}]
    dev-python/more-itertools[${PYTHON_USEDEP}]
    dev-python/pid[${PYTHON_USEDEP}]
    dev-python/python-systemd[${PYTHON_USEDEP}]
    dev-python/tomlkit[${PYTHON_USEDEP}]
    dev-python/transitions[${PYTHON_USEDEP}]
    dev-python/typeguard[${PYTHON_USEDEP}]
    dev-python/watchdog[${PYTHON_USEDEP}]
"
RDEPEND="$DEPEND"

src_install() {
    distutils-r1_src_install
    keepdir /var/lib/refind-btrfs
    pushd src/refind_btrfs/data
    PYTHON_COMPAT_STR=`echo "${PYTHON_COMPAT[@]}" | tr _ .`
    sed -i -e "s/python/cd \/usr\/bin;last_version=\$(find $PYTHON_COMPAT_STR -type f -print0 2>\/dev\/null \| xargs -0 ls -t \| head -n 1); \$last_version/g" refind-btrfs
    dobin refind-btrfs
    insopts -m644
    insinto /etc
    mv refind-btrfs.conf-sample refind-btrfs.conf
    doins refind-btrfs.conf
    if use systemd; then
        systemd_dounit refind-btrfs.service
    fi
    popd
}
