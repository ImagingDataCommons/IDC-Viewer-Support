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

if [ "$#" -ne 1 ]; then
    echo "Usage: ./prepare_config.sh [latest | release]"
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

cp ../static_files/app-config-template.js ~/scratch/app-config-template.js
cat ~/scratch/app-config-template.js | sed "s#_X___IDC__Z__ROOT___Y_#${STORE_ROOT}#" | sed "s#_X___IDC__Z__QUOTA___Y_#${QUOTA_PAGE}#" >  ~/scratch/app-config.js



