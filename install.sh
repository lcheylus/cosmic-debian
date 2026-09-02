#!/bin/sh
set -eu

for cmd in curl jq; do
	if ! command -v "${cmd}" > /dev/null 2>&1; then
		echo "ERROR: required command '${cmd}' is not installed or not in PATH."
		exit 1
	fi
done

# Install COSMIC applications - Yes by default
INSTALL_APPS="${INSTALL_APPS:-1}"

# Keep Debian packages after installation - No by default
KEEP="${KEEP:-0}"

# Git tag for "COSMIC depends" release
DEPENDS_TAG="depends-20260808"

# COSMIC applications
APPS="cosmic-edit cosmic-files cosmic-monitor cosmic-player cosmic-store cosmic-term"

tmp_dir=$(mktemp -d -t cosmic-release-XXX)

echo "[*] Download .deb files for the latest release in directory ${tmp_dir}"

# Get URL for each .deb file for the latest release
curl -fsSL "https://api.github.com/repos/lcheylus/cosmic-debian/releases/latest" |
	jq -r '.assets[].browser_download_url' |
	grep '\.deb$' |
	while IFS= read -r url; do
		echo "[*] Download $(basename "${url}")"
		curl -fLO --progress-bar "${url}" --output-dir "${tmp_dir}"
	done

# Check downloaded files with SHA256SUMS file
sha256sums_url=$(curl -fsSL "https://api.github.com/repos/lcheylus/cosmic-debian/releases/latest" |
	jq -r '.assets[].browser_download_url' |
	grep 'SHA256SUMS')

curl -fsSLO "${sha256sums_url}" --output-dir "${tmp_dir}"
cd "${tmp_dir}"
sha256sum --quiet -c SHA256SUMS

# Move Debian packages for COSMIC apps in a dedicated directory
mkdir -p "${tmp_dir}/apps"
for app in ${APPS}; do
	mv "$(find "${tmp_dir}" -type f -name "${app}_*.deb" -print)" "${tmp_dir}/apps/"
done

# Download COSMIC depends
depends_dir=$(mktemp -d -t cosmic-depends-XXX)

echo
echo "[*] Download .deb files for COSMIC depends in directory ${depends_dir}"

curl -fsSL "https://api.github.com/repos/lcheylus/cosmic-debian/releases/tags/${DEPENDS_TAG}" |
	jq -r '.assets[].browser_download_url' |
	grep '\.deb$' |
	while IFS= read -r url; do
		echo "[*] Download $(basename "${url}")"
		curl -fLO --progress-bar "${url}" --output-dir "${depends_dir}"
	done

# Check downloaded files with SHA256SUMS file
sha256sums_url=$(curl -fsSL "https://api.github.com/repos/lcheylus/cosmic-debian/releases/tags/${DEPENDS_TAG}" |
	jq -r '.assets[].browser_download_url' |
	grep 'SHA256SUMS')
curl -fsSLO "${sha256sums_url}" --output-dir "${depends_dir}"

cd "${depends_dir}"
sha256sum --quiet -c SHA256SUMS

echo
echo "[*] Install Debian packages needed as Depends by COSMIC components/apps"
apt install -y accountsservice acpid adduser apt-config-icons apt-config-icons-hidpi \
	apt-config-icons-large apt-config-icons-large-hidpi dbus fd-find fonts-open-sans \
	gettext gnome-keyring iso-codes libegl1 libsecret-1-0 libwayland-server0 \
	network-manager-applet network-manager-openvpn network-manager-openvpn-gnome \
	pulseaudio-utils qalc switcheroo-control xkb-data xwayland \
	flatpak libflatpak0 greetd

echo
echo "[*] Install COSMIC depends from directory ${depends_dir}"
cd "${depends_dir}"
dpkg -i ./*.deb

echo
echo "[*] Install COSMIC components from directory ${tmp_dir}"
cd "${tmp_dir}"
dpkg -i ./*.deb

if [ "${INSTALL_APPS}" -eq 1 ]; then
	echo
	echo "[*] Install COSMIC apps from directory ${tmp_dir}/apps"
	cd "${tmp_dir}/apps"
	dpkg -i ./*.deb
fi

if [ "${KEEP}" -ne 1 ]; then
	echo
	echo "[*] Remove downloaded Debian packages to install COSMIC"
	rm -rf "${depends_dir}"
	rm -rf "${tmp_dir}"
fi
