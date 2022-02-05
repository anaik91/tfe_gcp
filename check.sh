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
PROJECT_ID=$1
install_jq() {
    QUICKSTART_TOOLS=$HOME
    JQ_VERSION='jq-1.6/jq-linux64'
    mkdir -p "$QUICKSTART_TOOLS"/jq
    curl --fail -L -o "$QUICKSTART_TOOLS"/jq/jq "https://github.com/stedolan/jq/releases/download/$JQ_VERSION"
    chmod +x "$QUICKSTART_TOOLS"/jq/jq
    export PATH=$PATH:"$QUICKSTART_TOOLS"/jq
}

install_gcloud() {
    if [ -d "$HOME/google-cloud-sdk" ]; then rm -Rf "$HOME/google-cloud-sdk"; fi
    curl --fail -L -o "$HOME/gcloud-sdk.tar.gz" "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-367.0.0-linux-x86_64.tar.gz"
    tar xvzf "$HOME/gcloud-sdk.tar.gz" -C "$HOME"
    chmod +x "$HOME/google-cloud-sdk/install.sh"
    "$HOME"/google-cloud-sdk/install.sh -q --path-update true
    source "$HOME/google-cloud-sdk/completion.bash.inc"
    source "$HOME/google-cloud-sdk/path.bash.inc"
}


install_jq
install_gcloud
gcloud version --format=json
gcloud config list --format=json

echo ${GOOGLE_CREDENTIALS} > /tmp/GOOGLE_CREDENTIALS
# export GOOGLE_APPLICATION_CREDENTIALS=/tmp/GOOGLE_CREDENTIALS
SERVICE_ACCOUNT=$(cat /tmp/GOOGLE_CREDENTIALS | jq -r .client_email)
gcloud auth activate-service-account $SERVICE_ACCOUNT \
            --key-file=/tmp/GOOGLE_CREDENTIALS --project=$PROJECT_ID
gcloud config set project $PROJECT_ID
gcloud config list --format=json
gcloud container images list --format=json