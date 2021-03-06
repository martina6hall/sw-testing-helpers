const seleniumAssistant = require('selenium-assistant');

const promises = [
  seleniumAssistant.downloadLocalBrowser('chrome', 'stable', 48),
  seleniumAssistant.downloadLocalBrowser('chrome', 'beta', 48),
  seleniumAssistant.downloadLocalBrowser('chrome', 'unstable', 48),
  seleniumAssistant.downloadLocalBrowser('firefox', 'stable', 48),
  seleniumAssistant.downloadLocalBrowser('firefox', 'beta', 48),
  seleniumAssistant.downloadLocalBrowser('firefox', 'unstable', 48)
];

Promise.all(promises)
.then(() => {
  console.log('Browser download complete.');
})
.catch(err => {
  console.log('Failed to download browsers.', err);
});
