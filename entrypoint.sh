#!/bin/bash

set -x
set -e

export DEBIAN_FRONTEND=noninteractive
export LD_PRELOAD=libeatmydata.so
export LD_LIBRARY_PATH=/usr/lib/libeatmydata

BUILD_DIR=/build

echo build $BUILD_DIR
echo workspace $GITHUB_WORKSPACE

git clone https://github.com/RevolutionPi/kernelbakery -b ${INPUT_KERNELBAKERY_BRANCH} --depth 1 --single-branch ${BUILD_DIR}/kernelbakery
git clone https://github.com/RevolutionPi/piControl -b ${INPUT_PICONTROL_BRANCH} --depth 1 --single-branch ${BUILD_DIR}/piControl

(cd $GITHUB_WORKSPACE && ls && git rev-parse --abbrev-ref HEAD)
(cd $BUILD_DIR/piControl && ls && git rev-parse --abbrev-ref HEAD)
(cd $BUILD_DIR/kernelbakery && ls && git rev-parse --abbrev-ref HEAD)

cd ${BUILD_DIR}/kernelbakery
LINUXDIR=${GITHUB_WORKSPACE} PIKERNELMODDIR=${BUILD_DIR}/piControl debian/update.sh

if [[ ${INPUT_CHANGELOG_UPDATE:-1} -eq 1 ]]; then
	BUILD_DATE=$(date "+%y%m%d%H%M%S")
	BUILD_COMMIT=${INPUT_BUILD_COMMIT:-$GITHUB_SHA}

  NAME=${INPUT_CHANGELOG_AUTHOR} \
  EMAIL=${INPUT_CHANGELOG_AUTHOR_EMAIL} \
	debchange  -l "~${BUILD_DATE}-${BUILD_COMMIT}" -D experimental "this is an automatic build generated by the buildsystem"
fi

dpkg-buildpackage -a armhf -b -us -uc

FILENAME_KERNEL=$(basename ${BUILD_DIR}/raspberrypi-kernel_*.deb)
FILENAME_HEADERS=$(basename ${BUILD_DIR}/raspberrypi-kernel-headers_*.deb)

cp ${BUILD_DIR}/${FILENAME_KERNEL} ${GITHUB_WORKSPACE}
cp ${BUILD_DIR}/${FILENAME_HEADERS} ${GITHUB_WORKSPACE}

# fix permissions
chmod 666 ${GITHUB_WORKSPACE}/${FILENAME_KERNEL}
chmod 666 ${GITHUB_WORKSPACE}/${FILENAME_HEADERS}

echo "::set-output name=filename_kernel::${FILENAME_KERNEL}"
echo "::set-output name=filename_headers::${FILENAME_HEADERS}"
