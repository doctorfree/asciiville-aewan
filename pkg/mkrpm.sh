#!/bin/bash
PKG="asciiville-aewan"
SRC_NAME="asciiville-aewan"
PKG_NAME="asciiville-aewan"
DESTDIR="usr"
SRC=${HOME}/src
SUDO=sudo
GCI=

[ -f "${SRC}/${SRC_NAME}/MPPVERSION" ] || {
  [ -f "/builds/doctorfree/${SRC_NAME}/MPPVERSION" ] || {
    echo "$SRC/$SRC_NAME/MPPVERSION does not exist. Exiting."
    exit 1
  }
  SRC="/builds/doctorfree"
  SUDO=
  GCI=1
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

echo "Building ${PKG_NAME}_${PKG_VER} rpm package"

[ -d pkg/rpm ] && cp -a pkg/rpm ${OUT_DIR}/rpm
[ -d ${OUT_DIR}/rpm ] || mkdir ${OUT_DIR}/rpm

have_rpm=`type -p rpmbuild`
[ "${have_rpm}" ] || {
  have_yum=`type -p yum`
  if [ "${have_yum}" ]
  then
    ${SUDO} yum -y install rpm-build
  else
    ${SUDO} apt-get update
    export DEBIAN_FRONTEND=noninteractive
    ${SUDO} ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
    ${SUDO} apt-get install rpm -y
    ${SUDO} dpkg-reconfigure --frontend noninteractive tzdata
  fi
}

rpmbuild -ba --build-in-place \
   --define "_topdir ${OUT_DIR}" \
   --define "_sourcedir ${OUT_DIR}" \
   --define "_version ${PKG_VER}" \
   --define "_release ${PKG_REL}" \
   --buildroot ${SRC}/${SRC_NAME}/${OUT_DIR}/BUILDROOT \
   ${OUT_DIR}/rpm/${PKG_NAME}.spec

# Rename RPMs if necessary
for rpmfile in ${OUT_DIR}/RPMS/*/*.rpm
do
  [ "${rpmfile}" == "${OUT_DIR}/RPMS/*/*.rpm" ] && continue
  rpmbas=`basename ${rpmfile}`
  rpmdir=`dirname ${rpmfile}`
  newnam=`echo ${rpmbas} | sed -e "s/${PKG_NAME}-${PKG_VER}-${PKG_REL}/${PKG_NAME}_${PKG_VER}-${PKG_REL}/"`
  [ "${rpmbas}" == "${newnam}" ] && continue
  mv ${rpmdir}/${rpmbas} ${rpmdir}/${newnam}
done

${SUDO} cp ${OUT_DIR}/RPMS/*/*.rpm dist

[ "${GCI}" ] || {
    [ -d releases ] || mkdir releases
    [ -d releases/${PKG_VER} ] || mkdir releases/${PKG_VER}
    ${SUDO} cp ${OUT_DIR}/RPMS/*/*.rpm releases/${PKG_VER}
}
