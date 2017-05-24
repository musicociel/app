const path = require('path');
const recursiveCopy = require('recursive-copy');
const webappPath = path.join(__dirname, 'node_modules', '@musicociel', 'webapp', 'build', 'output');

const assetsFolder = {
  android: 'assets/www',
  browser: 'www'
};

module.exports = async function (context) {
  const platforms = context.opts.platforms;
  for (const platform of platforms) {
    const folder = assetsFolder[platform];
    if (folder) {
      const destinationFolder = path.join(context.opts.projectRoot, 'platforms', platform, folder);
      console.log(`Copying files in ${destinationFolder}`);
      await recursiveCopy(webappPath, destinationFolder, {
        overwrite: true
      });
    }
  }
};
