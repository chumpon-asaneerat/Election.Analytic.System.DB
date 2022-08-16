const GulpTask = require('./gulp-task').GulpTask;

const gulp = require('gulp');
const rm = require('gulp-rm');

class GulpClean extends GulpTask {
    task() {
        return gulp.src(this.opts.src, {read: false})
            .pipe(rm({ async: false }));
    };
};

exports.GulpClean = module.exports.GulpClean = GulpClean;