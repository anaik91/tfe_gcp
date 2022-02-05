#!/bin/bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -e

install_gcloud() {
    curl --fail -L -o "$HOME/gcloud-sdk.tar.gz" "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-367.0.0-linux-x86_64.tar.gz"
    tar xvzf "$HOME/gcloud-sdk.tar.gz" -C "$HOME"
    chmod +x "$HOME/google-cloud-sdk/install.sh"
    "$HOME"/google-cloud-sdk/install.sh -q --path-update true
    source "$HOME/google-cloud-sdk/completion.bash.inc"
    source "$HOME/google-cloud-sdk/path.bash.inc"
}

install_gcloud
gcloud version --format=json
gcloud config list --format=json

echo ${GOOGLE_CREDENTIALS}