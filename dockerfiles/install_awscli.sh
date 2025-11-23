#!/bin/bash
# Copyright 2025 Advanced Micro Devices, Inc.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set -euo pipefail

ARCH="$(uname -m)"

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
if [ "${ARCH}" = "loongarch64" ]; then
  curl --silent --fail --show-error --location \
    "https://github.com/loong64/aws-cli/releases/latest/download/awscli-exe-linux-${ARCH}.zip" \
    --output "awscliv2.zip"
else
  curl --silent --fail --show-error --location \
    "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" \
    --output "awscliv2.zip"
fi

unzip -qq awscliv2.zip

if [ "$EUID" -ne 0 ]; then
  sudo ./aws/install --update
else
  ./aws/install --update
fi
