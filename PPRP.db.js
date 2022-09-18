// required to manual set require path for nlib-mssql.
const SqlServer = require('./nlib/nlib-mssql');
const schema = require('./schema/PPRP.schema.json');

const PPRP = class extends SqlServer {
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

    async SaveMRegion(pObj) {
        let name = 'SaveMRegion';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMRegions(pObj) {
        let name = 'GetMRegions';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMTitle(pObj) {
        let name = 'SaveMTitle';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMTitles(pObj) {
        let name = 'GetMTitles';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMContent(pObj) {
        let name = 'SaveMContent';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMContents(pObj) {
        let name = 'GetMContents';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveUserRole(pObj) {
        let name = 'SaveUserRole';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetUserRoles(pObj) {
        let name = 'GetUserRoles';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveUser(pObj) {
        let name = 'SaveUser';
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

    async SaveMDistrict(pObj) {
        let name = 'SaveMDistrict';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMSubdistrict(pObj) {
        let name = 'SaveMSubdistrict';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async FindRegionId(pObj) {
        let name = 'FindRegionId';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportPollingStation(pObj) {
        let name = 'ImportPollingStation';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPD2562VoteSummary(pObj) {
        let name = 'SaveMPD2562VoteSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMProvince(pObj) {
        let name = 'SaveMProvince';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Parse_FullName_Lv1(pObj) {
        let name = 'Parse_FullName_Lv1';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Parse_FullName_Lv2(pObj) {
        let name = 'Parse_FullName_Lv2';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Parse_FullName_Lv3(pObj) {
        let name = 'Parse_FullName_Lv3';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Parse_FullName_Lv4(pObj) {
        let name = 'Parse_FullName_Lv4';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async Parse_FullName_Lv5(pObj) {
        let name = 'Parse_FullName_Lv5';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPDC2566(pObj) {
        let name = 'SaveMPDC2566';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPD2562x350UnitSummary(pObj) {
        let name = 'SaveMPD2562x350UnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMProvinceADM1(pObj) {
        let name = 'SaveMProvinceADM1';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMProvinces(pObj) {
        let name = 'GetMProvinces';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMDistricts(pObj) {
        let name = 'GetMDistricts';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMDistrictADM2(pObj) {
        let name = 'SaveMDistrictADM2';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMSubdistrictADM3(pObj) {
        let name = 'SaveMSubdistrictADM3';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMSubdistricts(pObj) {
        let name = 'GetMSubdistricts';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPD2562PollingUnitSummary(pObj) {
        let name = 'SaveMPD2562PollingUnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMPD2562PollingUnitAreaRemark(pObj) {
        let name = 'ImportMPD2562PollingUnitAreaRemark';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPD2566PollingUnitSummary(pObj) {
        let name = 'SaveMPD2566PollingUnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

}

module.exports = exports = PPRP;
