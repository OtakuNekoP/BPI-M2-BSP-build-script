#!/bin/bash
# (c) 2015, Leo Xu <otakunekop@banana-pi.org.cn>
# Build script for BPI-M2-BSP 2015.07.29

cp_download_files()
{
	. ./chosen_board.mk
	local pack_out=output/$BOARD/pack
	local download=download/$BOARD

	rm -rf $download
	mkdir -p $download/lib/modules

	cp $pack_out/boot0_sdcard.fex $download/
        cp $pack_out/u-boot.fex $download/
        cp $pack_out/sunxi_mbr.fex $download/
        cp $pack_out/bootloader.fex $download/
        cp $pack_out/env.fex $download/
        cp $pack_out/boot.fex $download/
        cp -r linux-sunxi/output/lib/modules/3.3.0-BPI-M2-Kernel $download/lib/modules/
        cp -ir linux-sunxi/firmware/ap6181/*.* $download/lib/modules/3.3.0-BPI-M2-Kernel
}

echo "=========================================="
echo -e "\033[41;37m            BPI-M2 BSP Build Tool         \033[0m"
echo "=========================================="
echo
echo "This tool support following BPI board(s):"
echo "------------------------------------------"
echo "	1. BPI_M2_720P"
echo "	2. BPI_M2_1080P"
echo "	3. BPI_M2_LCD7"
echo "	4. BPI_M2_USB_720P"
echo "	5. BPI_M2_USB_1080P"
echo "	6. BPI_M2_USB_LCD7"
echo "------------------------------------------"

read -p "Please choose a target(1-6): " board
echo

if [ -z "$board" ]; then
	echo -e "\033[31m No target choose, using BPI_M2_720P default   \033[0m"
	board=1
fi

echo
echo -e "\033[31m Now configuring...\033[0m"
echo
case $board in
	1) ./configure BPI_M2_720P;;
	2) ./configure BPI_M2_1080P;;
	3) ./configure BPI_M2_LCD7;;
	4) ./configure BPI_M2_USB_720P;;
	5) ./configure BPI_M2_USB_1080P;;
	6) ./configure BPI_M2_USB_LCD7;;
esac
echo
echo -e "\033[31m Configure success!\033[0m"
echo

echo "This tool support following building mode(s):"
echo "--------------------------------------------------------------------------------"
echo "	1. Build all, uboot and kernel and pack to download images."
echo "	2. Build uboot only."
echo "	3. Build kernel only."
echo "	4. kernel configure."
echo "	5. Build rootfs for linux, and copy target files to output"
echo "		ROOTFS=/xxx/rootfs.tar.gz"
echo "		This is optinal, default using rootfs/linux/default_linux_rootfs.tar.gz."
echo "	6. Pack the builds to target download image, this step must execute after u-boot,"
echo "	   kernel and rootfs build out"
echo "	7. Clean all build."
echo "--------------------------------------------------------------------------------"

read -p "Please choose a mode(1-6): " mode
echo

if [ -z "$mode" ]; then
        echo -e "\033[31m No build mode choose, using Build all default   \033[0m"
        mode=1
fi

echo -e "\033[31m Now building...\033[0m"
echo
case $mode in
	1) make && 
	   make linux && 
	   make pack && 
	   cp_download_files;;
	2) make u-boot;;
	3) make kernel;;
	4) make kernel-config;;
	5) make linux;;
	6) make pack;;
	7) make clean;;
esac
echo

echo -e "\033[31m Build success!\033[0m"
echo
