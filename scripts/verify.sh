#!/sbin/sh
# Tecno Camon 20 Pro recovery flashable stock ROM - sha256 checker script - By YZBruh

# Directly exit = an sloppy script xD
set -e
TMP="/tmp/CK7n"

cd $TMP/scripts
sha256sum -c identifier.sha256
cd $TMP/M*/*/*/*
sha256sum -c identifier.sha256
cd $TMP/images
sha256sum -c identifier.sha256
cd $TMP

# end of script
