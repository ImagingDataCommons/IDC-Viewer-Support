#!/usr/bin/env bash

BUCKET_NAME=$1
CACHE_ON=$2
SKIPPER=$3

if [ "$#" -ne 3 ]; then
    echo "usage: BUCKET_NAME [ON | OFF] [directory to skip]"
    exit
fi


#
# USAGE: set-caching.sh dev-viewer.canceridc.dev OFF assets
#

#
# Insure the file goes away when we exit, no matter what:
#

TMP_FILE=$(mktemp /tmp/gslist.XXXXXX)
exec 3> ${TMP_FILE}
exec 4< ${TMP_FILE}
rm ${TMP_FILE}

gsutil ls -r gs://${BUCKET_NAME} >&3

#
# Google defaults to caching, so, just clear the flag:
#

CACHE_SETTING="Cache-Control:no-cache, max-age=0"
if [ ${CACHE_ON} = "ON" ]; then
    CACHE_SETTING="Cache-Control"
fi

#
# OK, I misread the docs, it looked like setmeta required a single file name. Not so. But
# the auto-erasing temp file thing (with the weirdo -u4 arg, to boot) is not something I want to throw away:
#

while read -u4 buck_file ; do
    echo ${buck_file}
    if [[ ${buck_file} == *"/:" ]]; then
        echo Skipping directory ${buck_file}
    elif [[ ${buck_file} == *"${SKIPPER}"* ]]; then
        echo Skipping file ${buck_file}
    else
        echo Setting ${buck_file} ${CACHE_SETTING}
        gsutil setmeta -h "${CACHE_SETTING}" ${buck_file}
    fi
done
