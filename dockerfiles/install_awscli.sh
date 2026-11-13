#!/bin/bash
# Copyright 2025 Advanced Micro Devices, Inc.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set -euo pipefail

AWSCLI_VERSION="${1:-2.36.7}"
ARCH="$(uname -m)"
AWSCLI_URL_BASE="https://awscli.amazonaws.com"
case "${AWSCLI_VERSION}:${ARCH}" in
    2.36.7:x86_64)
        AWSCLI_SHA256="d641283d37f1a2168457a9f26a20d4e29167652e9ab1719b37114ef1ebe859f4"
        ;;
    2.36.7:aarch64)
        AWSCLI_SHA256="85826b67912b44bb45d1e46c6e66f383c14405ee0b2f4686f73bdf949c93bd61"
        ;;
    2.36.7:loongarch64)
        AWSCLI_SHA256="54f043b7795cc0adae2192454f3220900866f7b94067d9d071f12ff164fed2e6"
        AWSCLI_URL_BASE="https://github.com/loong64/aws-cli/releases/download/${AWSCLI_VERSION}"
        ;;
    *)
        echo "Unsupported AWS CLI version/architecture: ${AWSCLI_VERSION}/${ARCH}" >&2
        exit 1
        ;;
esac

AWSCLI_ARCHIVE="awscli-exe-linux-${ARCH}-${AWSCLI_VERSION}.zip"
if [ "${ARCH}" = "loongarch64" ]; then
    AWSCLI_ARCHIVE="awscli-exe-linux-${ARCH}.zip"
fi

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
curl --silent --fail --show-error --location \
    "${AWSCLI_URL_BASE}/${AWSCLI_ARCHIVE}" \
    --output "${AWSCLI_ARCHIVE}"

printf '%s  %s\n' "${AWSCLI_SHA256}" "${AWSCLI_ARCHIVE}" | sha256sum --check --strict

unzip -qq "${AWSCLI_ARCHIVE}"

if [ "$EUID" -ne 0 ]; then
  sudo ./aws/install --update
else
  ./aws/install --update
fi
