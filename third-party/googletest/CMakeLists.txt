# Copyright Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

therock_subproject_fetch(therock-googletest-sources
  CMAKE_PROJECT
  # Original URL: https://github.com/google/googletest/releases/download/v1.17.0/googletest-1.17.0.tar.gz
  URL https://rocm-third-party-deps.s3.us-east-2.amazonaws.com/googletest-1.17.0.tar.gz
  URL_HASH SHA256=65fab701d9829d38cb77c14acdc431d2108bfdbf8979e40eb8ae567edf10b27c
)

# GCC on loongarch64 otherwise emits exception tables that LLD cannot link
# when COMDAT sections are discarded by test executables.
set(_googletest_arch_args)
if(CMAKE_SYSTEM_PROCESSOR STREQUAL "loongarch64")
  list(APPEND _googletest_arch_args "-DCMAKE_CXX_FLAGS=-ffunction-sections -fdata-sections")
endif()

therock_cmake_subproject_declare(therock-googletest
  USE_DIST_AMDGPU_TARGETS
  BACKGROUND_BUILD
  EXCLUDE_FROM_ALL
  NO_MERGE_COMPILE_COMMANDS
  OUTPUT_ON_FAILURE
  EXTERNAL_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/source"
  CMAKE_ARGS
    -Dgtest_force_shared_crt=ON
    ${_googletest_arch_args}
)
therock_cmake_subproject_provide_package(therock-googletest GTest lib/cmake/GTest)
therock_cmake_subproject_activate(therock-googletest)
