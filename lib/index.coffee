#!/usr/bin/env node
path = require 'path'
program = require 'commander'

crawler = require './crawler'

# Create the commander program.
program
  .usage '[options] <directory ...>'
  .version require(path.join __dirname, '../package.json').version
  .option '-s, --server', 'Overwrite config.json server'
  .parse process.argv

# Launch the crawler.
crawler()
