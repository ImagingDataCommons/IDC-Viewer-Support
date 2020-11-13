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

if [ "$#" -ne 0 ]; then
    echo "Usage: ./fresh_app_config.sh"
    exit 1
fi

USE_SET=setViewerVarsConfig.sh

source ~/setEnvVars.sh

mkdir -p ~/config
pushd ~/config > /dev/null
gsutil cp gs://${CONFIG_BUCKET}/${CURRENT_CONFIG_PATH}/${USE_SET} .
chmod u+x ${USE_SET}
source ./${USE_SET}
popd > /dev/null

#
# Get config built
#

./prepare_config.sh config
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Install in server bucket:
#

pushd ~/scratch > /dev/null
gsutil cp app-config.js gs://${WBUCKET}
CACHE_SETTING="Cache-Control:no-cache, max-age=0"
gsutil setmeta -h "${CACHE_SETTING}" gs://${WBUCKET}/app-config.js
popd > /dev/null

