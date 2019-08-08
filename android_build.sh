#!/bin/bash
# 执行编译时，运行./android_build.sh即可

# 首先执行 settings.sh 脚本 完成基础环境配置
. settings.sh

BASEDIR=$(pwd)
TOOLCHAIN_PREFIX=${BASEDIR}/toolchain-android
# Applying required patches
patch  -p0 -N --dry-run --silent -f fontconfig/src/fcxml.c < android_donot_use_lconv.patch 1>/dev/null
if [ $? -eq 0 ]; then
  patch -p0 -f fontconfig/src/fcxml.c < android_donot_use_lconv.patch
fi

# 根据settings.sh 定义需要平台的cpu类型进行分别编译, 在原文基础上去掉第三方库的编译。
for i in "${SUPPORTED_ARCHITECTURES[@]}"
do
  rm -rf ${TOOLCHAIN_PREFIX}
  # $1 = architecture
  # $2 = base directory
  # $3 = pass 1 if you want to export default compiler environment variables
  #./x264_build.sh $i $BASEDIR 0 || exit 1
  #./libpng_build.sh $i $BASEDIR 1 || exit 1
  #./freetype_build.sh $i $BASEDIR 1 || exit 1
  #./expat_build.sh $i $BASEDIR 1 || exit 1
  #./fribidi_build.sh $i $BASEDIR 1 || exit 1
  #./fontconfig_build.sh $i $BASEDIR 1 || exit 1
  #./libass_build.sh $i $BASEDIR 1 || exit 1
  #./lame_build.sh $i $BASEDIR 1 || exit 1
  ./ffmpeg_build.sh $i $BASEDIR 0 || exit 1
done

rm -rf ${TOOLCHAIN_PREFIX}
