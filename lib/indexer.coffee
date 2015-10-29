_ = require 'highland'
program = require 'commander'
vbuffer = require 'vinyl-buffer'

init = require './init'

indexer = -> _.pipeline(
  _.through vbuffer()
  _.map (file) -> _ init.es.index
    index: init.index
    type: init.type
    body: init.replaceTemplate init.doc, url: file.contents.toString()
  _.parallel Infinity # Infinite db indexes at once
)


module.exports = indexer
