expect = require('chai').expect
map = require 'vinyl-map'
path = require 'path'


describe 'The file system crawler', ->
  @timeout 10000

  it 'should retrieve .url files', (done) ->
    # Create a function to normalize and make paths absolute
    normalize = (paths = []) -> path.resolve p for p in paths
    # Valid file array to check against
    VALID = normalize [
      'test/fixtures/url/folder1/nested/real-2.url'
      'test/fixtures/url/folder1/real.url'
      'test/fixtures/url/folder2/real-3.url'
    ]
    # Director names to validate
    DIRS = normalize ("test/fixtures/url/folder#{n}" for n in [1..2])
    # Import crawler
    crawler = require '../lib/crawler'
    # Call crawler with fixtures and assert that they are equal
    crawler DIRS
      .pipe map (contents, filename) ->
        expect(VALID).to.contain(filename)
        return contents
      .on 'end', done
