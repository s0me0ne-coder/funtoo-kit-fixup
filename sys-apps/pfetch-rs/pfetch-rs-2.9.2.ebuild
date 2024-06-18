# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A rewrite of the pfetch system information tool in Rust"
HOMEPAGE="https://github.com/Gobidev/pfetch-rs"
SRC_URI="https://github.com/Gobidev/pfetch-rs/tarball/10d51507fdddfcd710e7db1b78a8b3bc040bc404 -> pfetch-rs-2.9.2-10d5150.tar.gz
https://direct.funtoo.org/20/53/de/2053ded8f11e6b20a3cfcfc67e6df47d4e2ff39852542089f2c20091731cf4e1e13c53fa6790997967d24935e4eaf096b5f3d6cd7ea01569950cfb7f4cbec83c -> pfetch-rs-2.9.2-funtoo-crates-bundle-961dee03f05c603752a8b83ff6181d8208ff0bdd81d1e28405a280a4aa58947d65497d7569df09f23ed023431a42d57631e7fbb313d77178e2968031e1082a39.tar.gz"
S="${WORKDIR}/Gobidev-pfetch-rs-10d5150"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 ISC LGPL-3+ MIT Apache-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND=""
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="/usr/bin/pfetch-rs"

