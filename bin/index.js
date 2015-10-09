(function() {
  var crawler, path, program;

  path = require('path');

  program = require('commander');

  crawler = require('./crawler');

  program.usage('[options] <directory ...>').version(require(path.join(__dirname, '../package.json')).version).option('-s, --server', 'Overwrite config.json server').parse(process.argv);

  crawler();

}).call(this);
