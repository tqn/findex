elasticsearch = require 'elasticsearch'
events = require 'events'
program = require 'commander'

configfile = require '../config.cson'



module.exports = ->
  ((@config = configfile) ->
    @host = program.host ? @config.host
    @index = program.index ? @config.index
    @type = program.type ? @config.type
    @es = new elasticsearch.Client
      host: program.host ? @config.host
      apiVersion: '1.7'

    # @es.ping {}, (err) -> throw err if err?

  ).apply(module.exports, arguments)
