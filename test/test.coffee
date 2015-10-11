exec = require('child_process').exec
expect = require('chai').expect
map = require 'vinyl-map'
path = require 'path'

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
  @timeout 2000
  @slow 700

  it 'should output --help when called with no arguments', (done) ->
    # Execute the program in a child process
    # Otherwise it would use the test's arguments
    exec 'node ../bin/index.js', cwd: __dirname, (err, stdout, stderr) ->
      expect(err).to.be.empty
      expect(stderr.toString()).to.be.empty
      expect(stdout.toString()).to.match /^\s*Usage:/
      done()

  it 'should have no errors when called with valid arguments', (done) ->
    exec 'node ../bin/index.js -- ./fixtures/url/',
      cwd: __dirname, (err, stdout, stderr) ->
        # Make sure exec didn't have any issues
        expect(err).to.not.be.an.instanceof Error

        expect(stderr).to.be.empty
        # expect(stdout.toString()).to.match /^\s*$/
        done()

  it 'should have errors when called with invalid arguments'

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
