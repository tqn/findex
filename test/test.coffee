{exec} = require 'child_process'
{expect} = require 'chai'
path = require 'path'
vfs = require 'vinyl-fs'

init = require '../lib/init'


init
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



describe 'findex', ->
  @timeout 30000


  describe 'the command line program', ->
    @timeout 30000
    @slow 3500


    describe 'called with correct arguments', ->

      it 'should index successfully', (done) ->
        exec "node ../bin/index.js -i #{init.index}
          -t commandline ./fixtures/url/",
          cwd: __dirname, (err, stdout, stderr) ->
            # Make sure exec didn't have any issues
            expect(err).to.not.exist
            expect(stderr).to.be.empty
            done()

      it 'should be able to use a customizable document', (done) ->
        exec "node ../bin/index.js -i #{init.index}
          -t customdoc ./fixtures/url/folder2/",
          cwd: __dirname, (err, stdout, stderr) ->
            expect(err).to.not.exist
            expect(stderr).to.be.empty
            # For ping delay
            setTimeout ->
              init.es.search
                index: init.index
                type: 'customdoc'
                body: query: match_all: {}
              .then (res) ->
                expect(res.hits.hits[0]._source).to.deep.equal(
                  init.replaceTemplate init.doc, url: 'http://en.wikipedia.org/'
                )
                done()
              .catch done
            , 2000

    describe 'called with incorrect arguments', ->

      it 'should output --help when called with no arguments', (done) ->
        # Execute the program in a child process
        # Otherwise it would use the test's arguments
        exec 'node ../bin/index.js', cwd: __dirname, (err, stdout, stderr) ->
          expect(err).to.not.exist
          expect(stderr).to.be.empty
          expect(stdout.toString()).to.match /^\s*Usage:/
          done()

      it 'should have errors when called with invalid arguments', (done) ->
        exec 'node ../bin/index.js ./fixtures/url/',
          cwd: __dirname, (err, stdout, stderr) ->
            expect(err).to.exist
            expect(stderr).to.not.be.empty
            done()



  describe 'the file system crawler', ->
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
        .each (file) -> expect(VALID).to.contain file.path
        .done done

  describe 'the document indexer', ->
    @timeout 30000
    @slow 2000

    it 'should index file contents into elasticsearch', (done) ->
      # init with a specific index and type
      indexer = require '../lib/indexer'
      # Get a test file to be sent to elasticsearch
      vfs.src normalize ['test/fixtures/test.file']
        .pipe indexer()
        .done done

  # Clean up the index
  after 'elasticsearch index cleanup', (done) ->
    # Wait for any ping issues
    setTimeout ->
      init.es.indices.delete index: init.index, ignore: [404], done
    , 2000
