 ffmpeg 编译根据github上 WritingMinds/ffmpeg-android编译脚本，进行了修改，添加arm64-v8a平台的编译，
 解决链接是出现的ELF格式不对错误，解决高版本的ndk工具编译导致的链接错误。
 本文采用ffmpeg的版本3.0进行编译成静态库，方便以后跟jni一起打包成动态库。
 如果需要编译成动态库，只需要将 ffmpeg_build.sh 中 --disable-shared 编译选项 改为 --enable-shared即可。
 注意：与JNI其它代码一起封装成动态库是 链接ffmpeg静态库的顺序也很重要，如果出现顺序不对可能导致链接不成功。

Supported Architecture
----
* arm64
* armv7
* armv7-neon
* x86

Instructions
----
* Set environment variable
  1. export ANDROID_NDK={Android NDK Base Path}
* Run following commands to compile ffmpeg
  1. sudo apt-get --quiet --yes install build-essential git autoconf libtool pkg-config gperf gettext yasm python-lxml
  2. ./init_update_libs.sh
  3. ./android_build.sh
* To update submodules and libraries you can use ./init_update_libs.sh command
* Find the executable binary in build directory.
* If you want to use FONTCONFIG then you need to specify your custom fontconfig config file (e.g - "FONTCONFIG_FILE=/sdcard/fonts.conf ./ffmpeg --version", where /sdcard/fonts.conf is location of your FONTCONFIG configuration file).
* You can also download [prebuilt-binaries.zip](https://github.com/hiteshsondhi88/ffmpeg-android/releases/download/v0.3.3/prebuilt-binaries.zip) [prebuilt-binaries.tar.gz](https://github.com/hiteshsondhi88/ffmpeg-android/releases/download/v0.3.3/prebuilt-binaries.tar.gz) here.

License
----
  check files LICENSE.GPLv3 and LICENSE






