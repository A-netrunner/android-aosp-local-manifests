#!/bin/bash

rm -rf .repo/local_manifests
rm -rf device/realme
rm -rf kernel/oplus
rm -rf vendor/realme
rm -rf hardware/oplus
rm -rf device/oneplus
rm -rf vendor/oneplus
rm -rf vendor/oplus
rm -rf vendor/qcom/opensource/vibrator

echo "========================================================================"
echo "DELETED DIRECTORIES"
echo "========================================================================"

# Clone Vibrator
git clone https://github.com/DevInfinix/android_vendor_qcom_opensource_vibrator -b 14-derp-bleeding-edge vendor/qcom/opensource/vibrator

# Clone local_manifests repository
git clone https://github.com/DevInfinix/android-aosp-local-manifests --depth 1 -b 14-derp-bleeding-edge .repo/local_manifests
if [ ! 0 == 0 ]
    then curl -o .repo/local_manifests https://github.com/DevInfinix/android-aosp-local-manifests.git
fi

echo "========================================================================"
echo "CLONED REPOS"
echo "========================================================================"

/opt/crave/resynctest.sh

echo "========================================================================"
echo "BUILDING........."
echo "========================================================================"

source build/envsetup.sh
lunch derp_ice-userdebug
make installclean
mka bacon

echo "========================================================================"
echo "BUILT ROM SUCCESSFULLY!"
echo "========================================================================"

# Find the path of the zip file in the 'ice' folder
ICE_FOLDER="ice"
ZIP_FILE=$(find "$ICE_FOLDER" -name "*.zip" -type f -print -quit)

# Check if a zip file was found
if [ -n "$ZIP_FILE" ]; then
    echo "Found zip file: $ZIP_FILE"

    # Upload to bashupload.com
    echo "Uploading to bashupload.com..."
    curl bashupload.com -T "$ZIP_FILE"

    # Upload to pixeldrain.com
    echo "Uploading to pixeldrain.com..."
    curl -T "$ZIP_FILE" https://pixeldrain.com/api/file/

    echo "========================================================================"
    echo "UPLOAD COMPLETED!"
    echo "========================================================================"
else
    echo "========================================================================"
    echo "No zip file found in the 'ice' folder."
    echo "========================================================================"
fi
