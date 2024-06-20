# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edo

DESCRIPTION="Hardware identification and configuration data"
HOMEPAGE="https://github.com/vcrhonek/hwdata"
SRC_URI="https://github.com/vcrhonek/hwdata/tarball/28a3988cac718232a2d64735ae5f24745d211ae2 -> hwdata-0.383-28a3988.tar.gz"
S="${WORKDIR}/vcrhonek-hwdata-28a3988"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="next"

RESTRICT="test"

src_configure() {
	# configure is not compatible with econf
	local conf=(
		./configure
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/lib"
		--datadir="${EPREFIX}/usr/share"
	)

	edo "${conf[@]}"
}


