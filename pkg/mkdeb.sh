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

[ -f "${SRC}/${SRC_NAME}/VERSION" ] || {
  [ -f "/builds/doctorfree/${SRC_NAME}/VERSION" ] || {
    echo "$SRC/$SRC_NAME/VERSION does not exist. Exiting."
    exit 1
  }
  SRC="/builds/doctorfree"
  GCI=1
# SUDO=
}

. "${SRC}/${SRC_NAME}/VERSION"
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
if [ -x pkg/build-aewan.sh ]
then
  pkg/build-aewan.sh
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
Section: misc
Priority: optional
Architecture: ${ARCH}
Depends: libncursesw6 (>= 6), zlib1g
Maintainer: ${DEBFULLNAME} <${DEBEMAIL}>
Build-Depends: debhelper (>= 11)
Homepage: https://github.com/doctorfree/asciiville-aewan
Description: Aewan is a curses-based program for the creation and editing of ascii art" > ${OUT_DIR}/DEBIAN/control

chmod 644 ${OUT_DIR}/DEBIAN/control

for dir in "${DESTDIR}" "${DESTDIR}/share" "${DESTDIR}/share/doc" \
           "${DESTDIR}/share/man" "${DESTDIR}/share/man/man1" \
           "${DESTDIR}/share/man/man5" \
           "${DESTDIR}/share/doc/${PKG}" "${DESTDIR}/share/${PKG}"
do
    [ -d ${OUT_DIR}/${dir} ] || ${SUDO} mkdir ${OUT_DIR}/${dir}
    ${SUDO} chown root:root ${OUT_DIR}/${dir}
done

for dir in bin
do
    [ -d ${OUT_DIR}/${DESTDIR}/${dir} ] && ${SUDO} rm -rf ${OUT_DIR}/${DESTDIR}/${dir}
done

# Install aewan
if [ -x pkg/build-aewan.sh ]
then
  ${SUDO} pkg/build-aewan.sh -i -d "${SRC}/${SRC_NAME}/${OUT_DIR}"
else
  ${SUDO} cp aewan aecat aemakeflic ${OUT_DIR}/${DESTDIR}/bin
  ${SUDO} cp man/man1/*.1 ${OUT_DIR}/${DESTDIR}/share/man/man1
  ${SUDO} cp man/man5/*.5 ${OUT_DIR}/${DESTDIR}/share/man/man5
fi

${SUDO} cp aewan-README ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp copyright ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp CHANGELOG ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp COPYING ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp LICENSE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp TODO ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp VERSION ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} pandoc -f gfm README.md | ${SUDO} tee ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/README.html > /dev/null
${SUDO} gzip -9 ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/CHANGELOG

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
