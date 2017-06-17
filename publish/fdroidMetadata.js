const fs = require('fs');
const util = require('util');
const path = require('path');

const readFile = util.promisify(fs.readFile);
const writeFile = util.promisify(fs.writeFile);

async function readProperty(...pathParts) {
  const fileContent = await readFile(path.join(__dirname, 'play', ...pathParts), 'utf-8');
  return fileContent.trim();
}

async function writeMetadata() {
  const language = await readProperty('defaultLanguage');

  const metadata =
`License:AGPL
Web Site:${await readProperty('contactWebsite')}
Source Code:https://github.com/musicociel/webapp
Issue Tracker:https://github.com/musicociel/webapp/issues
Name:${await readProperty(language, 'listing', 'title')}
Summary:${await readProperty(language, 'listing', 'shortdescription')}
Description:
${await readProperty(language, 'listing', 'fulldescription')}
.
`;

  await writeFile(path.join(process.env.FDROID_REPO, 'metadata', 'fr.musicociel.txt'), metadata);
}

writeMetadata().catch((error) => {
  console.error(error);
  process.exit(1);
});
