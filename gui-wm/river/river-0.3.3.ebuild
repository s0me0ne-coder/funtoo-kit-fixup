# Copyright 2021-2022 Aisha Tammy
# Distributed under the terms of the ISC License

EAPI=7

inherit edo

DESCRIPTION="Dynamic tiling wayland compositor"
HOMEPAGE="https://codeberg.org/river/river"

SRC_URI="
https://codeberg.org/river/river/releases/download/v${PV}/${P}.tar.gz
https://codeberg.org/ifreund/zig-pixman/archive/v0.2.0.tar.gz -> zig-pixman-0.2.0.tar.gz
https://codeberg.org/ifreund/zig-wayland/archive/v0.2.0.tar.gz -> zig-wayland-0.2.0.tar.gz
https://codeberg.org/ifreund/zig-wlroots/archive/v0.17.1.tar.gz -> zig-wlroots-0.17.1.tar.gz
https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.2.0.tar.gz -> zig-xkbcommon-0.2.0.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="+man pie test +X no-llvm"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libevdev
	dev-libs/libinput
	dev-libs/wayland
	>=gui-libs/wlroots-0.17.2:=[X?]
	x11-libs/libxkbcommon:=[X?]
	x11-libs/pixman
"
DEPEND="${RDEPEND}"
EZIG_VISION="0.13*"
BDEPEND="
	|| ( =dev-lang/zig-${EZIG_VISION} =dev-lang/zig-bin-${EZIG_VISION} )
	dev-libs/wayland-protocols
	man? ( app-text/scdoc )
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/river(ctl|tile)?"


ezig() {
	edo zig "${@}"
}
src_prepare() {
	mkdir ${WORKDIR}/deps/
	ezig fetch --global-cache-dir ${WORKDIR}/deps/  ${DISTDIR}/zig-pixman-0.2.0.tar.gz
	ezig fetch --global-cache-dir ${WORKDIR}/deps/  ${DISTDIR}/zig-wayland-0.2.0.tar.gz
	ezig fetch --global-cache-dir ${WORKDIR}/deps/  ${DISTDIR}/zig-wlroots-0.17.1.tar.gz
	ezig fetch --global-cache-dir ${WORKDIR}/deps/  ${DISTDIR}/zig-xkbcommon-0.2.0.tar.gz
	default
}

src_compile() {
	local zigoptions=(
		--verbose
		--system ${WORKDIR}/deps/p/
		-Doptimize=ReleaseSafe
		-Dman-pages=$(usex man true false)
		-Dpie=$(usex pie true false)
		-Dxwayland=$(usex X true false)
		-Dno-llvm=$(usex no-llvm true false)
		${ZIG_FLAGS[@]}
	)

	DESTDIR="${T}" ezig build "${zigoptions[@]}" --prefix /usr || die
}

src_test() {
	ezig build test || die
}

src_install() {
	cp -a "${T}"/usr "${ED}"/usr || die

	dodoc -r README.md example || die
}
