#!/bin/bash

BASEDIR="/home/hd-/codina"
INITRAMFSDIR="$BASEDIR/ramdisk"
OUT="$BASEDIR/myfile"
BUILDVERSION="eX-Kernel_v1.7"

echo "eX Kernel Build Script by hafidzduddin"
sleep 3

echo "Building eX Kernel"

echo "Clean up Source"
rm -rf ${INITRAMFSDIR}/lib/modules/2.6.35.7/kernel
rm $OUT/kernel.bin.md5
rm $OUT/*.txt
rm $OUT/*.tar.md5

cd ~/codina/kernel

echo "Exporting defconfig"
make  ex-kernel_defconfig
echo "Build Version : $1"
echo "1" > .version 

echo "Compiling Kernel"

make -j3

echo "Compiling Modules"

make -j3 modules

echo "Copy modules to initramfs"

		echo -e "\n\n Copying Modules to InitRamFS Folder...\n\n"
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/bluetooth/bthid
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/net/wireless/bcm4330
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/j4fs
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/param
		mkdir -p $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/scsi

		cp drivers/bluetooth/bthid/bthid.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/bluetooth/bthid/bthid.ko
		cp drivers/net/wireless/bcm4330/dhd.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/net/wireless/bcm4330/dhd.ko
		cp drivers/samsung/param/param.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/param/param.ko
		cp drivers/scsi/scsi_wait_scan.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/scsi/scsi_wait_scan.ko
		cp drivers/samsung/j4fs/j4fs.ko $INITRAMFSDIR/lib/modules/2.6.35.7/kernel/drivers/samsung/j4fs/j4fs.ko

cd ../ramdisk/lib/modules/2.6.35.7

echo "Strip modules for size"

for m in $(find . | grep .ko | grep './')
do
	echo $m

/home/hd-/Toolchains/arm-2009q3/bin/arm-none-eabi-strip --strip-unneeded $m
done

cd ~/codina/kernel

echo "initramfs ready!"

echo "Building zImage"
make -j3 zImage


echo "Setting up zImage for I8160"

cp arch/arm/boot/zImage $OUT/zImage

cd $OUT

mv zImage kernel.bin
md5sum -t kernel.bin >> kernel.bin
mv kernel.bin kernel.bin.md5
md5sum kernel.bin.md5 > md5sum_$BUILDVERSION$6.txt
tar cf $BUILDVERSION.tar kernel.bin.md5
md5sum -t $BUILDVERSION.tar >> $BUILDVERSION.tar
mv $BUILDVERSION.tar $BUILDVERSION.tar.md5

echo "md5sum is-"

cat md5sum_$BUILDVERSION$6.txt

echo "all done"
