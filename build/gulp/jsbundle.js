const GulpTask = require('./gulp-task').GulpTask;

const gulp = require('gulp');
const concat = require('gulp-concat');
const uglify = require('gulp-uglify-es').default;
const connect = require('gulp-connect');

class GulpJSBundle extends GulpTask {
    task() {
        return gulp.src(this.opts.src)
            .pipe(concat(this.opts.bundle))
            .pipe(uglify())
            .pipe(gulp.dest(this.opts.dest))
            .pipe(connect.reload());
    };
};

exports.GulpJSBundle = module.exports.GulpJSBundle = GulpJSBundle;