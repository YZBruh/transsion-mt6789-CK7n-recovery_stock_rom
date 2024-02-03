#!/usr/bin/bash
# Tecno Camon 20 Pro recovery flashable stock ROM - Zip file generator script - By YZBruh

# Directly exit = an sloppy script xD
set -e

# Variables
DIR=$(pwd)
NAME="CK7n_recovery_rom-T-"$(date +%s)".zip"
LINK="$1" # firmware link

# Start progress
clear
echo "--- Generating zip file... ---"
mkdir temp
echo "Downloading stock ROM..."
cd temp
wget $LINK
echo "Extracting..."
unzip *.zip
rm -rf *.zip
echo "Moving images..."
if [[ $(find . -type f -maxdepth 1 -name '*.img') ]]; then
    cd $(pwd)
elif [[ $(find . -type f -maxdepth 2 -name '*.img') ]]; then
    cd *
else
    read -p "Oops! Their images were not found. Please enter its path (extract output may be a clue): " IMAGE_DIR
    if [ -d "$IMAGE_DIR" ]; then
        cd "$IMAGE_DIR"
    else
        echo "Directory not found!.. Aborting"
        exit 1
    fi
fi
mv *.img $DIR/images/
mv logo.bin $DIR/images/
echo "Removing unnecessary images..."
cd $DIR/images
mv preloader_raw.img pl.img
rm -f preloader.img preloader_ck7n_h894.img preloader_emmc.img preloader_ufs.img super_empty.img userdata.img vendor_boot-debug.img dummy vendor_dlkm* odm_dlkm*
rm -rf $DIR/temp
echo "Generating sha256 sums..."
cd $DIR/images
sha256sum -b -t * >> identifier.sha256
cd $DIR/M*/*/*/*
sha256sum -b -t * >> identifier.sha256
cd $DIR/scripts
mv generate_zip.sh $DIR
sha256sum -b -t * >> identifier.sha256
echo "Checking sha256 sums..."
sha256sum -c identifier.sha256
cd $DIR/images
sha256sum -c identifier.sha256
cd $DIR/M*/*/*/*
sha256sum -c identifier.sha256
cd $DIR
echo "Compressing..."
zip -r $NAME *
zip -d $NAME generate_zip.sh
mv *.sh scripts/
echo "Removing old files..."
rm -rf images/*
rm -rf M*/*/*/*/*.sha256
rm -rf scripts/*.sha256
echo "Succesfull!"
exit

# end of script
