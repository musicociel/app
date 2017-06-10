#!/bin/bash

function echoTask() {
  echo ''
  echo "> $@"
}

if ! npm run semantic-release pre ; then
  echo "Not publishing a new release."
  exit 0
fi

echoTask 'openssl aes-256-cbc -K $encrypted_dfa60c7f1074_key -iv $encrypted_dfa60c7f1074_iv -in publish/.publish.tar.bz2.enc -out publish/.publish.tar.bz2 -d' &&
openssl aes-256-cbc -K $encrypted_dfa60c7f1074_key -iv $encrypted_dfa60c7f1074_iv -in publish/.publish.tar.bz2.enc -out publish/.publish.tar.bz2 -d &&

echoTask 'tar -C publish -jxf publish/.publish.tar.bz2' &&
tar -C publish -jxf publish/.publish.tar.bz2 &&

echoTask 'mkdir platforms/android/src/main' &&
mkdir platforms/android/src/main &&

echoTask 'ln -s ../../../../publish/play platforms/android/src/main/play' &&
ln -s ../../../../publish/play platforms/android/src/main/play &&

echoTask 'patch -d platforms/android < publish/build.gradle.diff' &&
patch -d platforms/android < publish/build.gradle.diff &&

echoTask './node_modules/.bin/cordova build android --release -- --keystore=$PWD/publish/keystore.jks --password=$jks_password --storePassword=$jks_password --alias=uploadkey' &&
./node_modules/.bin/cordova build android --release -- --keystore=$PWD/publish/keystore.jks --password=$jks_password --storePassword=$jks_password --alias=uploadkey &&

echoTask 'npm publish' &&
npm publish &&

echoTask 'npm run semantic-release post' &&
npm run semantic-release post
