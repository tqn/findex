_ = require 'highland'
program = require 'commander'
vbuffer = require 'vinyl-buffer'

init = require './init'

indexer = -> _.pipeline(
  _.through(vbuffer()),
  _.consume (err, file, push, next) ->
    # Create a function for one liners
    pushNext = ->
      push arguments...
      next()

    setImmediate ->
      # Return empty if no error
      if err?
        pushNext err
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
        .then (res) -> pushNext null, res
        .catch next
)


module.exports = indexer
