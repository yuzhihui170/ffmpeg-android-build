#!/bin/bash
# 定义Android NDK目录 测试使用的NDK版本为17，此处需要用户进行安装直接NDK工具目录进行修改
ANDROID_NDK=/Users/who/Library/Android/ndk-bundle
# 需要的eabi类型，一般有arm32位和 arm64位即可满足大部分的需求
SUPPORTED_ARCHITECTURES=(arm64-v8a armeabi-v7a)
#SUPPORTED_ARCHITECTURES=(arm64-v8a armeabi-v7a armeabi-v7a-neon x86)
ANDROID_NDK_ROOT_PATH=${ANDROID_NDK}
if [[ -z "$ANDROID_NDK_ROOT_PATH" ]]; then
  echo "You need to set ANDROID_NDK environment variable, please check instructions"
  exit
fi
# 定义支持的Android版本，此处最小支持到21，即Android5.0
ANDROID_API_VERSION=21
NDK_TOOLCHAIN_ABI_VERSION=4.9

NUMBER_OF_CORES=$(nproc)
HOST_UNAME=$(uname -m)
TARGET_OS=android
# 此处定义编译选项，在原文基础上添加-D__ANDROID_API__=21，解决在高版本的NDK编译过程中出现链接错误的问题
CFLAGS='-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fno-strict-overflow -fstack-protector-all -D__ANDROID_API__=21'
LDFLAGS='-Wl,-z,relro -Wl,-z,now -pie'

FFMPEG_PKG_CONFIG="$(pwd)/ffmpeg-pkg-config"
