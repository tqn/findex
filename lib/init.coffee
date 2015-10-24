CSON = require 'season'
elasticsearch = require 'elasticsearch'
events = require 'events'
path = require 'path'
program = require 'commander'

configfile = CSON.readFileSync path.join __dirname, '../config.cson'


exports = module.exports = (config = configfile) ->
  exports[k] = program[k] ? v for own k, v of config
  exports.es = new elasticsearch.Client
    host: exports.host
    apiVersion: '1.7'

  for own k, v of module.exports when !v?
    console.error "#{k} not defined"
    return false

  return true
