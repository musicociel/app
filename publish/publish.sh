#!/bin/bash

patch -d platforms/android < publish/build.gradle.diff &&
./node_modules/.bin/cordova build android --release -- --keystore=$PWD/publish/keystore.jks --password=$jks_password --storePassword=$jks_password --alias=uploadkey &&
npm publish
