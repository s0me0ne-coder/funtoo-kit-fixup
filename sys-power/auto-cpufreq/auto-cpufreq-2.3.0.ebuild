# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_10 )

DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="Automatic CPU speed & power optimizer for Linux"
HOMEPAGE="https://github.com/AdnanHodzic/auto-cpufreq"
SRC_URI="https://github.com/AdnanHodzic/auto-cpufreq/tarball/78c3f7143883cb7c19fbcc67c9883dfc97bc8a8e -> auto-cpufreq-2.3.0-78c3f71.tar.gz"
S="${WORKDIR}/AdnanHodzic-auto-cpufreq-78c3f71"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="next"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

DOCS=( README.md )
PATCHES=( "${FILESDIR}/${PN}-remove-poetry_versioning.patch" )

src_prepare() {
	sed -i 's|usr/local|usr|g' "scripts/${PN}.service" "scripts/${PN}-openrc" auto_cpufreq/core.py || die
	sed -i 's|usr/local|usr|g' "scripts/${PN}.service" "scripts/${PN}-openrc" auto_cpufreq/gui/app.py || die
	distutils-r1_src_prepare
}

python_install() {
	distutils-r1_python_install

	exeinto "/usr/share/${PN}/scripts"
	doexe scripts/cpufreqctl.sh

	insinto "/usr/share/${PN}/scripts"
	doins scripts/style.css

	insinto "/usr/share/${PN}/images"
	doins images/*

	newinitd "scripts/${PN}-openrc" "${PN}"
}

pkg_postinst() {
	touch /var/log/auto-cpufreq.log

	elog ""
	elog "Enable auto-cpufreq daemon service at boot:"
	elog "rc-update add auto-cpufreq default"
	elog ""
	elog "To view live log, run:"
	elog "auto-cpufreq --stats"
}

pkg_postrm() {
	# Remove auto-cpufreq log file
	if [ -f "/var/log/auto-cpufreq.log" ]; then
		rm /var/log/auto-cpufreq.log || die
	fi

	# Remove auto-cpufreq's cpufreqctl binary
	# it overwrites cpufreqctl.sh
	if [ -f "/usr/bin/cpufreqctl" ]; then
		rm /usr/bin/cpufreqctl || die
	fi

	# Restore original cpufreqctl binary if backup was made
	if [ -f "/usr/bin/cpufreqctl.auto-cpufreq.bak" ]; then
		mv /usr/bin/cpufreqctl.auto-cpufreq.bak /usr/bin/cpufreqctl || die
	fi
}