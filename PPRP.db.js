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

    async GetMSubdistricts(pObj) {
        let name = 'GetMSubdistricts';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportPersonImage(pObj) {
        let name = 'ImportPersonImage';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2562PollingUnitSummary(pObj) {
        let name = 'GetMPD2562PollingUnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2562PollingUnitSummaries(pObj) {
        let name = 'GetMPD2562PollingUnitSummaries';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2566PollingUnitSummary(pObj) {
        let name = 'GetMPD2566PollingUnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2566PollingUnitSummaries(pObj) {
        let name = 'GetMPD2566PollingUnitSummaries';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SavePollingStation(pObj) {
        let name = 'SavePollingStation';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetPollingStations(pObj) {
        let name = 'GetPollingStations';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMPD2562VoteSummary(pObj) {
        let name = 'ImportMPD2562VoteSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPD2562VoteSummary(pObj) {
        let name = 'SaveMPD2562VoteSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2562VoteSummaries(pObj) {
        let name = 'GetMPD2562VoteSummaries';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2562VoteSummaryByFullName(pObj) {
        let name = 'GetMPD2562VoteSummaryByFullName';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetPersonImages(pObj) {
        let name = 'GetPersonImages';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPD2562x350UnitSummary(pObj) {
        let name = 'SaveMPD2562x350UnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMPD2562x350UnitSummary(pObj) {
        let name = 'ImportMPD2562x350UnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMProvinceADM1(pObj) {
        let name = 'ImportMProvinceADM1';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMDistrictADM2(pObj) {
        let name = 'ImportMDistrictADM2';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMSubdistrictADM3(pObj) {
        let name = 'ImportMSubdistrictADM3';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2562TopVoteSummaries(pObj) {
        let name = 'GetMPD2562TopVoteSummaries';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2562TotalVotes(pObj) {
        let name = 'GetMPD2562TotalVotes';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2562x350UnitSummaries(pObj) {
        let name = 'GetMPD2562x350UnitSummaries';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2562x350UnitSummary(pObj) {
        let name = 'GetMPD2562x350UnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPD2562x350UnitFullSummaries(pObj) {
        let name = 'GetMPD2562x350UnitFullSummaries';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPDC2566s(pObj) {
        let name = 'GetMPDC2566s';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMPDC2566Summaries(pObj) {
        let name = 'GetMPDC2566Summaries';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetRegionMenuItems(pObj) {
        let name = 'GetRegionMenuItems';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetProvinceMenuItems(pObj) {
        let name = 'GetProvinceMenuItems';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetPollingUnitMenuItems(pObj) {
        let name = 'GetPollingUnitMenuItems';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMPDC2566(pObj) {
        let name = 'ImportMPDC2566';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPDC2566(pObj) {
        let name = 'SaveMPDC2566';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMPD2562PollingUnitSummary(pObj) {
        let name = 'ImportMPD2562PollingUnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMPD2562PollingUnitAreaRemark(pObj) {
        let name = 'ImportMPD2562PollingUnitAreaRemark';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async ImportMPD2566PollingUnitSummary(pObj) {
        let name = 'ImportMPD2566PollingUnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPD2562PollingUnitSummary(pObj) {
        let name = 'SaveMPD2562PollingUnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async SaveMPD2566PollingUnitSummary(pObj) {
        let name = 'SaveMPD2566PollingUnitSummary';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async DeletePersonImage(pObj) {
        let name = 'DeletePersonImage';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async DeleteMParty(pObj) {
        let name = 'DeleteMParty';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

    async GetMParties(pObj) {
        let name = 'GetMParties';
        let proc = schema[name];
        return await this.execute(name, pObj, proc.parameter.inputs, proc.parameter.outputs);
    }

}

module.exports = exports = PPRP;
