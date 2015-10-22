exec = require('child_process').exec
expect = require('chai').expect
map = require 'vinyl-map'
path = require 'path'
vfs = require 'vinyl-fs'

init = require '../lib/init'


init
  host: 'localhost:9200'
  index: ".test-findex-#{Date.now()}"
  type: 'indexer' # used by the last test

# Create a function to normalize and make paths absolute
normalize = (paths = []) ->
  # Work with strings and arrays
  if paths instanceof String
    paths = [paths]
    isString = yes
  paths = (path.resolve p for p in paths)
  # Return a string if given a string
  paths = paths[0] if isString
  return paths




describe 'The command line program', ->
  @timeout 30000
  @slow 700

  it 'should output --help when called with no arguments', (done) ->
    # Execute the program in a child process
    # Otherwise it would use the test's arguments
    exec 'node ../bin/index.js', cwd: __dirname, (err, stdout, stderr) ->
      expect(err).to.not.exist
      expect(stderr).to.be.empty
      expect(stdout.toString()).to.match /^\s*Usage:/
      done()

  it 'should index .url files into elasticsearch', (done) ->
    exec "node ../bin/index.js -i #{init.index} -t commandline ./fixtures/url/",
      cwd: __dirname, (err, stdout, stderr) ->
        # Make sure exec didn't have any issues
        expect(err).to.not.exist
        expect(stderr).to.be.empty
        # Delete the temporary index
        init.es.indices.delete index: init.index, done

  it 'should have errors when called with invalid arguments', (done) ->
    exec 'node ../bin/index.js ./fixtures/url/',
      cwd: __dirname, (err, stdout, stderr) ->
        expect(err).to.not.exist
        expect(stderr).to.not.be.empty
        done()

  it 'should have a configurable elasticsearch document to index'

describe 'The file system crawler', ->
  @timeout 2000
  @slow 70

  # Import crawler
  crawler = require '../lib/crawler'

  it 'should retrieve .url files', (done) ->
    # Valid file array to check against
    VALID = normalize [
      'test/fixtures/url/folder1/nested/real-2.url'
      'test/fixtures/url/folder1/real.url'
      'test/fixtures/url/folder2/real-3.url'
    ]
    # Director names to validate
    DIRS = normalize ("test/fixtures/url/folder#{n}" for n in [1..2])
    # Call crawler with fixtures and assert that they are equal
    crawler DIRS
      .pipe map (contents, filename) ->
        expect(VALID).to.contain filename
        return contents
      .on 'end', done

describe 'The document indexer', ->
  @timeout 30000
  @slow 6000

  it 'should index file contents into elasticsearch', (done) ->
    # init with a specific index and type

    indexer = require '../lib/indexer'


    # Get a test file to be sent to elasticsearch
    vfs.src normalize ['test/fixtures/test.file']
      .pipe indexer()
      .on 'end', ->
        # Wait for any ping issues
        setTimeout ->
          init.es.indices.delete index: init.index, done
        , 5000
