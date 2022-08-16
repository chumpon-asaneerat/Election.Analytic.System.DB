const GulpTask = require('./gulp-task').GulpTask;

const gulp = require('gulp');
const nodemon = require('gulp-nodemon');

class GulpNodeMonitor extends GulpTask {
    task() {
        console.log('start node monitor: press ctrl^c to stop.');
        nodemon(this.opts)
    };
};

exports.GulpNodeMonitor = module.exports.GulpNodeMonitor = GulpNodeMonitor;