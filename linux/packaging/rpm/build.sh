#!/usr/bin/env bash
set -euo pipefail

app_name="yaabsa"
packaging_dir="linux/packaging/rpm"
output_dir="output/linux"
icon_path="assets/logo_blue_fill.svg"

source linux/packaging/arch.sh

bundle_dir="${BUNDLE_DIR}"
if [[ ! -d "${bundle_dir}" ]]; then
  echo "Linux ${LINUX_ARCH} bundle not found: ${bundle_dir}"
  exit 1
fi

full_version="$(awk -F': ' '/^version:/ {print $2; exit}' pubspec.yaml | tr -d '\r')"
if [[ -z "${full_version}" ]]; then
  echo "Unable to read app version from pubspec.yaml"
  exit 1
fi

version="${full_version%%+*}"
release="1"
if [[ "${full_version}" == *"+"* ]]; then
  release="${full_version##*+}"
fi

arch="${RPM_ARCH}"

rpmbuild_dir="${packaging_dir}/rpmbuild"
build_dir="${rpmbuild_dir}/BUILD/${app_name}"
spec_path="${rpmbuild_dir}/SPECS/${app_name}.spec"
rpm_arch_dir="${rpmbuild_dir}/RPMS/${arch}"
topdir="$(pwd)/${rpmbuild_dir}"

rm -rf "${rpmbuild_dir}"
mkdir -p \
  "${rpmbuild_dir}/BUILD" \
  "${rpmbuild_dir}/BUILDROOT" \
  "${rpmbuild_dir}/RPMS" \
  "${rpmbuild_dir}/SOURCES" \
  "${rpmbuild_dir}/SPECS" \
  "${rpmbuild_dir}/SRPMS" \
  "${build_dir}" \
  "${output_dir}"

cp -a "${bundle_dir}/." "${build_dir}/"

if [[ -d "${build_dir}/lib" ]]; then
  for so_file in "${build_dir}"/lib/*.so; do
    [[ -f "${so_file}" ]] || continue
    rpath="$(patchelf --print-rpath "${so_file}" 2>/dev/null || true)"
    if [[ "${rpath}" == *"/home"* ]]; then
      patchelf --set-rpath '$ORIGIN' "${so_file}"
    fi
  done
fi

install -Dm644 "${icon_path}" "${rpmbuild_dir}/BUILD/${app_name}.svg"

sed \
  -e "s|@VERSION@|${version}|g" \
  "${packaging_dir}/${app_name}.desktop.in" > "${rpmbuild_dir}/BUILD/${app_name}.desktop"

changelog_date="$(LC_ALL=C date '+%a %b %d %Y')"
sed \
  -e "s|@VERSION@|${version}|g" \
  -e "s|@RELEASE@|${release}|g" \
  -e "s|@ARCH@|${arch}|g" \
  -e "s|@CHANGELOG_DATE@|${changelog_date}|g" \
  "${packaging_dir}/${app_name}.spec.in" > "${spec_path}"

QA_RPATHS=$((0x0001 | 0x0010)) rpmbuild \
  --define "_topdir ${topdir}" \
  -bb "${spec_path}"

rpm_file="$(find "${rpm_arch_dir}" -maxdepth 1 -type f -name '*.rpm' | head -n 1 || true)"
if [[ -z "${rpm_file}" ]]; then
  echo "RPM output not found in ${rpm_arch_dir}"
  exit 1
fi

cp "${rpm_file}" "${output_dir}/"
rm -rf "${rpmbuild_dir}"

echo "Created ${output_dir}/$(basename "${rpm_file}")"
