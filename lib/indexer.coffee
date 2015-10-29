_ = require 'highland'
program = require 'commander'
vbuffer = require 'vinyl-buffer'

init = require './init'

indexer = -> _.pipeline(
  _.through vbuffer()
  _.map (file) -> _ init.es.index
    index: init.index
    type: init.type
    body:
      url: file.contents.toString()
      user: init.user ? undefined
      status: 0
  _.parallel Infinity # Infinite db indexes at once
)


module.exports = indexer
