#!/usr/bin/env node
path = require 'path'
program = require 'commander'

crawler = require './crawler'
indexer = require './indexer'
init = require './init'

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
if program.args.length isnt 0 and init()
  crawler program.args
    .pipe indexer()
else
  program.help()
