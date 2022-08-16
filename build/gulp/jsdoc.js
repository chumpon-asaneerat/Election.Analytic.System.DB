const GulpTask = require('./gulp-task').GulpTask;

const gulp = require('gulp');
const jsdoc = require('gulp-jsdoc3');

class GulpJSDoc extends GulpTask {
    task(cb) {
        let config = this.opts.config;
        config.opts = config.opts || { destination: '' };
        config.opts.destination = this.opts.dest;
        return gulp.src(this.opts.src, {read: false})
            .pipe(jsdoc(config, cb));
    };
};

exports.GulpJSDoc = module.exports.GulpJSDoc = GulpJSDoc;