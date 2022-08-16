const GulpTask = require('./gulp-task').GulpTask;

const gulp = require('gulp');
const concat = require('gulp-concat');
const debug = require('gulp-debug');
const sort = require('gulp-sort');
const order = require('gulp-order');
const insert = require('gulp-insert');

// How to used gulp-order.
/*
gulp.task('js-bundle', () => {
    let src = [
        'nlib-html-core.js',
        'nlib-html-tag-div.js',
        'nlib-html-tag-img.js',
        'nlib-html-attribute-src.js',
        'nlib-html-attribute-width.js',
        'nlib-html-attribute-height.js'        
    ];
    let dest = 'nlib-html.js';
    return gulp.src([
            '*.js', 
            //'!nlib-html-core.js',
            //'!nlib-html-tag-div.js',
            //'!nlib-html-tag-img.js',
            //'!nlib-html-attribute-src.js',
            '!index.js', 
            '!nlib-dom-json*.js', 
            '!gulpfile.js'
        ])
        .pipe(order(src))
        .pipe(debug())
        .pipe(concat(dest))
        .pipe(gulp.dest('js'));
});
*/

class GulpFileMerge extends GulpTask {
    task() {
        return gulp.src(this.opts.src)
            //.pipe(sort())
            .pipe((!this.opts.order) ? sort() : order(this.opts.order))
            .pipe(debug())
            .pipe(insert.prepend(this.opts.header))
            .pipe(insert.append(`\n`))
            .pipe(concat(this.opts.target))
            .pipe(gulp.dest(this.opts.dest));
    };
};

exports.GulpFileMerge = module.exports.GulpFileMerge = GulpFileMerge;