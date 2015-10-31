path = require 'path'
program = require 'commander'

crawler = require './crawler'
indexer = require './indexer'
init = require './init'


run = (opts = speak: yes) ->
  crawler program.args
    .through indexer()
    .stopOnError (err) -> throw err
    .toArray (xs) -> console.log "Processed #{xs.length} URLs." if opts.speak

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
    .option '-u, --user [name]', 'Overwrite user'
    .parse process.argv


  # Launch the crawler.
  if program.args.length is 0 then program.help()
  else
    init()
    run()

else # the program is require()d
  module.exports = (opts) ->
    init opts
    run speak: no
