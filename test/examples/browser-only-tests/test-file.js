const path = require('path');
const SWTestingHelpers = require('../../../src/index.js');

const testingHelper = new SWTestingHelpers(path.join(__dirname, '..'));
testingHelper.registerAllTests();
