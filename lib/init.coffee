_ = require 'highland'
CSON = require 'season'
elasticsearch = require 'elasticsearch'
path = require 'path'
program = require 'commander'
template = require 'lodash.template'

configfile = CSON.readFileSync path.join __dirname, '../config.cson'


exports = module.exports = (config = configfile) ->
  # Get config defaults
  config = _.extend config, configfile if config isnt configfile
  exports[k] = program[k] ? v for own k, v of config
  exports.es = new elasticsearch.Client
    host: exports.host
    apiVersion: '1.7'

  for own k, v of exports when !v?
    throw new Error "#{k} not defined"



exports.replaceTemplate = (obj, opts) ->
  return switch typeof obj
    when 'string' then template(obj, evaluate: /(?!)/) opts
    when 'object'
      newObj = {}
      newObj[k] = exports.replaceTemplate v, opts for own k, v of obj
      newObj
    else obj
