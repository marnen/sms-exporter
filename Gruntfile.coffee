module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-haml'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    haml:
      options:
        language: 'coffee'
      build:
        expand: true
        cwd: 'source'
        src: '**/*.haml'
        dest: 'build'
        ext: '.html'
        extDot: 'last'
    watch:
      haml:
        cwd: {files: 'source'}
        files: '**/*.haml'
        tasks: 'haml'
        options:
          spawn: false

  grunt.event.on 'watch', (_, path) ->
    grunt.config 'haml.build.src', path.substring(path.indexOf('/') + 1)
