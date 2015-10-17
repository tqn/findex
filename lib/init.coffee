CSON = require 'season'
elasticsearch = require 'elasticsearch'
events = require 'events'
path = require 'path'
program = require 'commander'

configfile = CSON.readFileSync path.join __dirname, '../config.cson'


module.exports = ->
  ((@config = configfile) ->
    @host = program.host ? @config.host
    @index = program.index ? @config.index
    @type = program.type ? @config.type
    @es = new elasticsearch.Client
      host: program.host ? @config.host
      apiVersion: '1.7'
    @user = program.user ? @config.user ? ''

    # @es.ping {}, (err) -> throw err if err?

  ).apply(module.exports, arguments)

  for own k, v of module.exports when !v?
    console.error "#{k} not defined"
    return false

  return true
