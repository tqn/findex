# findex

[![GitHub release](https://img.shields.io/github/release/tqn/findex.svg?style=flat-square)](https://github.com/tqn/findex/releases/latest)
[![Travis](https://img.shields.io/travis/tqn/findex.svg?style=flat-square&branch=master)](https://travis-ci.org/tqn/findex)
[![Coveralls](https://img.shields.io/coveralls/tqn/findex.svg?style=flat-square)](https://coveralls.io/github/tqn/findex)
[![David](https://img.shields.io/david/tqn/findex.svg?style=flat-square)](https://david-dm.org/tqn/findex#info=dependencies)
[![David](https://img.shields.io/david/dev/tqn/findex.svg?style=flat-square)](https://david-dm.org/tqn/findex#info=devDependencies)

Crawls a directory you give it to to search for `.url` files, then indexes those URLs into [Elasticsearch](https://www.elastic.co/products/elasticsearch).

## Setup
1. Install this package globally with `npm i -g tqn/findex#[VERSION TAG]`.
2. Invoke with `findex`. Find usage with `findex --help`

### To Configure
1. Run `npm bin` to find the location of this installed package.
2. Edit `config.cson` with the host you want to use, the elasticsearch index, and the elasticsearch type.

## Todo
- [ ] Increase coverage.
