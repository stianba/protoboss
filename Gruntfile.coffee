module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    connect:
      options:
        port: 8000
        livereload: true
      livereload:
        options:
          open: true
          middleware: (connect) ->
            [
              connect().use(
                '/bower_components'
                connect.static './bower_components' 
              )
              connect.static 'app'
            ]

    watch:
      options:
        livereload: true
      jade:
        files: './app/**/*.jade'
        tasks: ['jade']
      sass:
        files: './app/scss/**/*.scss'
        tasks: ['scsslint', 'sass']
      coffee:
        files: './app/**/*.coffee'
        tasks: ['coffeelint', 'coffee']

    scsslint:
      options:
        config: null
      src: ['./app/scss/**/*.scss']

    sass:
      options:
        includePaths: [
          './bower_components/foundation/scss'
        ]
      dist:
        files:
          './app/css/main.css': './app/scss/main.scss'

    coffeelint:
      src: ['./app/**/*.coffee']

    coffee:
      compile:
        files: [
          expand: true
          cwd: 'app'
          src: '**/*.coffee'
          dest: 'app'
          ext: '.js'
        ]

    jade:
      compile:
        options:
          pretty: true
          data:
            debug: false
        files: [
          expand: true
          cwd: 'app/views'
          src: ['**/*.jade', '!**/_*.jade']
          dest: 'app'
          ext: '.html'
        ]

    useminPrepare:
      html: ['app/*.html']
      options:
        dest: 'dist'

    usemin:
      html: 'dist/**/*.html'
      css: 'dist/css/**/*.css'
      js: 'dist/scripts/**/*.js'
      options:
        dirs: ['dist']

    clean: ['dist']

    copy:
      publish:
        files: [{
          expand: true
          cwd: 'app'
          src: ['*.html']
          dest: 'dist/'
        }
        {
          expand: true
          dot: true
          cwd: './bower_components/font-awesome'
          src: ['fonts/*.*']
          dest: 'dist'
        }]

  grunt.registerTask 'default', ['jade', 'scsslint', 'sass', 'coffeelint', 'coffee', 'connect', 'watch']
  grunt.registerTask 'publish', ['jade', 'scsslint', 'sass', 'coffeelint', 'coffee', 'clean', 'useminPrepare', 'copy:publish', 'concat', 'cssmin', 'uglify', 'usemin']