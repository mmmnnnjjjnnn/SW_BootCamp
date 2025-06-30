#!/bin/sh

WORK_DIR=$(pwd)
DEFCONFIG="wt2837_defconfig"
IMAGE="arch/arm64/boot/Image"
DTB="arch/arm64/boot/dts/broadcom/wt2837.dtb"
TFTP_DIR="/tftpboot"

build_image() {
    cd $WORK_DIR/linux-6.12.34
    echo "Building Image..."
    make Image -j$(nproc)
    cp "$IMAGE" "$TFTP_DIR/"
    echo "Done"
}

build_dtbs() {
    cd $WORK_DIR/linux-6.12.34
    echo "Building Device Tree..."
    make dtbs -j$(nproc)
    cp "$DTB" "$TFTP_DIR/"
    echo "Done"
}

build_rootfs(){
    cd $WORK_DIR/newrootfs
    echo "Building rootfs..."
    sudo ./mkext2.sh
    cp ext2img.gz "$TFTP_DIR/"
    echo "Done"
}

case "$1" in
    "")
        echo "Full build (defconfig + Image + DTB)"
        make "$DEFCONFIG"
        build_image
        build_dtbs
	# build_rootfs
        ;;
    kernel)
	make "$DEFCONFIG"
        build_image
        ;;
    dtbs)
        build_dtbs
        ;;
    rootfs)
	build_rootfs
	;;
    *)
        echo "Usage: $0 [kernel | dtbs | rootfs]"
        exit 1
        ;;
esac
