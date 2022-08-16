const GulpTask = require('./gulp-task').GulpTask;

const gulp = require('gulp');
const connect = require('gulp-connect');

class GulpLiveReloaded extends GulpTask {
    task() {
        return gulp.src(this.opts.src)
            .pipe(connect.reload());
    };
};

exports.GulpLiveReloaded = module.exports.GulpLiveReloaded = GulpLiveReloaded;