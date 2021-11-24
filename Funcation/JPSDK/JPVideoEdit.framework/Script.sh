#!/bin/sh

#工程名
PROJECT_NAME=JPVideoEdit
WORKSPACE_NAME=${PROJECT_NAME}.xcworkspace



#工程路径
PROJECT_DIR=$(pwd)

#build之后的文件夹路径
BUILD_DIR=$PROJECT_DIR/Build/Products
BUILD_ROOT=$PROJECT_DIR/Build/Products



#打包模式 Debug/Release 默认是Release
development_mode=Release

UNIVERSAL_OUTPUTFOLDER=${PROJECT_DIR}/${development_mode}-universal
INSTALL_DIR_A=${PROJECT_DIR}/${PROJECT_NAME}.framework/${PROJECT_NAME}






# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"


# Step 1. Build Device and Simulator versions
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${PROJECT_NAME}" -configuration ${development_mode} -sdk iphoneos ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean

xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${PROJECT_NAME}" -configuration ${development_mode} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean


xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${PROJECT_NAME}" -configuration ${development_mode} -sdk iphoneos ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" build

xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${PROJECT_NAME}" -configuration ${development_mode} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" build




# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${development_mode}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"


# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${development_mode}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}"

echo "======合成结束======"

# Step 5. Convenience step to copy the framework to the project's directory
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${PROJECT_DIR}"

# -f 判断文件是否存在
if [ -f "${INSTALL_DIR_A}" ]
then
echo "======验证合成包是否成功======"
lipo -info "${INSTALL_DIR_A}"
fi

#打开目标文件夹
open "${PROJECT_DIR}"


