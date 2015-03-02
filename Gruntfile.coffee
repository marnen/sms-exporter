module.exports = (grunt) ->
  buildDir = 'build/'
  coffeeFiles = '**/*.coffee'
  hamlFiles = '**/*.haml'
  sourceDir = 'source'

  replaceExtension = (path, extension) ->
    path.replace /\.[^.]+$/, extension
  removePathPrefix = (prefix, path) ->
    path.replace new RegExp("^#{prefix}\\/"), ''

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-haml'
  grunt.loadNpmTasks 'grunt-shell'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      all:
        expand: true
        cwd: buildDir
        src: '**/*'
      js:
        expand: true
        cwd: buildDir
        src: '**/*.js'
      html:
        expand: true
        cwd: buildDir
        src: '**/*.html'
    coffee:
      options:
        sourceMap: true
      build:
        expand: true
        cwd: sourceDir
        src: coffeeFiles
        dest: buildDir
        ext: '.js'
        extDot: 'last'
    copy:
      package:
        src: 'package.json'
        dest: buildDir
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
    shell:
      run:
        command: "node-webkit #{buildDir}"
    watch:
      options:
        spawn: false
        cwd: {files: sourceDir}
      coffee:
        files: coffeeFiles
        options:
          event: ['added', 'changed']
        tasks: 'coffee:build'
      coffeeDelete:
        files: coffeeFiles
        options:
          event: 'deleted'
        tasks: 'clean:js'
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
      package:
        options:
          spawn: true
          cwd: ''
        files: 'package.json'
        tasks: 'copy:package'

  grunt.registerTask 'run', 'Run the application.', ['shell:run']
  grunt.registerTask 'build', 'Clean out build directory and then build HTML and JavaScript into it.', ['clean:all', 'haml:build', 'coffee:build', 'copy:package']

  grunt.event.on 'watch', (action, path, target) ->
    relativePath = removePathPrefix(sourceDir, path)

    switch target
      when 'coffee'
        grunt.config 'coffee.build.src', relativePath
      when 'coffeeDelete'
        grunt.config 'clean.js.src', replaceExtension(relativePath, '.js')
      when 'haml'
        grunt.config 'haml.build.src', relativePath
      when 'hamlDelete'
        grunt.config 'clean.html.src', replaceExtension(relativePath, '.html')
