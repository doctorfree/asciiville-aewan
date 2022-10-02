#!/bin/bash
#

usage() {
  printf "\nUsage: ./build-aewan.sh [-Ci] [-d destdir] [-p prefix] [-t] [-u]"
  printf "\nWhere:"
  printf "\n\t-C indicates run configure and exit"
  printf "\n\t-d destdir specifies installation destination root (default /)"
  printf "\n\t-i indicates configure, build, and install"
  printf "\n\t-p prefix specifies installation prefix (default /usr)"
  printf "\n\t-t indicates configure with tensorflow support"
  printf "\n\t-u displays this usage message and exits\n"
  printf "\nNo arguments: configure, build\n"
  exit 1
}

install_aewan() {
  [ -d ${PREFIX}/usr ] || sudo mkdir -p ${PREFIX}/usr
  [ -d ${PREFIX}/usr/bin ] || sudo mkdir -p ${PREFIX}/usr/bin
  sudo cp aewan aecat aemakeflic ${PREFIX}/usr/bin
  [ -d ${PREFIX}/usr/share ] || sudo mkdir -p ${PREFIX}/usr/share
  [ -d ${PREFIX}/usr/share/man ] || sudo mkdir -p ${PREFIX}/usr/share/man
  [ -d ${PREFIX}/usr/share/man/man1 ] || sudo mkdir -p ${PREFIX}/usr/share/man/man1
  [ -d ${PREFIX}/usr/share/man/man5 ] || sudo mkdir -p ${PREFIX}/usr/share/man/man5
  sudo cp man/man1/*.1 ${PREFIX}/usr/share/man/man1
  sudo cp man/man5/*.5 ${PREFIX}/usr/share/man/man5
}

CONFIGURE_ONLY=
INSTALL=
PREFIX=
DESTDIR=
TENSOR=
while getopts "Cd:ip:tu" flag; do
    case $flag in
        C)
            CONFIGURE_ONLY=1
            ;;
        d)
            DESTDIR="${OPTARG}"
            ;;
        i)
            INSTALL=1
            ;;
        p)
            PREFIX="${OPTARG}"
            ;;
        t)
            TENSOR=1
            ;;
        u)
            usage
            ;;
    esac
done
shift $(( OPTIND - 1 ))

destdir=
prefix="--prefix=/usr"
tensor=
[ "${DESTDIR}" ] && destdir="--destdir=${DESTDIR}"
[ "${PREFIX}" ] && prefix="--prefix=${PREFIX}"
[ "${TENSOR}" ] && tensor="--with-tensorflow"

[ -x aewan ] && {
  if [ "${INSTALL}" ]
  then
    install_aewan
  fi
  exit 0
}

prefix="--prefix=/usr"
[ "${PREFIX}" ] && prefix="--prefix=${PREFIX}"
autoreconf -vi
./configure ${prefix}

[ "${CONFIGURE_ONLY}" ] && exit 0

make
chmod +x aewan aecat aemakeflic

if [ "${INSTALL}" ]
then
  install_aewan
fi

