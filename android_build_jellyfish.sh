#!/bin/bash

ANDROID_NDK=/Users/who/Library/Android/ndk-bundle
#SUPPORTED_ARCHITECTURES=(armeabi-v7a)
SUPPORTED_ARCHITECTURES=(arm64-v8a)

ANDROID_NDK_ROOT_PATH=${ANDROID_NDK}
if [[ -z "$ANDROID_NDK_ROOT_PATH" ]]; then
  echo "You need to set ANDROID_NDK environment variable, please check instructions"
  exit
fi
ANDROID_API_VERSION=21
NDK_TOOLCHAIN_ABI_VERSION=4.9

NUMBER_OF_CORES=4
HOST_UNAME=$(uname -m)
TARGET_OS=android

CFLAGS='-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fno-strict-overflow -fstack-protector-all -D__ANDROID_API__=21'
LDFLAGS='-Wl,-z,relro -Wl,-z,now -pie'

#########################################################################################################

BASEDIR=$(pwd)
TOOLCHAIN_PREFIX=${BASEDIR}/toolchain-android

case ${SUPPORTED_ARCHITECTURES} in
  armeabi-v7a)
    NDK_ABI='arm'
    NDK_TOOLCHAIN_ABI='arm-linux-androideabi'
    NDK_CROSS_PREFIX="${NDK_TOOLCHAIN_ABI}"
  ;;
  armeabi-v7a-neon)
    NDK_ABI='arm'
    NDK_TOOLCHAIN_ABI='arm-linux-androideabi'
    NDK_CROSS_PREFIX="${NDK_TOOLCHAIN_ABI}"
    CFLAGS="${CFLAGS} -mfpu=neon"
  ;;
  arm64-v8a)
    NDK_ABI='aarch64'
    NDK_TOOLCHAIN_ABI='aarch64-linux-android'
    NDK_CROSS_PREFIX="${NDK_TOOLCHAIN_ABI}"
  ;;
  x86)
    NDK_ABI='x86'
    NDK_TOOLCHAIN_ABI='x86'
    NDK_CROSS_PREFIX="i686-linux-android"
    CFLAGS="$CFLAGS -march=i686"
  ;;
esac

rm -rf ${TOOLCHAIN_PREFIX}
if [ ! -d "$TOOLCHAIN_PREFIX" ]; then
  ${ANDROID_NDK_ROOT_PATH}/build/tools/make-standalone-toolchain.sh --toolchain=${NDK_TOOLCHAIN_ABI}-${NDK_TOOLCHAIN_ABI_VERSION} --platform=android-${ANDROID_API_VERSION} --install-dir=${TOOLCHAIN_PREFIX}
fi

CROSS_PREFIX=${TOOLCHAIN_PREFIX}/bin/${NDK_CROSS_PREFIX}-
NDK_SYSROOT=${TOOLCHAIN_PREFIX}/sysroot

echo "CROSS_PREFIX = ${CROSS_PREFIX}"
echo "NDK_SYSROOT = ${NDK_SYSROOT}"
echo "NDK_ABI = ${NDK_ABI}"
echo "NDK_TOOLCHAIN_ABI = ${NDK_TOOLCHAIN_ABI}"
echo "NDK_CROSS_PREFIX = ${NDK_CROSS_PREFIX}"

pushd ffmpeg

# 删除这两行 这两个文件不会重编，导致切换平台时ELF错误
rm -rf compat/strtod.d
rm -rf compat/strtod.o 

case ${SUPPORTED_ARCHITECTURES} in
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
  ;;
  arm64-v8a)
	CPU='armv8-a'
  ;;
  x86)
    CPU='i686'
  ;;
esac

make clean
./configure \
--target-os="$TARGET_OS" \
--cross-prefix="$CROSS_PREFIX" \
--arch="$NDK_ABI" \
--cpu="$CPU" \
--enable-runtime-cpudetect \
--sysroot="$NDK_SYSROOT" \
--disable-everything \
--enable-decoder="h264" \
--enable-muxer="mp4" \
--enable-parser="h264" \
--enable-protocol="file" \
--enable-pic \
--enable-pthreads \
--disable-debug \
--enable-version3 \
--enable-hardcoded-tables \
--disable-programs \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--enable-gpl \
--enable-yasm \
--disable-doc \
--disable-shared \
--enable-static \
--prefix="${BASEDIR}/build/${SUPPORTED_ARCHITECTURES}" \
--extra-cflags="-I${TOOLCHAIN_PREFIX}/include $CFLAGS" \
--extra-ldflags="-L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
--extra-cxxflags="$CXX_FLAGS" || exit 1

make -j4 && make install || exit 1
popd
