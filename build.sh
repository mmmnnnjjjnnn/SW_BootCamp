#!/bin/sh

# 설정 변수
DEFCONFIG="wt2837_defconfig"
IMAGE="arch/arm64/boot/Image"
DTB="arch/arm64/boot/dts/broadcom/wt2837.dtb"
TFTP_DIR="/tftpboot"

# 공통 함수
build_image() {
    echo "Building Image..."
    make Image -j$(nproc)
}

build_dtbs() {
    echo "Building Device Tree..."
    make dtbs -j$(nproc)
}

copy_to_tftp() {
    echo "Copying files to $TFTP_DIR..."
    sudo cp "$IMAGE" "$TFTP_DIR/"
    sudo cp "$DTB" "$TFTP_DIR/"
    echo "Done."
}

cd linux-6.12.34
case "$1" in
    "")
        echo "Full build (defconfig + Image + DTB)"
        make "$DEFCONFIG"
        build_image
        build_dtbs
        copy_to_tftp
        ;;
    kernel)
	make "$DEFCONFIG"
        build_image
        echo "Copying Image to $TFTP_DIR..."
        sudo cp "$IMAGE" "$TFTP_DIR/"
        echo "Done."
        ;;
    dtbs)
        build_dtbs
        echo "Copying DTB to $TFTP_DIR..."
        sudo cp "$DTB" "$TFTP_DIR/"
        echo "Done."
        ;;
    *)
        echo "Usage: $0 [kernel | dtbs]"
        exit 1
        ;;
esac
