gulp = require 'gulp'
gutil = require 'gulp-util'
uglify = require 'gulp-uglify'
coffee = require 'gulp-coffee'
watch = require 'gulp-watch'
concat = require 'gulp-concat'
imagemin = require 'gulp-imagemin'
rimraf = require 'rimraf'
flatten = require 'gulp-flatten'
minifycss = require 'gulp-minify-css'
size = require 'gulp-size'
runSequence = require 'run-sequence'
sftp = require 'gulp-sftp'
shell = require 'gulp-shell'
sshConfig = require './config.json'
ssh = require('gulp-ssh')(
  ignoreErrors: false
  sshConfig:
    host: 'app.aghchina.com.cn'
    port: 22
    username: sshConfig.user
    password: sshConfig.pass
  # sshConfig:
  #   host: 'qa.aghchina.com.cn'
  #   port: 22
  #   username: sshConfig.user
  #   password: sshConfig.pass
)

path =
  scripts: 'app/scripts/**/*.coffee'
  styles:  'app/styles/**/*.css'
  bower: 'app/components'
  html: 'app/html/**/*.html'
  assets: 'app/assets/*'
  fonts: ['app/components/materialize/font/**']
  public: '_public/**'
  bin: ['**', '!_public/**', '!app/**', '!data/**', '!node_modules/**', '!test/**']


gulp.task 'scripts', () ->
  gulp.src(path.scripts)
    .pipe(coffee({bare: true}).on 'error', gutil.log)
    .pipe(concat 'app.min.js')
    .pipe(size())
    .pipe(gulp.dest '_public/js')

gulp.task 'uglyscripts', () ->
  gulp.src(path.scripts)
    .pipe(coffee({bare: true}).on 'error', gutil.log)
    .pipe(concat 'app.min.js')
    .pipe(uglify())
    .pipe(size())
    .pipe(gulp.dest '_public/js')

gulp.task 'styles', () ->
  gulp.src(path.styles)
    .pipe(concat 'app.min.css')
    .pipe(minifycss())
    .pipe(size())
    .pipe(gulp.dest '_public/css')

gulp.task 'jquery', () ->
  gulp.src(['app/externaljs/jquery/dist/jquery.min.js','app/externaljs/jquery-ui/jquery-ui.min.js', 'app/externaljs/exportjs/*.js'])
    .pipe(size())
    .pipe(gulp.dest('_public/js'))

gulp.task 'bowerjs', () ->
  gulp.src('app/components/**/*.min.js')
    .pipe(flatten())
    .pipe(concat 'vendor.min.js')
    .pipe(size())
    .pipe(gulp.dest('_public/js'))

gulp.task 'bowercss', () ->
  gulp.src('app/components/**/*.min.css')
    .pipe(flatten())
    .pipe(concat 'vendor.min.css')
    .pipe(size())
    .pipe(gulp.dest('_public/css'))

gulp.task 'html', () ->
  gulp.src(path.html)
    .pipe(size())
    .pipe(gulp.dest '_public')

gulp.task 'assets', () ->
  gulp.src(path.assets)
    .pipe(imagemin({optimizationLevel: 5}))
    .pipe(size())
    .pipe(gulp.dest '_public/assets')

gulp.task 'fonts', () ->
  gulp.src(path.fonts)
    .pipe(size())
    .pipe(gulp.dest '_public/font')

gulp.task 'watch', () ->
  gulp.watch path.scripts, ['scripts']
  gulp.watch path.styles, ['styles']
  gulp.watch path.bower, ['bowerjs']
  gulp.watch path.html, ['html']
  gulp.watch path.assets, ['assets']

gulp.task 'clean', shell.task([
  'rm -rf ./_public'
])

gulp.task 'upload-web-qa', () ->
  gulp.src(path.public)
    .pipe sftp(
      host: 'qa.aghchina.com.cn'
      user: sshConfig.user
      pass: sshConfig.pass
      remotePath: '/root/mngtconsole/_public') 

gulp.task 'upload-bin', () ->
  gulp.src(path.bin)
    .pipe sftp(
      host: 'qa.aghchina.com.cn'
      user: sshConfig.user
      pass: sshConfig.pass
      remotePath: '/root/mngtconsole')

gulp.task 'upload-web-prod', () ->
  gulp.src(path.public)
    .pipe sftp(
      host: 'app.aghchina.com.cn'
      user: sshConfig.user
      pass: sshConfig.pass
      remotePath: '/root/mngtconsole/_public') 

gulp.task 'upload-bin-prod', () ->
  gulp.src(path.bin)
    .pipe sftp(
      host: 'app.aghchina.com.cn'
      user: sshConfig.user
      pass: sshConfig.pass
      remotePath: '/root/mngtconsole')

gulp.task 'clean-remote-web', ()->
  ssh.exec([
    'rm -rf /root/mngtconsole/_public'
  ], filePath: 'commands.log').pipe gulp.dest('.')

gulp.task 'restart-qa', ()->
  ssh.exec([
    'export NODE_ENV=qa;cd /root/mngtconsole;forever stop server.coffee;forever start -c coffee server.coffee', 
    #'export NODE_ENV=qa;cd /root/mngtconsole;forever stop orderscaner.coffee;forever start -c coffee orderscaner.coffee'
  ], filePath: 'commands.log').pipe gulp.dest('.')

gulp.task 'restart-prod', ()->
  ssh.exec([
    'export NODE_ENV=prod;cd /root/mngtconsole;forever stop server.coffee;forever start -c coffee server.coffee', 
    #'export NODE_ENV=prod;cd /root/mngtconsole;forever stop orderscaner.coffee;forever start -c coffee orderscaner.coffee'
  ], filePath: 'commands.log').pipe gulp.dest('.')

gulp.task 'cal', () ->
  gulp.src('app/dopbcp/**')
    .pipe(gulp.dest '_public/dopbcp')

gulp.task 'default', ['styles', 'html', 'jquery', 'bowerjs', 'bowercss', 'assets', 'fonts', 'cal']

gulp.task 'compile', () ->
  runSequence 'clean', 'default', 'scripts'

gulp.task 'dev', ['compile', 'watch']

gulp.task 'run-remote-web-qa', () ->
  runSequence 'clean-remote-web', 'upload-web-qa', 'restart-qa'

gulp.task 'run-remote-bin-qa', () ->
  runSequence 'upload-bin', 'restart-qa'

gulp.task 'run-remote-qa', () ->
  runSequence 'upload-bin', 'clean-remote-web', 'upload-web-qa', 'restart-qa'

gulp.task 'run-remote-web-prod', () ->
  runSequence 'clean-remote-web', 'upload-web-prod', 'restart-prod'

gulp.task 'run-remote-bin-prod', () ->
  runSequence 'upload-bin-prod', 'restart-prod'

gulp.task 'run-remote-prod', () ->
  runSequence 'upload-bin-prod', 'clean-remote-web', 'upload-web-prod', 'restart-prod'


