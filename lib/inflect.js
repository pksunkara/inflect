// Requiring modules
require('./utils/array');
require('./utils/string');

module.exports = require('./methods');

require('./utils/inflect')(module.exports);
