gulp         = require 'gulp'
render       = require 'gulp-nunjucks-render'
rename       = require 'gulp-rename'
handleErrors = require '../../lib/handleErrors'
gutil        = require 'gulp-util'
data         = require 'gulp-data'

module.exports = (config) ->
  return (glyphs, options) ->
    gutil.log \
      gutil.colors.blue \
        "Generating #{config.sassDest}/#{config.sassOutputName}"
    render.nunjucks.configure config.nunjucks, watch: false

    return gulp.src config.template
      .pipe data
        icons: glyphs.map (glyph) ->
          gutil.log gutil.colors.green "+ adding #{glyph.name} glyph"
          return \
            name: glyph.name
            code: glyph.unicode[0].charCodeAt(0).toString(16).toUpperCase()

        fontName: config.options.fontName,
        fontPath: config.fontPath,
        className: config.className,
        comment: "
          // DO NOT EDIT DIRECTLY!
          // Generated by gulpfile.js/tasks/iconFont.js
          // from #{config.template}"
      .pipe render path: config.template
    .on 'error', handleErrors
    .pipe rename config.sassOutputName
    .pipe gulp.dest config.sassDest
