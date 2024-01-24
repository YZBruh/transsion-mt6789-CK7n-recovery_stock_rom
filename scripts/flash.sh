#!/sbin/sh
# Tecno Camon 20 Pro recovery flashable stock ROM - Flasher script - By YZBruh

## Functions
ui_print() {
  echo "ui_print $1" > "$OUTFD";
  echo "ui_print" > "$OUTFD";
}

abort() {
  ui_print "$1";
  exit 1
}

set_progress() { echo "set_progress $1" > "$OUTFD"; }

##
TMP="/tmp/CK7n"
DEV="/dev/block/by-name"
MAPPER="/dev/block/mapper"

# Start progress
set_progress 0.10
ui_print "_______________________________"
ui_print "|                             |"
ui_print "|  Tecno Camon 20 Pro (CK7n)  |"
ui_print "|     Flashable Stock ROM     |"
ui_print "|     For Custom Recovery     |"
ui_print "|          By YZBruh          |"
ui_print "|_____________________________|"
ui_print "==> !  WARNING 1: In any problem, the exit will be directly made. If the error becomes wrong, execute at the terminal (to delete old files): rm -rf /tmp/CK7n"
ui_print "==> !  WARNING 2: Please read the flashing instructions carefully before proceeding this. And do at your own risk. Also make you update on Android 13 firmware version"
ui_print "==> The necessary cleaning operations are started..."
ui_print "==> !  NOTE: These partitions will be cleaned: super."

set_progress 5.00
twrp wipe super

# Start flashing
ui_print "==>     FLASHING      <=="

ui_print "==>   preloader_raw"
dd if=$TMP/images/pl_raw.img of=$MAPPER/pl_a
dd if=$TMP/images/pl_raw.img of=$MAPPER/pl_b

ui_print "==>   dtbo"
dd if=$TMP/images/dtbo.img of=$DEV/dtbo_a
dd if=$TMP/images/dtbo.img of=$DEV/dtbo_b

ui_print "==>   boot"
dd if=$TMP/images/boot.img of=$DEV/boot_a
dd if=$TMP/images/boot.img of=$DEV/boot_b

ui_print "==>   vendor_boot"
dd if=$TMP/images/vendor_boot.img of=$DEV/vendor_boot_a
dd if=$TMP/images/vendor_boot.img of=$DEV/vendor_boot_b

ui_print "==>   super"
dd if=$TMP/images/super.img of=$DEV/super

ui_print "==>   dpm"
dd if=$TMP/images/dpm.img of=$DEV/dpm_a
dd if=$TMP/images/dpm.img of=$DEV/dpm_b

ui_print "==>   efuse"
dd if=$TMP/images/efuse.img of=$DEV/efuse_a
dd if=$TMP/images/efuse.img of=$DEV/efuse_b

ui_print "==>   gz"
dd if=$TMP/images/gz.img of=$DEV/gz_a
dd if=$TMP/images/gz.img of=$DEV/gz_b

ui_print "==>   lk"
dd if=$TMP/images/lk.img of=$DEV/lk_a
dd if=$TMP/images/lk.img of=$DEV/lk_b

ui_print "==>   logo"
dd if=$TMP/images/logo.bin of=$DEV/logo_a
dd if=$TMP/images/logo.bin of=$DEV/logo_b

ui_print "==>   pi_img"
dd if=$TMP/images/pi_img.img of=$DEV/pi_img_a
dd if=$TMP/images/pi_img.img of=$DEV/pi_img_b

ui_print "==>   tee"
dd if=$TMP/images/tee.img of=$DEV/tee_a
dd if=$TMP/images/tee.img of=$DEV/tee_b

ui_print "==>   tkv"
dd if=$TMP/images/tkv.img of=$DEV/tkv_a
dd if=$TMP/images/tkv.img of=$DEV/tkv_b

ui_print "==>   tranfs"
dd if=$TMP/images/tranfs.img of=$DEV/tranfs_a
dd if=$TMP/images/tranfs.img of=$DEV/tranfs_b

ui_print "==>   persist"
dd if=$TMP/images/persist.img of=$DEV/persist

ui_print "==>   md1img"
dd if=$TMP/images/md1img.img of=$DEV/md1img_a
dd if=$TMP/images/md1img.img of=$DEV/md1img_b

ui_print "==>   mcupm"
dd if=$TMP/images/mcupm.img of=$DEV/mcupm_a
dd if=$TMP/images/mcupm.img of=$DEV/mcupm_b

ui_print "==>   scp"
dd if=$TMP/images/scp.img of=$DEV/scp_a
dd if=$TMP/images/scp.img of=$DEV/scp_b

ui_print "==>   sspmfw"
dd if=$TMP/images/sspmfw.img of=$DEV/sspmfw_a
dd if=$TMP/images/sspmfw.img of=$DEV/sspmfw_b

ui_print "==>   sspm"
dd if=$TMP/images/sspm.img of=$DEV/sspm_a
dd if=$TMP/images/sspm.img of=$DEV/sspm_b

ui_print "==>   vbmeta"
dd if=$TMP/images/vbmeta.img of=$DEV/vbmeta_a
dd if=$TMP/images/vbmeta.img of=$DEV/vbmeta_b

ui_print "==>   vbmeta_system"
dd if=$TMP/images/vbmeta_system.img of=$DEV/vbmeta_system_a
dd if=$TMP/images/vbmeta_system.img of=$DEV/vbmeta_system_b

ui_print "==>   vbmeta_vendor"
dd if=$TMP/images/vbmeta_vendor.img of=$DEV/vbmeta_vendor_a
dd if=$TMP/images/vbmeta_vendor.img of=$DEV/vbmeta_vendor_b

ui_print "==> !! Do you flash the seccfg image? (it's a part of bootloader!!!) (y/yes OR n/no)"
seccf() {
    read PASS
    case $PASS in
        y|yes)
            unset PASS
            ui_print "==>   seccfg"
            dd if=$TMP/images/seccfg.img of=$DEV/seccfg
        ;;
        n|no)
            unset PASS
            ui_print "==> !  Skipping..."
        ;;
        *)
            unset PASS
            ui_print "==> !! İnvalid option. Try again"
            seccf
    esac
}
seccf

ui_print "==>    FLASHED    <=="
set_progress 1.00

ui_print "==> Cleaning userdata..."
set_progress 2.50
twrp wipe data

ui_print "==> Cleaning cache..."
set_progress 2.50
twrp wipe cache

ui_print "==>    SUCCESSFULL    <=="
ui_print "         Enjoy :) "

rm -rf $TMP
unset ui_print abort set_progress DEV PASS MAPPER

# end of script