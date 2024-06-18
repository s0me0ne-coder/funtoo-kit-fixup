# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A tool for generating C bindings to Rust code"
HOMEPAGE="https://github.com/rust-lang/rust-bindgen"
SRC_URI="https://github.com/rust-lang/rust-bindgen/tarball/398c8c746ec928c00ccc18e1cc7c1643ed05b8e3 -> rust-bindgen-0.68.1-398c8c7.tar.gz
https://direct.funtoo.org/c9/17/ca/c917ca004630a1faf35ce1dbe57b768d4d0292ac41c59f7a0b1984f1114d7bfc8fbd8fc5ebc61b6227fc4f837dff59f24042ed300ec083316af83e24756c7bb4 -> rust-bindgen-0.68.1-funtoo-crates-bundle-6f3bd25dd15ed2589e75f1a8205c0b3dbd248ffe1afc0a1d16a2db50b73b0501fd16ce046f0436f6bdf86c6ae7103fab519dc272c9a50f918c9c38a7b70ab898.tar.gz"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 ISC LGPL-3+ MIT MPL-2.0 Apache-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="*"

QA_FLAGS_IGNORED="/usr/bin/rust-bindgen"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/rust-lang-rust-bindgen-* ${S} || die
}

src_test () {
	# required by clang during tests
	local -x TARGET="$(rust_abi)"

	cargo_src_test --bins --lib
}


src_install() {
	cargo_src_install --path "${S}/bindgen-cli"
	einstalldocs
}