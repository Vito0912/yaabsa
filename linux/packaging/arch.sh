#!/usr/bin/env bash

case "$(uname -m)" in
  x86_64)
    FLUTTER_ARCH="x64"
    LINUX_ARCH="x86_64"
    DEB_ARCH="amd64"
    RPM_ARCH="x86_64"
    ;;
  aarch64|arm64)
    FLUTTER_ARCH="arm64"
    LINUX_ARCH="aarch64"
    DEB_ARCH="arm64"
    RPM_ARCH="aarch64"
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

BUNDLE_DIR="build/linux/${FLUTTER_ARCH}/release/bundle"
