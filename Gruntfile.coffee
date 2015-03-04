module.exports = (grunt) ->
  buildDir = 'build/'
  coffeeFiles = '**/*.coffee'
  featureDir = 'features/'
  featureFiles = '**/*.feature'
  hamlFiles = '**/*.haml'
  currentDir = process.env.PWD
  sassFiles = ['**/*.scss', '**/*.sass']
  sourceDir = 'source'
  testDir = 'test'
  testFiles = ['**/*.coffee', '**/*.js']

  extension = (path) ->
    path.match(/\.([^.]+)$/)[1]
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
  grunt.loadNpmTasks 'grunt-sass'

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
        src: ['**/*.js', '**/*.js.map']
      html:
        expand: true
        cwd: buildDir
        src: '**/*.html'
      css:
        expand: true
        cwd: buildDir
        src: ['**/*.css', '**/*.css.map']
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
    sass:
      options:
        sourceMap: true
        includePaths: ['node_modules/foundation-apps/scss/']
      build:
        expand: true
        cwd: sourceDir
        src: sassFiles
        dest: buildDir
        ext: '.css'
        extDot: 'last'
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
        files: '**/*'
        options:
          cwd: {files: featureDir}
        tasks: 'protractor:cucumber'
      grunt:
        files: 'Gruntfile.coffee'
        options:
          cwd: currentDir
        tasks: []
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
          cwd: currentDir
        files: 'package.json'
        tasks: 'copy:package'
      sass:
        files: sassFiles
        options:
          event: ['added', 'changed']
        tasks: 'sass:build'
      sassDelete:
        files: sassFiles
        options:
          event: 'deleted'
        tasks: 'clean:css'

  grunt.registerTask 'build', 'Clean out build directory and then build HTML and JavaScript into it.', ['clean:all', 'haml:build', 'coffee:build', 'copy:package']

  grunt.event.on 'watch', (action, path, target) ->
    sourcePath = removePathPrefix(sourceDir, path)
    extensionMappings =
      coffee: 'js'
      haml: 'html'
      sass: 'css'

    if target == 'cucumber'
      specs = if path.match(/\.feature$/) then [path] else [featureDir + featureFiles]
      grunt.config 'protractor.cucumber.options.args.specs', specs
    else if action == 'deleted'
      sourceExtension = extension path
      targetExtension = extensionMappings[sourceExtension]
      targetPath = replaceExtension sourcePath, ".#{targetExtension}"

      grunt.config "clean.#{targetExtension}.src", [targetPath, "#{targetPath}.map"]
    else
      grunt.config "#{target}.build.src", sourcePath
