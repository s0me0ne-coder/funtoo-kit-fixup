# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Minimal seat management daemon and universal library"
HOMEPAGE="https://sr.ht/~kennylevinsen/seatd"
KEYWORDS="next"
SRC_URI="https://git.sr.ht/~kennylevinsen/seatd/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0/1"
IUSE="builtin elogind server"
REQUIRED_USE="?? ( elogind )"

DEPEND="
	elogind? ( sys-auth/elogind )
"
RDEPEND="${DEPEND}
	server? ( acct-group/seat )
"
#BDEPEND=">=app-text/scdoc-1.9.7"

src_configure() {
	local emesonargs=(
		-Dman-pages=disabled
		$(meson_feature builtin libseat-builtin)
		$(meson_feature server)
	)

	if use elogind ; then
		emesonargs+=( -Dlibseat-logind=elogind )
	else
		emesonargs+=( -Dlibseat-logind=disabled )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	if use server; then
		newinitd "${FILESDIR}/seatd.initd" seatd
		systemd_dounit contrib/systemd/seatd.service

		if has_version '<sys-auth/seatd-0.7.0-r2'; then
			elog "For OpenRC users: seatd is now using the 'seat' group instead of the 'video' group"
			elog "Make sure your user(s) are in the 'seat' group."
			elog "Note: 'video' is still needed for GPU access like OpenGL"
		fi
	fi
}



