#!/bin/bash

default="./configure \
				--disable-ffplay \
				--disable-doc \
				--disable-debug\
				--enable-static \
				--enable-cuda-nvcc \
				--enable-nonfree \
				--enable-libnpp \
				--enable-gpl \
        --enable-version3 \
        --enable-small \
        --enable-chromaprint \
        --enable-frei0r \
				--enable-gmp \
				--enable-gnutls \
        --enable-ladspa \
        --enable-libaom \
        --enable-libass \
        --enable-libcaca \
				--enable-libcdio \
        --enable-libcodec2 \
				--enable-libfdk-aac \
				--enable-libfontconfig \
        --enable-libfreetype \
				--enable-libfribidi \
        --enable-libgme \
				--enable-libgsm \
				--enable-libjack \
        --enable-libmp3lame \
        --enable-libopencore-amrnb \
				--enable-libopencore-amrwb \
        --enable-libopencore-amrwb \
				--enable-libopenjpeg \
        --enable-libopenmpt \
				--enable-libopus \
        --enable-libpulse \
				--enable-librsvg \
        --enable-librubberband \
				--enable-librtmp \
        --enable-libshine \
        --enable-libsnappy \
				--enable-libsoxr \
        --enable-libspeex \
				--enable-libssh \
        --enable-libtesseract \
				--enable-libtheora \
        --enable-libtwolame \
				--enable-libv4l2 \
        --enable-libvo-amrwbenc \
				--enable-libvorbis \
        --enable-libvpx \
				--enable-libwavpack \
        --enable-libwebp \
				--enable-libx264 \
        --enable-libx265 \
				--enable-libxvid \
        --enable-libxml2 \
				--enable-libzmq \
        --enable-libzvbi \
				--enable-lv2 \
        --enable-libmysofa \
				--enable-openal \
        --enable-opencl \
				--enable-opengl \
				--enable-vulkan \
        --enable-libdrm \
"

helper() {
    echo "Usage: idiot_proof [platform]"
		echo
    echo "A script to build the ffmpeg static binaries for JumpCutter"
		echo
		echo "    -p: -p <mac|win32|linux|all>                      Sets the platform for the static build"
		echo "    --platform: --platform=<mac|win32|linux|all>      Sets the platform for the static build"
		echo "    -h: -h                                            Shows this page"
		echo "    --help: --help                                    Shows this page"
}

win_configure() {
	eval "$default --arch=x86_64 \
								 --target-os=mingw32 \
								 --cross-prefix=x86_64-w64-mingw32- \
								 --pkg-config=pkg-config \
								 --extra-cflags=-I/usr/local/include \
								 --extra-ldflags=-L/usr/local/cuda/v10.0/lib/x64/
									 "
}
mac_configure() {
	eval "$default --enable-videotoolbox"
}

linux_configure() {
	eval "$default"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -p) if [[ -z $2 ]]; then
                echo "e must have an input value"
                exit 1
            else
                EXTENSION="$2"
                shift 2
            fi
            ;;
        --platform=*) EXTENSION="${i#*=}"
            shift
            ;;
        -h|--help) helper; exit;;
        *) echo "unknown input $1"; exit 2;;
    esac
done

if [[ -z $EXTENSION ]]; then
	echo need to specify platform
	exit 2
fi

case "$EXTENSION" in
	win32)
		echo "windows lame"
		win_configure
		;;
	mac)
		echo "mac is lame"
		mac_configure
		;;
	linux)
		echo "Linux master race"
		linux_configure
		;;
	all)
		echo "oh god get ready for the compile time"
		;;
	*)
		echo "Usage: ./idiot_proof.sh -p <mac|win32|linux|all>"
esac
