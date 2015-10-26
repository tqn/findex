_ = require 'highland'
map = require 'vinyl-map'
program = require 'commander'
vbuffer = require 'vinyl-buffer'

init = require './init'

indexer = -> _.pipeline(
  _.through vbuffer,
  # _.consume doesn't work for some reason
  (s) -> s.consume (err, file, push, next) ->
    setImmediate ->
      # Return empty if no error
      if err
        push err
        next()
      else if file is _.nil or file.isNull()
        push null, file
      else
        init.es.index
          index: init.index
          type: init.type
          body:
            url: file.contents.toString()
            user: init.user ? undefined
            status: 0
        , next
)


module.exports = indexer
