# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Lightweight KMS plane library"
HOMEPAGE="https://gitlab.freedesktop.org//"
SRC_URI="https://gitlab.freedesktop.org/emersion/libliftoff/-/archive/v0.5.0/libliftoff-v0.5.0.tar.bz2 -> libliftoff-v0.5.0.tar.bz2"
S="${WORKDIR}/libliftoff-v${PV}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	x11-libs/libdrm
"
DEPEND="
	${RDEPEND}
"
