#!/bin/bash
# Copyright 2022 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set -euo pipefail

NINJA_VERSION="$1"

ARCH="$(uname -m)"
NINJA_REPO="ninja-build/ninja"
NINJA_ASSET="ninja-linux.zip"
case "${NINJA_VERSION}:${ARCH}" in
    1.12.1:x86_64)
        NINJA_SHA256="6f98805688d19672bd699fbbfa2c2cf0fc054ac3df1f0e6a47664d963d530255"
        ;;
    1.12.1:loongarch64)
        NINJA_SHA256="9676bcd377084285ec592ff3adb38cafc2b1453e690d148500b81ea4b93dd55a"
        NINJA_REPO="loong64/ninja"
        NINJA_ASSET="ninja-linux-loongarch64.zip"
        ;;
    *)
        echo "Unsupported Ninja version/architecture: ${NINJA_VERSION}/${ARCH}" >&2
        exit 1
        ;;
esac

NINJA_ARCHIVE="ninja-${NINJA_VERSION}-linux.zip"
curl --silent --fail --show-error --location \
    "https://github.com/${NINJA_REPO}/releases/download/v${NINJA_VERSION}/${NINJA_ASSET}" \
    --output "${NINJA_ARCHIVE}"

printf '%s  %s\n' "${NINJA_SHA256}" "${NINJA_ARCHIVE}" | sha256sum --check --strict

unzip "${NINJA_ARCHIVE}"
cp ninja /usr/local/bin
