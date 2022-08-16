const GulpTask = require('./gulp-task').GulpTask;

const gulp = require('gulp');
const sass = require('gulp-sass');
const autoprefixer = require('gulp-autoprefixer');
const sourcemaps = require('gulp-sourcemaps');
const connect = require('gulp-connect');

class GulpSass extends GulpTask {
    task() {
        return gulp.src(this.opts.src)
            .pipe(sourcemaps.init())
            .pipe(autoprefixer({
                browsers: ['last 2 versions'],
                cascade: false
            }))
            .pipe(sass({
                outputStyle: 'compressed'
            }).on('error', sass.logError))
            .pipe(sourcemaps.write(this.opts.map))
            .pipe(gulp.dest(this.opts.dest))
            .pipe(connect.reload())
    };
};

exports.GulpSass = module.exports.GulpSass = GulpSass;