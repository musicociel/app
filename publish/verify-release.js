const fs = require('fs');
const util = require('util');
const path = require('path');

const readFile = util.promisify(fs.readFile);
const writeFile = util.promisify(fs.writeFile);

const versionRegExp = /0\.0\.0-placeholder/g;

async function setVersionInFile(version, fileName) {
  const originalFileContent = await readFile(fileName, 'utf-8');
  const modifiedFileContent = originalFileContent.replace(versionRegExp, version);
  if (originalFileContent !== modifiedFileContent) {
    console.log(`Setting version ${version} in ${fileName}`);
    await writeFile(fileName, modifiedFileContent);
  }
}

async function verifyRelease(pluginConfig, config) {
  const nextRelease = config.nextRelease.version;
  await setVersionInFile(nextRelease, path.join(__dirname, '..', 'config.xml'));
}

module.exports = function (pluginConfig, config, callback) {
  verifyRelease(pluginConfig, config).then((result) => callback(null, result), callback);
};
