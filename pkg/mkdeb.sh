#!/bin/bash
PKG="asciiville-aewan"
SRC_NAME="asciiville-aewan"
PKG_NAME="asciiville-aewan"
DEBFULLNAME="Ronald Record"
DEBEMAIL="ronaldrecord@gmail.com"
DESTDIR="usr"
SRC=${HOME}/src
ARCH=amd64
SUDO=sudo
GCI=

dpkg=`type -p dpkg-deb`
[ "${dpkg}" ] || {
    echo "Debian packaging tools do not appear to be installed on this system"
    echo "Are you on the appropriate Linux system with packaging requirements ?"
    echo "Exiting"
    exit 1
}
dpkg_arch=`dpkg --print-architecture`
[ "${dpkg_arch}" == "${ARCH}" ] || ARCH=${dpkg_arch}

[ -f "${SRC}/${SRC_NAME}/MPPVERSION" ] || {
  [ -f "/builds/doctorfree/${SRC_NAME}/MPPVERSION" ] || {
    echo "$SRC/$SRC_NAME/MPPVERSION does not exist. Exiting."
    exit 1
  }
  SRC="/builds/doctorfree"
  GCI=1
# SUDO=
}

. "${SRC}/${SRC_NAME}/MPPVERSION"
PKG_VER=${VERSION}
PKG_REL=${RELEASE}

umask 0022

# Subdirectory in which to create the distribution files
OUT_DIR="dist/${PKG_NAME}_${PKG_VER}"

[ -d "${SRC}/${SRC_NAME}" ] || {
    echo "$SRC/$SRC_NAME does not exist or is not a directory. Exiting."
    exit 1
}

cd "${SRC}/${SRC_NAME}"

# Build aewan
if [ -x scripts/build-aewan.sh ]
then
  scripts/build-aewan.sh
else
  python3 waf configure --prefix=/usr \
                        --build-static \
                        --with-gaia \
                        --with-python \
                        --with-example=streaming_extractor_music
  python3 waf
fi

${SUDO} rm -rf dist
mkdir dist

[ -d ${OUT_DIR} ] && rm -rf ${OUT_DIR}
mkdir ${OUT_DIR}
mkdir ${OUT_DIR}/DEBIAN
chmod 755 ${OUT_DIR} ${OUT_DIR}/DEBIAN

echo "Package: ${PKG}
Version: ${PKG_VER}-${PKG_REL}
Section: sound
Priority: optional
Architecture: ${ARCH}
Depends: libtag1v5 (>= 1.11), python3-dev, libchromaprint-dev, libeigen3-dev, libfftw3-dev, libsamplerate0, libyaml-dev, libavformat58 (>= 7:4.1), libavfilter7 (>= 7:4.0), libswresample3 (>= 7:4.0), libavcodec58 (>= 7:4.2), libswscale5 (>= 7:4.0), libavdevice58 (>= 7:4.0), libavutil56 (>= 7:4.0)
Maintainer: ${DEBFULLNAME} <${DEBEMAIL}>
Installed-Size: 3000
Build-Depends: debhelper (>= 11)
Homepage: https://github.com/doctorfree/asciiville-aewan
Description: Essentia audio analysis tool -- feature extractors
 Essentia is an audio analysis tool. It provides a reusable collection
 of algorithms and descriptors mainly used to extract features from
 audio files. It is written in C++, but also has Python bindings,
 meaning you can control it from within Python, and write scripts that
 use Essentia features (just as you would in Matlab).
 .
 This package contains command-line feature extractors based on Essentia." > ${OUT_DIR}/DEBIAN/control

chmod 644 ${OUT_DIR}/DEBIAN/control

for dir in "${DESTDIR}" "${DESTDIR}/share" "${DESTDIR}/share/doc" \
           "${DESTDIR}/share/doc/${PKG}" "${DESTDIR}/share/${PKG}"
do
    [ -d ${OUT_DIR}/${dir} ] || ${SUDO} mkdir ${OUT_DIR}/${dir}
    ${SUDO} chown root:root ${OUT_DIR}/${dir}
done

for dir in bin
do
    [ -d ${OUT_DIR}/${DESTDIR}/${dir} ] && ${SUDO} rm -rf ${OUT_DIR}/${DESTDIR}/${dir}
done

#${SUDO} cp aewan/build/src/examples/aewan_streaming_extractor_music \
#           ${OUT_DIR}/${DESTDIR}/bin
#${SUDO} cp aewan/build/src/examples/aewan_streaming_extractor_music_svm \
#           ${OUT_DIR}/${DESTDIR}/bin
# Install aewan
if [ -x scripts/build-aewan.sh ]
then
  ${SUDO} scripts/build-aewan.sh -i -d "${SRC}/${SRC_NAME}/${OUT_DIR}"
else
  ${SUDO} python3 waf install --destdir="${SRC}/${SRC_NAME}/${OUT_DIR}"
fi

${SUDO} cp ACKNOWLEDGEMENTS ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp AUTHORS ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp Changelog ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp COPYING.txt ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp "Essentia Licensing.txt" ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp FAQ.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp VERSION ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp MPPVERSION ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} pandoc -f gfm README.md | ${SUDO} tee ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/README.html > /dev/null
${SUDO} gzip -9 ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/Changelog

${SUDO} cp -a share/svm_models ${OUT_DIR}/${DESTDIR}/share/${PKG}/svm_models

${SUDO} chmod 755 ${OUT_DIR}/${DESTDIR}/bin/* ${OUT_DIR}/${DESTDIR}/bin
${SUDO} chown -R root:root ${OUT_DIR}/${DESTDIR}

cd dist
echo "Building ${PKG_NAME}_${PKG_VER} Debian package"
${SUDO} dpkg --build ${PKG_NAME}_${PKG_VER} ${PKG_NAME}_${PKG_VER}-${PKG_REL}.${ARCH}.deb
cd ${PKG_NAME}_${PKG_VER}
echo "Creating compressed tar archive of ${PKG_NAME} ${PKG_VER} distribution"
tar cf - usr | gzip -9 > ../${PKG_NAME}_${PKG_VER}-${PKG_REL}.tgz

have_zip=`type -p zip`
[ "${have_zip}" ] || {
  ${SUDO} apt-get update
  ${SUDO} apt-get install zip -y
}
echo "Creating zip archive of ${PKG_NAME} ${PKG_VER} distribution"
zip -q -r ../${PKG_NAME}_${PKG_VER}-${PKG_REL}.zip usr

cd ..
[ "${GCI}" ] || {
    [ -d ../releases ] || mkdir ../releases
    [ -d ../releases/${PKG_VER} ] || mkdir ../releases/${PKG_VER}
    ${SUDO} cp *.deb *.tgz *.zip ../releases/${PKG_VER}
}
