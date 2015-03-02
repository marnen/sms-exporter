module.exports = (grunt) ->
  buildDir = 'build'
  hamlFiles = '**/*.haml'
  sourceDir = 'source'

  replaceExtension = (path, extension) ->
    path.replace /\.[^.]+$/, extension
  removePathPrefix = (prefix, path) ->
    path.replace new RegExp("^#{prefix}\\/"), ''

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-haml'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      html:
        expand: true
        cwd: buildDir
        src: '**/*.html'
    haml:
      options:
        language: 'coffee'
      build:
        expand: true
        cwd: sourceDir
        src: hamlFiles
        dest: buildDir
        ext: '.html'
        extDot: 'last'
    watch:
      options:
        spawn: false
        cwd: {files: sourceDir}
      haml:
        files: hamlFiles
        options:
          event: ['added', 'changed']
        tasks: 'haml:build'
      hamlDelete:
        files: hamlFiles
        options:
          event: 'deleted'
        tasks: 'clean:html'

  grunt.event.on 'watch', (action, path, target) ->
    relativePath = removePathPrefix(sourceDir, path)

    switch target
      when 'haml'
        grunt.config 'haml.build.src', relativePath
      when 'hamlDelete'
        grunt.config 'clean.html.src', replaceExtension(relativePath, '.html')
