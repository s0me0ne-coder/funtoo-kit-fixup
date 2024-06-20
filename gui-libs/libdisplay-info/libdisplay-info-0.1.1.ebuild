# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_10 )

inherit meson python-any-r1

DESCRIPTION="EDID and DisplayID library"
HOMEPAGE="https://gitlab.freedesktop.org//"
SRC_URI="https://gitlab.freedesktop.org/emersion/libdisplay-info/-/archive/0.1.1/libdisplay-info-0.1.1.tar.bz2 -> libdisplay-info-0.1.1.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="next"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-apps/hwdata"
DEPEND="${RDEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	test? ( >=sys-apps/edid-decode-0_pre20230131 )
"
