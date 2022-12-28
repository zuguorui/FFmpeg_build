This is FFmpeg so library compiled for Android, and integrate with mp3lame, aom, fdk-aac, x264, x265. This is full function build, so the size of library is a little big.

Compile script is `build_for_android_fat.sh`. `build_for_android.sh` is intent to build a clipped library, but not tested. You can edit it refer to `build_for_android_fat.sh` if you need.

> WARNING: This build integrate with libraries under GPL license and no free, so you can't use it for business usage. Just for personal study.

## 0. My compile environment

FFmpeg 4.4

macOS arm64

NDK 21.4.7075529, api = 26


## 1. Preparation

- Download FFmpeg source code.
- Download NDK.
- Ensure `pkg-config` and `cmake` are installed on your computer.

## 2. User guide

All environment variables are set in `build_for_android_fat.sh`. So the main job is to edit them in script.

- Download this folder to any place on your computer.
- Open `build_for_android_fat.sh` for editting.
- Set `SOURCE_PATH` to your FFmpeg source code path.
- Set `NDK` to your NDK path.
- Set `HOST_TAG` according to your OS. This is actually the name of a folder under `$NDK/toolchains/llvm/prebuilt`. Just open your NDK folder and follow the path then you can get it. This var is used to compose toolchain path.
- Open `pc` files in `external-lib/pkgconfig/android/$CPU` and edit `my_prefix` to the path of this folder.
- Run `build_for_android_fat.sh`. If succeed, all products will put in `android/$CPU`. If failed, you can see log `ffbuild/config.log` in FFmpeg source dir.

## 3. Link new library

If there is new external library you want integrate into FFmpeg, you need compile the external library yourself. If the library build a `pc` file, you can put in `external-lib/pkgconfig/android/$CPU` because this dir will be exported as 
`PKG_CONFIG_PATH`, which will result that `pkg-config` will find `pc` files only in this folder.

If no `pc` file, you can put the include and link flag to cflags and ldflags just as mp3lame.

I recommend all external libraries should be put in same form.



