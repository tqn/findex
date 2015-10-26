_ = require 'highland'
map = require 'vinyl-map'
path = require 'path'
vbuffer = require 'vinyl-buffer'
vfs = require 'vinyl-fs'

# The crawler.
crawler = (dirs) ->
  _ vfs.src (path.join dir, "**#{path.sep}*.url" for dir in dirs)
    .through vbuffer()
    .reject (file) -> file.isNull() or file.contents.length is 0
    .map (file) ->
      match =
        /\[InternetShortcut\](?:\r\n?|\n)URL=(.+)/.exec file.contents.toString()
      # Empty the invalid files
      if match?
        file = file.clone()
        file.contents = new Buffer match[1]
        return file
    .compact()

module.exports = crawler
