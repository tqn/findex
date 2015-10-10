map = require 'vinyl-map'
clip = require 'gulp-clip-empty-files'
path = require 'path'
vfs = require 'vinyl-fs'

# The crawler.
crawler = (dirs) ->
  vfs.src (path.join dir, '**/*.url' for dir in dirs)
    .pipe map (contents, filename) ->
      match =
        /\[InternetShortcut\](?:\r\n?|\n)URL=(.+)/.exec contents?.toString()
      # Empty the invalid files
      return if match? then match[1] else ''
    # Delete those empty files!
    .pipe clip()

module.exports = crawler
