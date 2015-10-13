#!/usr/bin/env node
path = require 'path'
program = require 'commander'

crawler = require './crawler'
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

init()

# Launch the crawler.
unless program.args.length is 0
  unless program.user?.length or init.config.user?
    console.log 'No user provided'
    program.help()
  else
    crawler program.args
else
  program.help()
