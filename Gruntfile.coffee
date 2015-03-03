module.exports = (grunt) ->
  buildDir = 'build/'
  coffeeFiles = '**/*.coffee'
  featureDir = 'features/'
  featureFiles = '**/*.feature'
  hamlFiles = '**/*.haml'
  sourceDir = 'source'
  testDir = 'test'
  testFiles = ['**/*.coffee', '**/*.js']

  replaceExtension = (path, extension) ->
    path.replace /\.[^.]+$/, extension
  removePathPrefix = (prefix, path) ->
    path.replace new RegExp("^#{prefix}\\/"), ''

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-haml'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-protractor-runner'

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
    mochaTest:
      test:
        expand: true
        cwd: testDir
        src: testFiles
    protractor:
      cucumber:
        options:
          configFile: 'protractor.conf.js'
          args:
            framework: 'cucumber'
            cucumberOpts:
              require: ['features/support/**/*', 'features/step_definitions/**/*']
            specs: [featureDir + featureFiles]
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
      cucumber:
        files: featureFiles
        options:
          cwd: {files: featureDir}
        tasks: 'protractor:cucumber'
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
      mocha:
        files: testFiles
        options:
          spawn: true
          cwd: {files: testDir}
        tasks: 'mochaTest:test'
      package:
        options:
          spawn: true
          cwd: ''
        files: 'package.json'
        tasks: 'copy:package'

  grunt.registerTask 'build', 'Clean out build directory and then build HTML and JavaScript into it.', ['clean:all', 'haml:build', 'coffee:build', 'copy:package']

  grunt.event.on 'watch', (action, path, target) ->
    sourcePath = removePathPrefix(sourceDir, path)

    switch target
      when 'coffee'
        grunt.config 'coffee.build.src', sourcePath
      when 'coffeeDelete'
        grunt.config 'clean.js.src', replaceExtension(sourcePath, '.js')
      when 'cucumber'
        grunt.config 'protractor.cucumber.options.args.specs', [path]
      when 'haml'
        grunt.config 'haml.build.src', sourcePath
      when 'hamlDelete'
        grunt.config 'clean.html.src', replaceExtension(sourcePath, '.html')
