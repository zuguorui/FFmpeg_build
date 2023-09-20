#!/bin/bash

# Build FFmpeg fat so library, include libaom, libmp3lame, libfdk-aac, libx264, libx265. This project just for personal use and study.
# You can't use this for buisness usage.

# Based on FFmpeg 6.0, which support av1_mediacodec and Android NDK MediaCodec.

# FFmpeg find libraries by pkg-config. All external libraries are put in ./external-lib. If the library has pc file, I put the pc file
# in ./external-lib/pkgconfig/$CPU/. aom, fdk-aac, x264, x265 are configured this way.
# Some libraries won't build pc file, you can put the include path to cflags and library path to ldflags, such as mp3lame.

# WARNING: If you need link a new library by pkg-config, remember to edit pc file to make sure paths are right.

# WARNING: Please be sure all configure options are available, or the compile will not success. FFmpeg won't ignore wrong or unknown
# options. And don't put comment in a whole line sentence, it can break the sentence and the following configure options will be ignored.

# If any error occured, see log in $FFMPEG_SOURCE_DIR/ffbuild/config.log

# FFmpeg source path.
SOURCE_PATH=/Users/zuguorui/work_space/FFmpeg

# compile toolchain settings

# NDK path
NDK=/Users/zuguorui/Library/Android/sdk/ndk/21.4.7075529

# HOST_TAG associcate with your OS, you can get this in NDK directory, it is the folder name under $NDK/toolchains/llvm/prebuilt.
# darwin-x86_64 for macOS. 
HOST_TAG=darwin-x86_64

TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
SYSROOT=$NDK/toolchains/llvm/prebuilt/$HOST_TAG/sysroot

API=26

# where the build product will be installed
INSTALL_PATH="$(pwd)/android"

# external library path
EXTERNAL_LIB_PATH="$(pwd)/external-lib"

# remove old products.
rm -r $INSTALL_PATH

# cd to FFmpeg source dir.
cd $SOURCE_PATH

make clean

function build_android_arm
{

# lame-mp3 library path
LIB_LAME_PATH=$EXTERNAL_LIB_PATH/lame/android/$CPU/
LAME_INCLUDE_PATH=$EXTERNAL_LIB_PATH/lame/include

echo ">>>>>>>>>>>>>> Compiling FFmpeg for $CPU <<<<<<<<<<<<<<<<<"

# export PKG_CONFIG_PATH to make FFmpeg can find pc files of external libraries.
export PKG_CONFIG_PATH=$PKG_DIR

./configure \
--pkg-config="pkg-config" \
--disable-stripping \
--disable-programs \
--disable-devices \
--disable-avdevice \
--disable-asm \
--disable-doc \
--enable-gpl \
--enable-nonfree \
--enable-version3 \
--disable-static \
--enable-shared \
--enable-small \
--enable-dct \
--enable-dwt \
--enable-lsp \
--enable-mdct \
--enable-rdft \
--enable-fft \
--enable-bsf=h264_mp4toannexb \
--enable-bsf=aac_adtstoasc \
--enable-protocol=rtmp \
--enable-protocol=file \
--enable-libx264 \
--enable-libx265 \
--enable-libfdk-aac \
--enable-libmp3lame \
--enable-libaom \
--prefix="$PREFIX" \
--cross-prefix="$CROSS_PREFIX" \
--target-os=android \
--enable-mediacodec \
--enable-hwaccels \
--enable-jni \
--enable-decoder=av1_mediacodec \
--enable-decoder=h264_mediacodec \
--enable-decoder=hevc_mediacodec \
--enable-decoder=mpeg2_mediacodec \
--enable-decoder=mpeg4_mediacodec \
--enable-decoder=vp8_mediacodec \
--enable-decoder=vp9_mediacodec \
--arch="$ARCH" \
--cpu="$CPU" \
--cc="$CC" \
--cxx="$CXX" \
--enable-cross-compile \
--sysroot="$SYSROOT" \
--extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS -I$LAME_INCLUDE_PATH" \
--extra-ldflags="-L$LIB_LAME_PATH/ -lm -lc++"
make clean
make -j8
make install
echo ">>>>>>>>>>>>>>>>>>>>> Compiling FFmpeg for $CPU is completed <<<<<<<<<<<<<<<<<<<<<"
}

#armv8-a
ARCH=arm64
CPU=armv8-a
CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
PREFIX=$INSTALL_PATH/$CPU
OPTIMIZE_CFLAGS="-march=$CPU"
PKG_DIR=$EXTERNAL_LIB_PATH/pkgconfig/android/$CPU/
echo prefix=$PREFIX, extern_lib_path=$EXTERNAL_LIB_PATH
build_android_arm

#armv7-a
ARCH=arm
CPU=armv7-a
CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$INSTALL_PATH/$CPU
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
PKG_DIR=$EXTERNAL_LIB_PATH/pkgconfig/android/$CPU/
echo prefix=$PREFIX, extern_lib_path=$EXTERNAL_LIB_PATH
build_android_arm




