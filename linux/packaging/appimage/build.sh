#!/usr/bin/env bash
set -euo pipefail

app_name="yaabsa"
packaging_dir="linux/packaging/appimage"
output_dir="output/linux"
icon_path="assets/logo_blue_big_abs.svg"
extra_shared_objects=("libmpv.so.2")

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

app_dir="${packaging_dir}/${app_name}.AppDir"
output_file="${output_dir}/${app_name}-${version}-x86_64.AppImage"

rm -rf "${app_dir}"
mkdir -p "${output_dir}"
cp -a "${bundle_dir}" "${app_dir}"

install -Dm644 "${packaging_dir}/${app_name}.desktop" "${app_dir}/${app_name}.desktop"
install -Dm755 "${packaging_dir}/AppRun" "${app_dir}/AppRun"
install -Dm644 "${icon_path}" "${app_dir}/${app_name}.svg"
install -Dm644 "${icon_path}" "${app_dir}/usr/share/icons/hicolor/128x128/apps/${app_name}.svg"
install -Dm644 "${icon_path}" "${app_dir}/usr/share/icons/hicolor/256x256/apps/${app_name}.svg"

mkdir -p "${app_dir}/usr/lib"

flutter_gtk_lib="${app_dir}/lib/libflutter_linux_gtk.so"
if [[ ! -f "${flutter_gtk_lib}" ]]; then
  echo "Missing ${flutter_gtk_lib} in built bundle"
  exit 1
fi

readarray -t flutter_deps < <(ldd -d "${flutter_gtk_lib}" | awk '/=>/ && $1 ~ /^lib/ && $3 ~ /^\// {print $3}' | sort -u)

is_default_shared_object() {
  case "$1" in
    libapp.so|libflutter_linux_gtk.so|libgtk-3.so.0)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

contains_flutter_dep() {
  local dep="$1"
  local flutter_dep
  for flutter_dep in "${flutter_deps[@]}"; do
    if [[ "${dep}" == "${flutter_dep}" ]]; then
      return 0
    fi
  done
  return 1
}

resolve_shared_object_path() {
  local so_name="$1"
  local so_path

  so_path="$(ldconfig -p | awk -v so="${so_name}" '$1 == so {print $NF; exit}')"
  if [[ -n "${so_path}" && -f "${so_path}" ]]; then
    printf '%s\n' "${so_path}"
    return 0
  fi

  so_path="$(find /usr/lib /lib -type f -name "${so_name}" 2>/dev/null | head -n 1 || true)"
  if [[ -n "${so_path}" && -f "${so_path}" ]]; then
    printf '%s\n' "${so_path}"
    return 0
  fi

  return 1
}

for so in "${app_dir}"/lib/*; do
  [[ -f "${so}" ]] || continue

  so_name="$(basename "${so}")"
  if is_default_shared_object "${so_name}"; then
    continue
  fi

  while IFS= read -r dep; do
    [[ -n "${dep}" ]] || continue
    [[ "${dep}" == *"libflutter_linux_gtk.so"* ]] && continue
    contains_flutter_dep "${dep}" && continue
    cp "${dep}" "${app_dir}/usr/lib/"
  done < <(ldd -d "${so}" | awk '/=>/ && $1 ~ /^lib/ && $3 ~ /^\// {print $3}' | sort -u)
done

for so_name in "${extra_shared_objects[@]}"; do
  if ! so_path="$(resolve_shared_object_path "${so_name}")"; then
    echo "Unable to locate required shared object: ${so_name}"
    exit 1
  fi
  cp "${so_path}" "${app_dir}/usr/lib/"
done

ARCH=x86_64 appimagetool --no-appstream "${app_dir}" "${output_file}"
rm -rf "${app_dir}"

echo "Created ${output_file}"
