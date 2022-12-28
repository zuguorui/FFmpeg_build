为Android编译的FFmpeg动态链接库，配置中包含mp3lame、aom、fdk-aac、x264、x265。该编译为全功能编译，所以库体积比较大。

编译使用脚本`build_for_android_fat.sh`。
`build_for_android.sh`是剪裁库脚本，但是未经过验证。如果需要，可以参考`build_for_android_fat.sh`进行修改。

> 警告：该编译由于集成了lame、fdk-aac等GPL协议下的库，因此不可作为商用，只供个人学习。

## 0. 编译环境

FFmpeg 4.4

macOS arm64

NDK 21.4.7075529，api = 26


以上是我本人的编译环境。其他条件应该可以正常编译。

## 1. 准备工作

- 下载FFmpeg源码。
- 下载NDK。
- 确认电脑安装了`pkg-config`和`cmake`。

## 2. 使用方法

所有环境设置都是直接写在`build_for_android_fat.sh`中的，因此配置主要是更改脚本中的路径。

- 将此文件夹放在任意地方。不过路径最好不要包括中文。
- 打开`build_for_android_fat.sh`。
- 将`SOURCE_PATH`设置为你自己的FFmpeg源码存放目录。
- 将`NDK`设置为你自己的NDK存放目录。
- 根据自己的系统，设置`HOST_TAG`，这个变量实际上是一个目录名称，该目录就位于`$NDK/toolchains/llvm/prebuilt`下，意义不大，顺着目录查看一下就可以。
- 依次打开`external-lib/pkgconfig/android/$CPU`下的各`pc`文件，修改`my_prefix`确保指向了当前文件夹。
- 执行`build_for_android_fat.sh`。编译结果会存放在`android/$CPU`文件夹下。如果没成功，查看FFmpeg源码文件夹下的`ffbuild/config.log`。

## 3. 链接新的库

如果你有其他的第三方库需要集成到FFmpeg中，需要先将第三方库编译为so库，如果该库有`pc`文件，那么将`pc`文件存放在`external-lib/pkgconfig/android/$CPU`下，因为编译脚本会将此文件导出到`PKG_CONFIG_PATH`环境变量。使得`pkg-config`只会在该文件夹下寻找`pc`文件。

如果库没有`pc`文件，那么就在`build_for_android_fat.sh`为cflags和ldflags设置正确的标志位，可以参考mp3lame的集成方式。

建议第三方库和头文件的存放方式都统一。




