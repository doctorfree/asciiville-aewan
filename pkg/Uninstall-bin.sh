#!/bin/bash

AEWAN_FILES="usr/local/bin/aecat
             usr/local/bin/aemakeflic
             usr/local/bin/aewan
             usr/local/share/man/man5/aewan.5
             usr/local/share/man/man1/aecat.1
             usr/local/share/man/man1/aemakeflic.1
             usr/local/share/man/man1/aewan.1"
AEWAN_DIRS="usr/local/share/asciiville-aewan
            usr/local/share/doc/asciiville-aewan"

user=`id -u -n`

[ "${user}" == "root" ] || {
  echo "Uninstall-bin.sh must be run as the root user."
  echo "Use 'sudo ./Uninstall-bin.sh ...'"
  echo "Exiting"
  exit 1
}

rm -f ${AEWAN_FILES}
rm -rf ${AEWAN_DIRS}
