cache = require 'gulp-cached'
coffee = require 'coffee-script'
gulp = require 'gulp'
map = require 'vinyl-map'
notify = require 'gulp-notify'
path = require 'path'
rename = require 'gulp-rename'
plumber = require 'gulp-plumber'
util = require 'gulp-util'

[LIB, BIN] = (path.join __dirname, loc for loc in ['lib/**/*.coffee', 'bin/'])


gulp.task 'watch', ->
  gulp.watch LIB, ['coffee']

gulp.task 'coffee', ->
  gulp.src LIB
    .pipe plumber errorHandler: notify.onError 'Error: <%= error.message %>'
    .pipe cache 'coffee'
    .pipe map (contents) -> coffee.compile contents.toString()
    .pipe rename extname: '.js'
    .pipe gulp.dest BIN
    .pipe notify
      onLast: yes
      title: 'Gulp: coffee'
      message: 'Finished compiling lib'

gulp.task 'default', ['coffee'], ->
  util.beep()
