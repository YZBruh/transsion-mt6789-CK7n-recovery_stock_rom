#!/usr/bin/bash
# Transsion MT6789 Recovery Stock ROM task
# Currently compatible with CK7n (only the login text will be displayed in the TWRP UI, and it will be checked and copied. It is easy to make it compatible with other transmission devices!)
# By @YZBruh

# Directly exit
set -e

# Variables
DIR=$(pwd)
ARCH=$(uname -m)

## Functions

# Error function
abort() {
    echo "Error!"
    if [ -d $DIR/recovery_rom ]; then
       file_cleaner
    fi
    cleanup
    exit 1
}

# Cleaner function (values)
cleanup() {
    unset DIR
    unset ARCH
    unset pass
    unset sparse_super
    unset sparse
    unset extract_rom
    unset source_dir
    unset destination_dir
    unset file_name
    unset compress
}

# File cleaner (if error state) function
file_cleaner() {
    rm -rf $DIR/recovery_rom
}

# Super image unpacker function
sparse_super() {
    echo "Sparsing super image..."
    cp $DIR/lpunpack/lpunpack.py $DIR/recovery_rom/stock/*
    sparse=$(python3 lpunpack.py super.img super)
    rm -rf $DIR/recovery_rom/stock/*/lpunpack.py
    rm -rf $DIR/lpunpack
    if [[ $sparse ]]; then
       echo
    else
       echo "Sparsing failed!"
       abort
    fi
    rm -rf super.img super.unsparse.img || abort
    cd super
    mv *.img $DIR/images || abort
    cd $DIR/recovery_rom/*
    rm -rf super
    echo "Succesfull!"
}

##

# Starting process
mkdir recovery_rom
cd recovery_rom

# İnstall packs
echo "This bash script requires some packages to run. Do you want to install it? (y/n)"
read -p "Enter option: " pass
echo 
if [ "$pass" == "y" ]; then
   echo "İnstalling packages..."
   echo
   case $ARCH in
   armv7l|aarch64)
     pkg update
     pkg upgrade -y
     apt update
     apt upgrade -y
     pkg install curl zip unzip git python3 wget -y || abort
   ;;
   x86_64|i386)
     sudo apt update
     sudo apt upgrade -y
     sudo apt install curl python3 zip git -y || abort
   ;;
   *)
     echo "Architecture could not be determined!"
     echo
   esac
else
   if [ "$pass" == "n" ]; then
      echo "Package installation was skipped."
      echo
   else
      echo "İnvalid option!"
      echo
      abort
   fi
fi

# Get stock rom 
echo "Downloading stock ROM..."
echo
mkdir stock
cd stock
wget https://mde1.androidfilehost.com/dl/4mfkxk2WW00PI4bppd4rNQ/1704570660/4279422670115727738/%5BHovatek%5D_Tecno_Camon_20_Pro_%28CK7n-H894ABC-T-GL-230111V246%29.zip || abort

# Extract downloaded rom
echo
echo "Extracting stock ROM..."
echo
extract_rom=$(unzip *.zip && rm -rf *.zip)
if [[ $extract_rom ]]; then
   echo
   echo "Extracted!"
else
   echo
   echo "Extracting failed!"
   echo
   abort
fi

# Organize files
cd $DIR/recovery_rom/stock/*
sparse_super
echo "Moving files (this process may take a long time)..."
echo
source_dir=$(pwd)
destination_dir="$DIR/images"
find "$source_dir" -type f -name "*.img" -exec mv {} "$destination_dir" \;
cd $DIR
rm -rf recovery_rom
cd $DIR/images
rm -rf preloader.img preloader_ck7n_h894.img preloader_emmc.img preloader_ufs.img userdata.img

# Compress recovery ROM
echo "Compressing..."
echo
cd $DIR
rm -rf $DIR/images/vendor_dlkm.img
rm -rf $DIR/images/odm_dlkm.img
rm -rf $DIR/images/vendor_boot-debug.img
rm -rf $DIR/images/super_empty.img
rm -rf $DIR/README.md
rm -rf $DIR/generate_zip.sh
file_name="CK7n_recovery_flashable_rom_A13-"$(date +%Y%m%d)""
compress=$(zip -r $file_name *)
if [[ $compress ]]; then
   echo
else
   echo "Compressing failed!"
   echo
   abort
fi
echo "Removing old files..."
echo
cd images
rm -rf *
cd $DIR
echo "SUCCESFULL!"
echo "ZİP file: $DIR/"$file_name".zip"
cleanup

# end of file
