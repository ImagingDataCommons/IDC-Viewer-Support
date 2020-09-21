#!/usr/bin/env bash

# Copyright 2020, Institute for Systems Biology
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


cd ~/IDC-Viewer-Support/scripts

if [ "$#" -ne 1 ]; then
    echo "Usage: ./fresh_viewer_from_git.sh [latest | release]"
    exit 1
fi

if [ ${1} == "release" ]; then
  USE_SET=setViewerVarsRelease.sh
elif [ "${1}" == "latest" ]; then
  USE_SET=setViewerVarsLatest.sh
else
  exit 1
fi

source ~/setEnvVars.sh

mkdir -p ~/config
pushd ~/config > /dev/null
gsutil cp gs://${CONFIG_BUCKET}/${CURRENT_CONFIG_PATH}/${USE_SET} .
chmod u+x ${USE_SET}
source ./${USE_SET}
popd > /dev/null

date > ~/scratch/idcGitVersion.txt
# Refresh from git. Head into the Viewer repo
pushd ~/Viewers > /dev/null
git fetch --all --tags
git pull
if [ ${1} == "release" ]; then
  git checkout tags/${RELEASE_TAG}
  echo "tags/${RELEASE_TAG}" >> ~/scratch/idcGitVersion.txt
elif [ "${1}" == "latest" ]; then
  git checkout master
  git log -n1 --format=format:"%H" >> ~/scratch/idcGitVersion.txt
fi
popd > /dev/null

#
# Move in favicon customization
#

pushd ~/Viewers/platform/viewer/public/assets/ > /dev/null
mv favicon.ico ~/scratch/favicon.ico
mv favicon-16x16.png ~/scratch/favicon-16x16.png
mv favicon-32x32.png ~/scratch/favicon-32x32.png
popd > /dev/null

pushd ~/IDC-Viewer-Support/static_files > /dev/null
cp favicon-nci.ico ~/Viewers/platform/viewer/public/assets/favicon.ico
cp favicon-nci-16x16.png ~/Viewers/platform/viewer/public/assets/favicon-16x16.png
cp favicon-nci-32x32.png ~/Viewers/platform/viewer/public/assets/favicon-32x32.png
popd > /dev/null

# Run yarn:

pushd ~/Viewers > /dev/null
yarn install
yarn run build
popd > /dev/null

#
# Get the originals back in place to make git checkout happy
#

pushd ~/Viewers/platform/viewer/public/assets/ > /dev/null
mv ~/scratch/favicon.ico favicon.ico
mv ~/scratch/favicon-16x16.png favicon-16x16.png
mv ~/scratch/favicon-32x32.png favicon-32x32.png
popd > /dev/null

#
# Get config built
#

./prepare_config.sh ${1}
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Move in customization
#

pushd ~/IDC-Viewer-Support/static_files > /dev/null
cp IDC-Logo-WHITE.svg ~/Viewers/platform/viewer/dist/IDC-Logo-WHITE.svg
popd > /dev/null

cp ~/scratch/app-config.js ~/Viewers/platform/viewer/dist/app-config.js
cp ~/scratch/idcGitVersion.txt ~/Viewers/platform/viewer/dist/idcGitVersion.txt

#
# Install in server buckets
#

pushd ~/Viewers/platform/viewer/dist/ > /dev/null
gsutil web set -m index.html -e index.html gs://${WBUCKET}
gsutil -h "Cache-Control:no-cache, max-age=0" rsync -d -r . gs://${WBUCKET}
popd > /dev/null

#
# Get back to tip
#

if [ ${1} == "release" ]; then
  pushd ~/Viewers > /dev/null
  git checkout master
  popd > /dev/null
fi
