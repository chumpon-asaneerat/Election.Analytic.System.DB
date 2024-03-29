const path = require('path');
const gulp = require('gulp');

const GulpJSDoc = require("./build/gulp/jsdoc").GulpJSDoc;
const GulpClean = require("./build/gulp/clean").GulpClean;
const GulpSass = require("./build/gulp/sass").GulpSass;
const GulpJSBundle = require("./build/gulp/jsbundle").GulpJSBundle;
const GulpLiveReloaded = require("./build/gulp/livereloaded").GulpLiveReloaded;
const GulpFileMerge = require("./build/gulp/filemerge").GulpFileMerge;
const GulpNodeMonitor = require("./build/gulp/nodemon").GulpNodeMonitor;
const GulpRiot3 = require("./build/gulp/riot3").GulpRiot3;

//const connect = require('gulp-connect');
//const watch = require('gulp-watch');

gulp.task('build-server-doc', (cb) => {
    let task = new GulpJSDoc();
    task.opts = {
        config: require('./jsdoc.json'),
        src: [
            path.join(__dirname, 'src/server/js/**/*.js')
        ],
        dest: path.join(__dirname, 'dist/doc/server')
    };
    return task.task(cb);
});

gulp.task('build-client-doc', (cb) => {
    let task = new GulpJSDoc();
    task.opts = {
        config: require('./jsdoc.json'),
        src: [
            path.join(__dirname, 'src/client/js/**/*.js')
        ],
        dest: path.join(__dirname, 'dist/doc/client')
    };
    return task.task(cb);
});

gulp.task('clear-doc', () => {
    let task = new GulpClean();
    task.opts = {
        src: path.join(__dirname, 'dist/doc/**/*')
    };
    return task.task();
});

gulp.task('clear-dist', () => {
    let task = new GulpClean();
    task.opts = {
        src: path.join(__dirname, 'dist/**/*')
    };
    return task.task();
});

gulp.task('compile-sass', () => {
    let task = new GulpSass();
    task.opts = {
        src: path.join(__dirname, 'src/client/sass/**/*.{sass,scss}'),
        dest: path.join(__dirname, 'dist/client/css/'),
        map: 'maps/'
    };
    return task.task();
});

gulp.task('riot3', () => {
    let task = new GulpRiot3();
    task.opts = {
        merge: true,
        src: path.join(__dirname, 'src/server/template/riot/**/*.tag'),
        dest: path.join(__dirname, 'dist/component/riot'),
        bundle: 'tags.js'
    };
    return task.task();
});

gulp.task('bundle-js', () => {
    let task = new GulpJSBundle();
    task.opts = {
        src: path.join(__dirname, 'src/client/js/**/*.js'),
        dest: path.join(__dirname, 'dist/client/js/'),
        bundle: path.join(__dirname, 'dist/client/js/bundle.min.js')
    };
    return task.task();
});

gulp.task('merge-sql-scripts', () => {
    let task = new GulpFileMerge();

    // Change date here!!!!!!!!!!!!!!!!!!!!!
    //let sDate = '2022-11-20'; // Change date here!!!!
    let sDate = '2023-05-01'; // Change date here!!!!
    // Change date here!!!!!!!!!!!!!!!!!!!!!

    let rootPath = path.join(__dirname, 'db/scripts/' + sDate);
    task.opts = {
        src: [
            /* Concat all *.sql file in subdirectories. */
            path.join(rootPath, '/**/*.sql'),
            /* Ignore all *.sql in 99.test.scripts path */
            '!' + path.join(rootPath, '/99.test.scripts/*.sql'),
            /* Ignore all *.sql in root path */
            '!' + path.join(rootPath, '/*.sql')
        ],
        header: `/*********** Script Update Date: ` + sDate + `  ***********/\n`,
        dest: path.join(__dirname, 'dist/server/db/scripts/'),
        target: 'update-' + sDate + '.sql'
    };
    return task.task();
});

gulp.task('livereload', () => {
    let task = new GulpLiveReloaded();
    task.opts = {
        src: ['dist/client/css/*.css', 'dist/client/js/*.js']
    };
    return task.task();
});

gulp.task('watch', () => {
    gulp.watch(path.join(__dirname, 'src/client/sass/**/*.{sass,scss}'), ['compile-sass']);
    gulp.watch(path.join(__dirname, 'src/client/js/**/*.js'), ['bundle-js']);
    //gulp.watch(src.html, ['html']);
    //gulp.watch(src.riotTags, ['riot-tags']);
});

gulp.task('monitor', (done) => {
    let task = new GulpNodeMonitor();
    task.opts = {
        script: 'server.js',
        ext: 'js html',
        env: { 'NODE_ENV': 'development' },
        done: done
    };
    task.task(done);
});

//gulp.task('default', ['sass', 'server', 'watch', 'livereload', 'js', 'riot-tags']);