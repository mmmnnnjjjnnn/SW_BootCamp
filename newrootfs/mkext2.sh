SIZE=131072
rm -f ext2img.gz
mkdir tmp_ext2img

echo "# Filling zero to ext2img using dd"
dd if=/dev/zero of=ext2img bs=1k count=$SIZE

echo "# Making ext2 filesystem using mkfs"
if ! /sbin/mkfs -t ext2 ext2img
then
    echo "Please answer yes to the above question."
    exit 1
fi

echo "# Mounting ext2img to tmp_ext2img"
mount -o loop -t ext2 ext2img tmp_ext2img

echo "# Copying all files to tmp_ext2img"
cd rootfs 
find . -print0 | cpio -p0dm ../tmp_ext2img
cd ../
umount tmp_ext2img

echo "# Compressing ext2img"
gzip -v ext2img

rmdir tmp_ext2img

echo "# ext2img.gz was made successfully"
