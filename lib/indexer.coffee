map = require 'vinyl-map'
program = require 'commander'
init = require './init'

indexer = map (contents, filename) ->
  # Return empty if no error
  init.es.index
    index: init.index
    type: init.type
    body:
      url: contents.toString()
      user: program.user ? init.config.user
      status: 0
  .catch -> throw err if err?

  return contents


module.exports = -> indexer
