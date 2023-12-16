#!/usr/bin/bash
# Transsion MT6789 Recovery Stock ROM task
# Currently compatible with CK7n (only the login text will be displayed in the TWRP UI, and it will be checked and copied. It is easy to make it compatible with other transmission devices!)
# By @YZBruh
# Values
DIR=$(pwd)
ARCH=$(uname -m)
# Functions
# Error function
abort() {
echo "Error!"
rm -rf $DIR/recovery_rom
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
unset get_rom
unset extract_rom
unset source_dir
unset destination_dir
unset file_name
unset compress
}

# Super image unpacker function
sparse_super() {
echo "Sparsing super image..."
cp $DIR/lpunpack/lpunpack.py $DIR/recovery_rom/stock/*
sparse=$(python3 lpunpack.py super.img super)
if [[ $sparse ]]; then
   echo
else
   echo "Sparsing failed!"
   abort
fi
rm -rf super.img super.unsparse.img
cd super
mv odm_dlkm_a.img $DIR/images/odm_dlkm_a.img
mv odm_dlkm_b.img $DIR/images/odm_dlkm_b.img
mv vendor_dlkm_a.img $DIR/images/vendor_dlkm_a.img
mv vendor_dlkm_b.img $DIR/images/vendor_dlkm_b.img
mv product_a.img $DIR/images/images/product_a.img
mv product_b.img $DIR/images/product_b.img
mv system_a.img $DIR/images/system_a.img
mv system_b.img $DIR/images/system_b.img
mv system_ext_a.img $DIR/images/system_ext_a.img
mv system_ext_b.img $DIR/images/system_ext_b.img
mv vendor_a.img $DIR/images/vendor_a.img
mv vendor_b.img $DIR/images/vendor_b.img
cd $DIR/recovery_rom/*
rm -rf vendor_dlk*
rm -rf super
echo "Succesfull!"
}

# Starting process
mkdir recovery_rom
cd recovery_rom

# İnstall packs
echo "This bash script requires some packages to run. Do you want to install it? (y/n)"
read -p "Enter option: " pass
if [ $pass == "y" ]; then
   echo "İnstalling packages..."
   case $ARCH in
   armv7l|aarch64)
     pkg update
     pkg upgrade -y
     apt update
     apt upgrade -y
     pkg install curl python3 zip git -y
   ;;
   x86_64|i386)
     sudo apt update
     sudo apt upgrade -y
     sudo apt install curl python3 zip git -y
   ;;
   *)
     echo "Architecture could not be determined!"
   esac
else
   if [ $pass == "n" ]; then
      echo "Package installation was skipped."
   else
      echo "İnvalid option!"
      abort
   fi
fi

# Get stock rom 
echo "Downloading stock ROM..."
mkdir stock
cd stock
get_rom=$(wget https://mor1.androidfilehost.com/dl/eNODIzeVavWO08qdxomftQ/1702795391/4279422670115727738/%5BHovatek%5D_Tecno_Camon_20_Pro_%28CK7n-H894ABC-T-GL-230111V246%29.zip)

# Extract downloaded rom
echo "Extracting stock ROM..."
extract_rom=$(unzip *.zip && rm -rf *.zip)
if [[ $extract_rom ]]; then
   echo "Extracted!"
else
   echo "Extracting failed!"
   abort
fi

# Organize files
cd $DIR/recovery_rom/stock/*
sparse_super
echo "Moving files (this process may take a long time)..."
source_dir=$(pwd)
destination_dir="$DIR/images"
find "$source_dir" -type f -name "*.img" -exec mv {} "$destination_dir" \;
cd $DIR
rm -rf recovery_rom
cd $DIR/images
rm -rf preloader.img preloader_ck7n_h894.img preloader_emmc.img preloader_ufs.img userdata.img empty

# Compress recovery ROM
echo "Compressing..."
cd $DIR
rm -rf .github
rm -rf lpunpack
rm -rf $DIR/images/vendor_dlkm.img
rm -rf $DIR/images/odm_dlkm.img
rm -rf $DIR/images/vendor_boot-debug.img
file_name="CK7n_recovery_flashable_rom_A13"
compress=$(zip -r $file_name *)
if [[ $compress ]]; then
   echo
else
   echo "Compressing failed!"
   abort
fi
zip -d $file_name generate_zip.sh
echo "Removing old files..."
cd images
rm -rf *
cd $DIR
echo "SUCCESFULL!"
echo "ZİP file: $DIR/"$file_name"
cleanup

# end of file
