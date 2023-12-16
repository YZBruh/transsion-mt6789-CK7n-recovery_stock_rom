#!/usr/bin/bash
# Transsion MT6789 Recovery Stock ROM task
# Currently compatible with CK7n (only the login text will be displayed in the TWRP UI, and it will be checked and copied. It is easy to make it compatible with other transmission devices!)
# By @YZBruh
DIR=$(pwd)
ARCH=$(uname -m)
# Functions
abort() {
echo "Error!"
cleanup
exit 1
}

cleanup() {
unset DIR
unset ARCH
unset pass
unset sparse_super
unset sparse
}

sparse_super() {
echo "Sparsing super image..."
sparse=$(python3 lpunpack.py super.img super)
if [[ $sparse ]]; then
   echo
else
   echo "Sparsing failed!"
   abort
fi
rm -rf super.img super.unsparse.img
mv odm_dlkm_a.img $dir/recovery_rom/odm_dlkm_a.img
mv odm_dlkm_b.img $dir/recovery_rom/odm_dlkm_b.img
mv vendor_dlkm_a.img $dir/recovery_rom/vendor_dlkm_a.img
mv vendor_dlkm_b.img $dir/recovery_rom/vendor_dlkm_b.img
mv product_a.img $dir/recovery_rom/product_a.img
mv product_b.img $dir/recovery_rom/product_b.img
mv system_a.img $dir/recovery_rom/system_a.img
mv system_b.img $dir/recovery_rom/system_b.img
mv system_ext_a.img $dir/recovery_rom/system_ext_a.img
mv system_ext_b.img $dir/recovery_rom/system_ext_b.img
mv vendor_a.img $dir/recovery_rom/vendor_a.img
mv vendor_b.img $dir/recovery_rom/vendor_b.img
echo "Succesfull!"
}

# Starting process
mkdir recovery_rom
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
     pkg install curl python3 zip -y
     wget https://raw.githubusercontent.com/unix3dgforce/lpunpack/master/lpunpack.py
     chmod 777 lpunpack.py
   ;;
   x86_64|i386)
     sudo apt update
     sudo apt upgrade -y
     sudo apt install curl python3 zip -y
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
