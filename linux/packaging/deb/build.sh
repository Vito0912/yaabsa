#!/usr/bin/env bash
set -euo pipefail

app_name="yaabsa"
package_name="yaabsa"
packaging_dir="linux/packaging/deb"
output_dir="output/linux"
icon_path="assets/logo_blue_big_abs.svg"

if [[ -d "build/linux/x64/release/bundle" ]]; then
  bundle_dir="build/linux/x64/release/bundle"
elif [[ -d "build/linux/release/bundle" ]]; then
  bundle_dir="build/linux/release/bundle"
else
  echo "Linux bundle not found. Run flutter build linux --release first."
  exit 1
fi

version="$(awk -F': ' '/^version:/ {print $2; exit}' pubspec.yaml | tr -d '\r')"
if [[ -z "${version}" ]]; then
  echo "Unable to read app version from pubspec.yaml"
  exit 1
fi

arch="amd64"
if [[ "$(uname -m)" == "aarch64" ]]; then
  arch="arm64"
fi

package_root="${packaging_dir}/${app_name}"
debian_dir="${package_root}/DEBIAN"
app_share_dir="${package_root}/usr/share/${app_name}"
applications_dir="${package_root}/usr/share/applications"
icon_128_dir="${package_root}/usr/share/icons/hicolor/128x128/apps"
icon_256_dir="${package_root}/usr/share/icons/hicolor/256x256/apps"

rm -rf "${package_root}"
mkdir -p \
  "${debian_dir}" \
  "${app_share_dir}" \
  "${applications_dir}" \
  "${icon_128_dir}" \
  "${icon_256_dir}" \
  "${output_dir}"

sed \
  -e "s|@VERSION@|${version}|g" \
  -e "s|@ARCH@|${arch}|g" \
  "${packaging_dir}/control.in" > "${debian_dir}/control"

sed \
  -e "s|@VERSION@|${version}|g" \
  "${packaging_dir}/yaabsa.desktop.in" > "${applications_dir}/${app_name}.desktop"

install -Dm755 "${packaging_dir}/postinst" "${debian_dir}/postinst"
install -Dm755 "${packaging_dir}/postrm" "${debian_dir}/postrm"
install -Dm644 "${icon_path}" "${icon_128_dir}/${app_name}.svg"
install -Dm644 "${icon_path}" "${icon_256_dir}/${app_name}.svg"
cp -a "${bundle_dir}/." "${app_share_dir}/"

output_file="${output_dir}/${package_name}_${version}_${arch}.deb"
dpkg-deb --build --root-owner-group "${package_root}" "${output_file}"
rm -rf "${package_root}"

echo "Created ${output_file}"
