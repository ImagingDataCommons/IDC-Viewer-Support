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

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y	git

#
# Following instructions at https://classic.yarnpkg.com/ and
# https://github.com/nodesource/distributions/blob/master/README.md#deb
#

curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt-get install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get install yarn

#
# Get the Viewers and the Viewer Support repos in:
#

git clone https://github.com/OHIF/Viewers.git
git clone https://github.com/ImagingDataCommons/IDC-Viewer-Support.git

cd ~/Viewers
git pull

cd ~/IDC-Viewer-Support
git pull

#git checkout [-q] [-f] [-m] [<branch>]
#git checkout tags/<tag> -b <branch>
#git fetch --all --tags
#cd Viewers

