//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const sqldb = require(path.join(nlib.paths.root, 'PPRPDemo.db'));
const dbutils = require(path.join(rootPath, 'nlib', 'db-utils')).DbUtils;

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

// static class.
const api = class { }

//#region Implement - SaveMRegion

api.SaveMRegion = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        return params
    }
    static async call(db, params) { 
        return db.SaveMRegion(params)
    }
    static parse(db, data, callback) {
        let result = dbutils.validate(db, data)
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.SaveMRegion
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result)
            });
        })
    }
}

//#endregion

router.all('/', api.SaveMRegion.entry)

const init_routes = (svr) => {
    svr.route('/api/master/MRegion/Save', router);
};

module.exports.init_routes = exports.init_routes = init_routes;