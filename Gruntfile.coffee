module.exports = (grunt) ->
  hamlFiles = '**/*.haml'
  sourceDir = 'source'

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-haml'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    haml:
      options:
        language: 'coffee'
      build:
        expand: true
        cwd: sourceDir
        src: hamlFiles
        dest: 'build'
        ext: '.html'
        extDot: 'last'
    watch:
      haml:
        cwd: {files: sourceDir}
        files: hamlFiles
        tasks: 'haml:build'
        options:
          spawn: false

  grunt.event.on 'watch', (_, path) ->
    grunt.config 'haml.build.src', path.replace(new RegExp("^#{sourceDir}\\/"), '')