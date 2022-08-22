// required to manual set require path for nlib-mssql.
const SqlServer = require('./nlib/nlib-mssql');
const schema = require('./schema/PPRPDemo.schema.json');

const PPRPDemo = class extends SqlServer {
    constructor() {
        super();
        // should match with nlib.config.json
        this.database = 'default'
    }
    async connect() {
        return await super.connect(this.database);
    }
    async disconnect() {
        await super.disconnect();
    }

    async GetMRegions(pObj) {
        let name = 'GetMRegions';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMTitles(pObj) {
        let name = 'GetMTitles';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMRegion(pObj) {
        let name = 'SaveMRegion';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMTitle(pObj) {
        let name = 'SaveMTitle';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetUserRoles(pObj) {
        let name = 'GetUserRoles';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetUsers(pObj) {
        let name = 'GetUsers';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetUser(pObj) {
        let name = 'GetUser';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveUserRole(pObj) {
        let name = 'SaveUserRole';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveUser(pObj) {
        let name = 'SaveUser';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

}

module.exports = exports = PPRPDemo;
