path = require 'path'
program = require 'commander'
Promise = require 'bluebird'

crawler = require './crawler'
indexer = require './indexer'
init = require './init'


run = (dirs) -> new Promise (resolve, reject) ->
  crawler dirs
    .through indexer()
    .stopOnError reject
    .toArray resolve

# If called from the command line
if path.relative(
  path.parse(module.parent.filename).dir
  path.join __dirname, '../bin'
).length is 0
  # Create the commander program.
  program
    .usage '[options] <directory ...>'
    .version require(path.join __dirname, '../package.json').version
    .option '-h, --host [name]', 'Overwrite elasticsearch host'
    .option '-i, --index [name]', 'Overwrite elasticsearch index'
    .option '-t, --type [name]', 'Overwrite elasticsearch type'
    .option '-c, --config', 'Print location of config file'
    .parse process.argv


  # Launch the crawler.
  if program.config
    console.log path.join __dirname, '../config.cson'
  else
    if program.args.length is 0 then program.help()
    else
      init()
      run program.args
      .then (xs) -> console.log "Processed #{xs.length} URLs."
      .catch (err) -> throw err

else # the program is require()d
  module.exports = (opts, dirs, callback) -> new Promise (resolve, reject) ->
    init opts
    promise = run dirs
    if callback?
      promise
      .then (xs) -> callback null, xs
      .catch callback
    else
      resolve promise
