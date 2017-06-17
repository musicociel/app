#!/bin/bash

function echoTask() {
  echo ''
  echo "> $@"
}

export APK_VERSION="$(node -e 'console.log(require("./package.json").version)')"
export FDROID_SERVER="$PWD/publish/fdroidserver"
export FDROID_REPO="$PWD/publish/fdroid"
export jks_file="$PWD/publish/keystore.jks"

echoTask 'curl -O https://s3.amazonaws.com/travis-python-archives/binaries/ubuntu/12.04/x86_64/python-3.6.tar.bz2' &&
curl -O https://s3.amazonaws.com/travis-python-archives/binaries/ubuntu/12.04/x86_64/python-3.6.tar.bz2 &&

echoTask 'sudo tar xjf python-3.6.tar.bz2 --directory /' &&
sudo tar xjf python-3.6.tar.bz2 --directory / &&

echoTask 'source ~/virtualenv/python3.6/bin/activate' &&
source ~/virtualenv/python3.6/bin/activate &&

echoTask 'python --version' &&
python --version &&

echoTask 'pip --version' &&
pip --version &&

echoTask 'pip install fdroidserver' &&
pip install fdroidserver &&

echoTask 'openssl aes-256-cbc -K $encrypted_2c96595a2e49_key -iv $encrypted_2c96595a2e49_iv -in publish/.publish.tar.bz2.enc -out publish/.publish.tar.bz2 -d' &&
openssl aes-256-cbc -K $encrypted_2c96595a2e49_key -iv $encrypted_2c96595a2e49_iv -in publish/.publish.tar.bz2.enc -out publish/.publish.tar.bz2 -d &&

echoTask 'tar -C publish -jxf publish/.publish.tar.bz2' &&
tar -C publish -jxf publish/.publish.tar.bz2 &&

echoTask 'git clone --depth 1 "https://$GH_TOKEN@github.com/musicociel/fdroid.git" "$FDROID_REPO"' &&
git clone --depth 1 "https://$GH_TOKEN@github.com/musicociel/fdroid.git" "$FDROID_REPO" &&

echoTask 'node publish/fdroidMetadata.js' &&
node publish/fdroidMetadata.js &&

echoTask 'cp "$PWD/platforms/android/build/outputs/apk/android-debug.apk" "publish/fdroid/repo/musicociel-$APK_VERSION.apk"' &&
cp "$PWD/platforms/android/build/outputs/apk/android-debug.apk" "publish/fdroid/repo/musicociel-$APK_VERSION.apk" &&

echoTask 'cd "$FDROID_REPO" && fdroid update' &&
( cd "$FDROID_REPO" && fdroid update ) &&

echoTask 'cd "$FDROID_REPO" && git config user.name "Release Bot" && git config user.email "divde@musicociel.fr"' &&
( cd "$FDROID_REPO" && git config user.name "Release Bot" && git config user.email "divde@musicociel.fr" ) &&

echoTask 'cd "$FDROID_REPO" && git add -A && git commit -m "Version $APK_VERSION"' &&
( cd "$FDROID_REPO" && git add -A && git commit -m "Version $APK_VERSION" ) &&

true
