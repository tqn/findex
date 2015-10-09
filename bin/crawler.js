(function() {
  var clip, crawler, map, path, vfs;

  map = require('vinyl-map');

  clip = require('gulp-clip-empty-files');

  path = require('path');

  vfs = require('vinyl-fs');

  crawler = function(dirs) {
    var dir;
    if (dirs == null) {
      dirs = require('commander').args;
    }
    return vfs.src((function() {
      var i, len, results;
      results = [];
      for (i = 0, len = dirs.length; i < len; i++) {
        dir = dirs[i];
        results.push(path.join(dir, '**/*.url'));
      }
      return results;
    })()).pipe(map(function(contents, filename) {
      var match;
      match = /\[InternetShortcut\](?:\r\n?|\n)URL=(.+)/.exec(contents != null ? contents.toString() : void 0);
      if (match != null) {
        return match[1];
      } else {
        return '';
      }
    })).pipe(clip());
  };

  module.exports = crawler;

}).call(this);
