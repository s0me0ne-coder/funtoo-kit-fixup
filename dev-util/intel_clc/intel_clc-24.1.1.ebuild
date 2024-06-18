# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LLVM_COMPAT=( 16 )
LLVM_SLOT=16
PYTHON_COMPAT=( python3_10 )

inherit llvm meson python-any-r1

MY_PV="${PV/_/-}"

DESCRIPTION="intel_clc tool used for building OpenCL C to SPIR-V"
HOMEPAGE="https://mesa3d.org/"

S="${WORKDIR}/mesa-${MY_PV}"
SRC_URI="https://archive.mesa3d.org/mesa-${MY_PV}.tar.xz"
KEYWORDS="next"

LICENSE="MIT SGI-B-2.0"
SLOT="0"
IUSE="debug"

RDEPEND="
	dev-libs/libclc
	dev-util/spirv-tools
	>=sys-libs/zlib-1.2.8:=
	x11-libs/libdrm
	dev-util/spirv-llvm-translator:${LLVM_SLOT}
	sys-devel/clang:${LLVM_SLOT}
	sys-devel/llvm:${LLVM_SLOT}
"
DEPEND="${RDEPEND}
	dev-libs/expat
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep ">=dev-python/mako-0.8.0[\${PYTHON_USEDEP}]")
	virtual/pkgconfig
"

python_check_deps() {
	python_has_version -b ">=dev-python/mako-0.8.0[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	PKG_CONFIG_PATH="$(get_llvm_prefix)/$(get_libdir)/pkgconfig"

	use debug && EMESON_BUILDTYPE=debug

	local emesonargs=(
		-Dllvm=enabled
		-Dshared-llvm=enabled
		-Dintel-clc=enabled

		-Dgallium-drivers=''
		-Dvulkan-drivers=''

		# Set platforms empty to avoid the default "auto" setting. If
		# platforms is empty meson.build will add surfaceless.
		-Dplatforms=''

		-Dglx=disabled
		-Dlibunwind=disabled
		-Dzstd=disabled

		-Db_ndebug=$(usex debug false true)
	)
	meson_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/src/intel/compiler/intel_clc
}


  
