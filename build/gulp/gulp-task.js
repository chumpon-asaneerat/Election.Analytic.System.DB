class GulpTask {
    constructor() {
        this._opts = {};
    };
    get opts() { return this._opts; }
    set opts(value) { this._opts = value; }
    task() {};
};

exports.GulpTask = module.exports.GulpTask = GulpTask;