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
sftp = require 'gulp-sftp'
ssh = require('gulp-ssh')(
  sshConfig: 
    host: 'qa.aghchina.com.cn'
    username: 'root'
    password: '8Sh7evxc'
)

path =
  scripts: 'app/scripts/**/*.coffee'
  styles:  'app/styles/**/*.css'
  bower: 'app/components'
  html: 'app/html/**/*.html'
  assets: 'app/assets/*'
  fonts: ['app/components/materialize/font/**', '!app/components/materialize/font/roboto{,/**}']
  public: '_public'


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
  gulp.src(['app/jquery/dist/jquery.min.js','app/jquery-ui/jquery-ui.min.js'])
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

gulp.task 'clean', (cb) ->
  rimraf path.public, cb

gulp.task 'upload', () ->
  gulp.src('_public/**')
    .pipe sftp(
      host: 'qa.aghchina.com.cn'
      user: 'root'
      pass: '8Sh7evxc'
      remotePath: '/tmp/_public') 

gulp.task 'cal', () ->
  gulp.src('app/dopbcp/**')
    .pipe(gulp.dest '_public/dopbcp')

gulp.task 'default', ['styles', 'html', 'jquery', 'bowerjs', 'bowercss', 'assets', 'fonts', 'cal']

gulp.task 'dev', ['clean', 'default', 'scripts', 'watch']

gulp.task 'build', ['clean', 'default', 'uglyscripts']
