/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[DropAllViews]    Script Date: 11/20/2022 12:21:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DropAllViews.
-- Description:	Drop all Views
-- [== History ==]
-- <2019-08-19> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DropAllViews
-- =============================================
CREATE PROCEDURE [dbo].[DropAllViews]
AS
BEGIN
CREATE TABLE #VIEW_NAMES
(
    ViewName nvarchar(100)
);

DECLARE @sql nvarchar(MAX);
DECLARE @name nvarchar(100);
DECLARE @dropViewCursor CURSOR;
	/*========= DROP VIEWS =========*/
    INSERT INTO #VIEW_NAMES
        (ViewName)
    SELECT name
    FROM sys.views;

    SET @dropViewCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT ViewName
    FROM #VIEW_NAMES;

    OPEN @dropViewCursor;
    FETCH NEXT FROM @dropViewCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop table.
        SET @sql = 'DROP VIEW ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropViewCursor INTO @name;
    END
    CLOSE @dropViewCursor;
    DEALLOCATE @dropViewCursor;

    DROP TABLE #VIEW_NAMES;
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[DropAllFNs]    Script Date: 11/20/2022 12:21:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DropAllFNs.
-- Description:	Drop all Functions
-- [== History ==]
-- <2019-08-19> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DropAllFNs
-- =============================================
CREATE PROCEDURE [dbo].[DropAllFNs]
AS
BEGIN
CREATE TABLE #FN_NAMES
(
    FuncName nvarchar(100)
);

DECLARE @sql nvarchar(MAX);
DECLARE @name nvarchar(100);
DECLARE @dropFuncCursor CURSOR;
	/*========= DROP FUNCTIONS =========*/
    INSERT INTO #FN_NAMES
        (FuncName)
    SELECT O.name
      FROM sys.sql_modules M
     INNER JOIN sys.objects O 
	    ON M.object_id = O.object_id
     WHERE O.type IN ('IF','TF','FN')

    SET @dropFuncCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT FuncName
    FROM #FN_NAMES;

    OPEN @dropFuncCursor;
    FETCH NEXT FROM @dropFuncCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop table.
        SET @sql = 'DROP FUNCTION ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropFuncCursor INTO @name;
    END
    CLOSE @dropFuncCursor;
    DEALLOCATE @dropFuncCursor;

    DROP TABLE #FN_NAMES;
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[DropAllSPs]    Script Date: 11/20/2022 12:21:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Drop All SPs.
-- Description:	Drop all Stored Procedures
-- [== History ==]
-- <2019-08-19> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DropAllSPs
-- =============================================
CREATE PROCEDURE DropAllSPs
AS
BEGIN
CREATE TABLE #SP_NAMES
(
    ProcName nvarchar(100)
);

DECLARE @sql nvarchar(MAX);
DECLARE @name nvarchar(100);
DECLARE @dropSPCursor CURSOR;
	/*========= DROP PROCEDURES =========*/
    INSERT INTO #SP_NAMES
        (ProcName)
    SELECT name
      FROM sys.objects 
	 WHERE type = 'P' 
	   AND NAME NOT IN (
             'DropAll'
           , 'DropAllSPs'
           , 'DropAllFNs'
           , 'DropAllViews'
           , 'DropTable'
           , 'DropAllTables') -- ignore
	 ORDER BY modify_date DESC

    SET @dropSPCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT ProcName
    FROM #SP_NAMES;

    OPEN @dropSPCursor;
    FETCH NEXT FROM @dropSPCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop procedures.
        SET @sql = 'DROP PROCEDURE ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropSPCursor INTO @name;
    END
    CLOSE @dropSPCursor;
    DEALLOCATE @dropSPCursor;

    DROP TABLE #SP_NAMES;
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[DropTable]    Script Date: 11/20/2022 12:21:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DropAll.
-- Description:	Drop Table and it's related indexes, constrains, keys
-- [== History ==]
-- <2019-08-19> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DropTable
-- =============================================
CREATE PROCEDURE [dbo].[DropTable]
(
  @tableName nvarchar(max)
)
AS
BEGIN
DECLARE @sqlDropIndexes nvarchar(MAX)
DECLARE @sqlDropConstrains nvarchar(MAX)
DECLARE @sqlDropTable nvarchar(MAX)
	-- DROP CONSTRAINS (PK, FK)
	SET @sqlDropConstrains = ''
	SELECT @sqlDropConstrains += N'ALTER TABLE ' + QUOTENAME(object_schema_name(object_id)) + '.' + QUOTENAME(OBJECT_NAME(PARENT_OBJECT_ID)) + ' DROP CONSTRAINT ' + QUOTENAME(OBJECT_NAME(OBJECT_ID)) + ';' + CHAR(13) + CHAR(10)
	  FROM SYS.OBJECTS
	 WHERE TYPE_DESC LIKE '%CONSTRAINT' AND OBJECT_NAME(PARENT_OBJECT_ID) = @tableName;

	--PRINT 'DROP CONSTRAINS (PK, FK)'
	--PRINT @sqlDropConstrains
	EXECUTE SP_EXECUTESQL @sqlDropConstrains

	-- DROP INDEXES
	SET @sqlDropIndexes = ''
	SELECT @sqlDropIndexes = (
		SELECT 'DROP INDEX ' + QUOTENAME(ix.name) + ' ON ' + QUOTENAME(object_schema_name(object_id)) + '.' + QUOTENAME(OBJECT_NAME(object_id)) + ';' + CHAR(10)
		  FROM sys.indexes ix
		 WHERE ix.Name IS NOT NULL 
		   AND object_schema_name(object_id) NOT IN ('sys')
		   --AND ix.Name like '%IX_%'
		   AND OBJECT_NAME(object_id) = COALESCE(@tableName, OBJECT_NAME(object_id))
		   FOR XML PATH(''))

	--PRINT 'DROP INDEXES'
	--PRINT @sqlDropIndexes
	EXEC SP_EXECUTESQL @sqlDropIndexes

	-- DROP TABLE (Identity Property should be remove when table is drop.
	-- To check all identity columns use below query
	--SELECT object_name(object_id) as TableName, name as ColumnName FROM sys.columns WHERE is_identity = 1

	SET @sqlDropTable = 'DROP TABLE ' + @tableName
	--PRINT 'DROP TABLE'
	EXEC SP_EXECUTESQL @sqlDropTable
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[DropAllTables]    Script Date: 11/20/2022 12:21:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DropAll.
-- Description:	Drop all Tables and it's related indexes, constrains, keys
-- [== History ==]
-- <2019-08-19> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DropAllTables
-- =============================================
CREATE PROCEDURE [dbo].[DropAllTables]
AS
BEGIN
CREATE TABLE #TABLE_NAMES
(
    TableName nvarchar(100)
);

DECLARE @sql nvarchar(MAX);
DECLARE @name nvarchar(100);
DECLARE @dropTableCursor CURSOR;
	/*========= DROP TABLES =========*/
    /*
    INSERT INTO #TABLE_NAMES
        (TableName)
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = N'BASE TABLE';

    SET @dropTableCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT TableName
    FROM #TABLE_NAMES;

    OPEN @dropTableCursor;
    FETCH NEXT FROM @dropTableCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop table (by sp).
		EXEC DropTable @name;

		-- drop table (by sql sql script).
        --SET @sql = 'DROP TABLE ' + @name;
        --EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropTableCursor INTO @name;
    END
    CLOSE @dropTableCursor;
    DEALLOCATE @dropTableCursor;

    DROP TABLE #TABLE_NAMES;
    */
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** UserRole ******/ 
CREATE TABLE UserRole (
	RoleId int NOT NULL,
	RoleName nvarchar(100) NOT NULL,
	CONSTRAINT PK_UserRole PRIMARY KEY (RoleId ASC)
)
GO

CREATE UNIQUE INDEX IX_UserRole_RoleName ON UserRole(RoleName ASC)
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** UserInfo ******/ 
CREATE TABLE UserInfo(
	UserId int IDENTITY(1,1) NOT NULL,
	RoleId int NOT NULL,
	FullName nvarchar(200) NOT NULL,
	UserName nvarchar(100) NOT NULL,
	[Password] nvarchar(100) NOT NULL,
	Active int NOT NULL DEFAULT 1,
	LastUpdated datetime NOT NULL DEFAULT getdate(),
	CONSTRAINT PK_UserInfo PRIMARY KEY (UserId ASC)
)
GO

CREATE INDEX IX_UserInfo ON UserInfo(UserId ASC)
GO

CREATE UNIQUE INDEX IX_UserInfo_FullName ON UserInfo(FullName ASC)
GO

CREATE UNIQUE INDEX IX_UserInfo_UserName ON UserInfo(UserName ASC)
GO

ALTER TABLE UserInfo WITH CHECK
	ADD CONSTRAINT FK_UserInfo_UserRole FOREIGN KEY (RoleId) REFERENCES UserRole(RoleId)
GO

ALTER TABLE UserInfo CHECK CONSTRAINT FK_UserInfo_UserRole
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MTitle ******/ 
CREATE TABLE MTitle(
	TitleId int IDENTITY(1,1) NOT NULL,
	[Description] nvarchar(200) NOT NULL,
	GenderId int NULL,
	CONSTRAINT PK_MTitle PRIMARY KEY (TitleId ASC)
)
GO

CREATE UNIQUE INDEX IX_MTitle_Description ON MTitle([Description] ASC)
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MGender ******/ 
CREATE TABLE MGender(
	GenderId int NOT NULL,
	[Description] nvarchar(100) NULL,
	CONSTRAINT PK_MGender PRIMARY KEY (GenderId ASC)
)

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MOccupation ******/ 
CREATE TABLE MOccupation(
	OccupationId int NOT NULL,
	[Description] nvarchar(200) NOT NULL,
	SortOrder int NOT NULL,
	Active int NOT NULL,
	CONSTRAINT PK_MOccupation PRIMARY KEY (OccupationId ASC)
)
GO

CREATE UNIQUE INDEX IX_MOccupation_Description ON MOccupation([Description] ASC)
GO

ALTER TABLE MOccupation ADD  CONSTRAINT DF_MOccupation_SortOrder  DEFAULT 0 FOR SortOrder
GO

ALTER TABLE MOccupation ADD  CONSTRAINT DF_MOccupation_Active  DEFAULT 1 FOR Active
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MEducation ******/ 
CREATE TABLE MEducation(
	EducationId int NOT NULL,
	[Description] nvarchar(200) NOT NULL,
	SortOrder int NOT NULL,
	Active int NOT NULL,
	CONSTRAINT PK_MEducation PRIMARY KEY (EducationId ASC)
)
GO

CREATE UNIQUE INDEX IX_MEducation_Description ON MEducation([Description] ASC)
GO

ALTER TABLE MEducation ADD  CONSTRAINT DF_MEducation_SortOrder  DEFAULT 0 FOR SortOrder
GO

ALTER TABLE MEducation ADD  CONSTRAINT DF_MEducation_Active  DEFAULT 1 FOR Active
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MAge ******/ 
CREATE TABLE MAge(
	AgeId int NOT NULL,
    AgeMin int NOT NULL,
    AgeMax int NOT NULL,
	[Description] nvarchar(200) NOT NULL,
	SortOrder int NOT NULL,
	Active int NOT NULL,
	CONSTRAINT PK_MAge PRIMARY KEY (AgeId ASC)
)
GO

CREATE UNIQUE INDEX IX_MAge_Description ON MAge([Description] ASC)
GO

ALTER TABLE MAge ADD  CONSTRAINT DF_MAge_SortOrder  DEFAULT 0 FOR SortOrder
GO

ALTER TABLE MAge ADD  CONSTRAINT DF_MAge_Active  DEFAULT 1 FOR Active
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** PollingUnit ******/ 
CREATE TABLE PollingUnit (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	PollingUnitCount int NOT NULL,
	AreaRemark nvarchar(MAX) NULL,
    CONSTRAINT PK_PollingUnit PRIMARY KEY (ThaiYear ASC, ADM1Code ASC, PollingUnitNo ASC )
)
GO

CREATE INDEX IX_PollingUnit_ThaiYear ON PollingUnit(ThaiYear ASC)
GO

CREATE INDEX IX_PollingUnit_ADM1Code ON PollingUnit(ADM1Code ASC)
GO

CREATE INDEX IX_PollingUnit_PollingUnitNo ON PollingUnit(PollingUnitNo ASC)
GO

ALTER TABLE PollingUnit ADD  CONSTRAINT DF_PollingUnit_PollingUnitCount  DEFAULT 0 FOR PollingUnitCount
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MRegion ******/ 
CREATE TABLE MRegion(
	RegionId nvarchar(20) NOT NULL,
	RegionName nvarchar(200) NOT NULL,
	GeoGroup nvarchar(200) NULL,
	GeoSubGroup nvarchar(200) NULL,
	CONSTRAINT PK_MRegion PRIMARY KEY (RegionId ASC)
)
GO

CREATE INDEX IX_MRegion ON MRegion(RegionId ASC)
GO

CREATE UNIQUE INDEX IX_MRegion_RegionName ON MRegion(RegionName ASC)
GO

CREATE INDEX IX_MRegion_GeoGroup ON MRegion(GeoGroup ASC)
GO

CREATE INDEX IX_MRegion_GeoSubGroup ON MRegion(GeoSubGroup ASC)
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MProvince ******/ 
CREATE TABLE MProvince(
	ADM1Code nvarchar(20) NOT NULL,
	ProvinceNameTH nvarchar(200) NOT NULL,
	ProvinceNameEN nvarchar(200) NULL,
	RegionId nvarchar(20)  NULL,
	ProvinceId nvarchar(20)  NULL,
	AreaM2 decimal(16, 3) NULL,
	CONSTRAINT PK_MProvince PRIMARY KEY (ADM1Code ASC)
)
GO

CREATE INDEX IX_MProvince ON MProvince(ADM1Code ASC)
GO

CREATE UNIQUE INDEX IX_MProvince_ProvinceNameTH ON MProvince(ProvinceNameTH ASC)
GO

CREATE UNIQUE INDEX IX_MProvince_ProvinceNameEN ON MProvince(ProvinceNameEN ASC)
GO

CREATE INDEX IX_MProvince_RegionId ON MProvince(RegionId ASC)
GO

CREATE INDEX IX_MProvince_ProvinceId ON MProvince(ProvinceId ASC)
GO

ALTER TABLE MProvince ADD  CONSTRAINT DF_MProvince_AreaM2  DEFAULT 0.0 FOR AreaM2
GO



/*********** Script Update Date: 2022-11-20  ***********/
/****** MDistrict ******/ 
CREATE TABLE MDistrict(
	ADM2Code nvarchar(20) NOT NULL,
	DistrictNameTH nvarchar(200) NOT NULL,
	DistrictNameEN nvarchar(200) NULL,
	ADM1Code nvarchar(20) NULL,
	RegionId nvarchar(20)  NULL,
	ProvinceId nvarchar(20)  NULL,
	DistrictId nvarchar(20)  NULL,
	AreaM2 decimal(16, 3) NULL,
	CONSTRAINT PK_MDistrict PRIMARY KEY (ADM2Code ASC)
)
GO

CREATE INDEX IX_MDistrict ON MDistrict(ADM2Code ASC)
GO

CREATE INDEX IX_MDistrict_ADM1Code ON MDistrict(ADM1Code ASC)
GO

CREATE INDEX IX_MDistrict_DistrictNameTH ON MDistrict(DistrictNameTH ASC)
GO

CREATE INDEX IX_MDistrict_DistrictNameEN ON MDistrict(DistrictNameEN ASC)
GO

CREATE INDEX IX_MDistrict_RegionId ON MDistrict(RegionId ASC)
GO

CREATE INDEX IX_MDistrict_ProvinceId ON MDistrict(ProvinceId ASC)
GO

CREATE INDEX IX_MDistrict_DistrictId ON MDistrict(DistrictId ASC)
GO

ALTER TABLE MDistrict ADD  CONSTRAINT DF_MDistrict_AreaM2  DEFAULT 0.0 FOR AreaM2
GO



/*********** Script Update Date: 2022-11-20  ***********/
/****** MSubdistrict ******/ 
CREATE TABLE MSubdistrict(
	ADM3Code nvarchar(20) NOT NULL,
	SubdistrictNameTH nvarchar(200) NOT NULL,
	SubdistrictNameEN nvarchar(200) NULL,
	ADM1Code nvarchar(20) NULL,
	ADM2Code nvarchar(20) NULL,
	RegionId nvarchar(20)  NULL,
	ProvinceId nvarchar(20)  NULL,
	DistrictId nvarchar(20)  NULL,
	SubdistrictId nvarchar(20)  NULL,
	AreaM2 decimal(16, 3) NULL,
	CONSTRAINT PK_MSubdistrict PRIMARY KEY (ADM3Code ASC)
)
GO

CREATE INDEX IX_MSubdistrict ON MSubdistrict(ADM3Code ASC)
GO

CREATE INDEX IX_MSubdistrict_ADM1Code ON MSubdistrict(ADM1Code ASC)
GO

CREATE INDEX IX_MSubdistrict_ADM2Code ON MSubdistrict(ADM2Code ASC)
GO

CREATE INDEX IX_MSubdistrict_SubdistrictNameTH ON MSubdistrict(SubdistrictNameTH ASC)
GO

CREATE INDEX IX_MSubdistrict_SubdistrictNameEN ON MSubdistrict(SubdistrictNameEN ASC)
GO

CREATE INDEX IX_MSubdistrict_RegionId ON MSubdistrict(RegionId ASC)
GO

CREATE INDEX IX_MSubdistrict_ProvinceId ON MSubdistrict(ProvinceId ASC)
GO

CREATE INDEX IX_MSubdistrict_DistrictId ON MSubdistrict(DistrictId ASC)
GO

CREATE INDEX IX_MSubdistrict_SubdistrictId ON MSubdistrict(SubdistrictId ASC)
GO

ALTER TABLE MSubdistrict ADD  CONSTRAINT DF_MSubdistrict_AreaM2  DEFAULT 0.0 FOR AreaM2
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MPerson ******/ 
CREATE TABLE MPerson(
	PersonId int IDENTITY(1,1) NOT NULL,
	Prefix nvarchar(100) NULL,
	FirstName nvarchar(200) NOT NULL,
	LastName nvarchar(200) NOT NULL,
	DOB datetime NULL,
	GenderId int NULL,
	EducationId int NULL,
	OccupationId int NULL,
	[Remark] nvarchar(max) NULL,
	Data varbinary(max) NULL,
	CONSTRAINT PK_MPerson PRIMARY KEY (PersonId ASC)
)
GO

CREATE NONCLUSTERED INDEX IX_MPerson_FirstName ON MPerson(FirstName ASC)
GO

CREATE NONCLUSTERED INDEX IX_MPerson_LastName ON MPerson(LastName ASC)
GO

ALTER TABLE MPerson
  ADD CONSTRAINT DF_MPerson_GenderId DEFAULT 0 FOR GenderId
GO

ALTER TABLE MPerson
  ADD CONSTRAINT DF_MPerson_EducationId DEFAULT 0 FOR EducationId
GO

ALTER TABLE MPerson
  ADD CONSTRAINT DF_MPerson_OccupationId DEFAULT 0 FOR OccupationId
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MParty ******/ 
CREATE TABLE MParty(
	PartyId int IDENTITY(1,1) NOT NULL,
	PartyName nvarchar(200) NOT NULL,
	Data varbinary(max) NULL,
	CONSTRAINT PK_MParty PRIMARY KEY (PartyId ASC)
)
GO

CREATE UNIQUE INDEX IX_MParty_PartyName ON MParty(PartyName ASC)
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MPDVoteSummary ******/ 
CREATE TABLE MPDVoteSummary (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	CandidateNo int NOT NULL,
	RevoteNo int NOT NULL,
	PartyId int NOT NULL,
	PersonId int NOT NULL,
	VoteCount int NOT NULL,
    CONSTRAINT PK_MPDVoteSummary PRIMARY KEY 
    (
        ThaiYear ASC
      , ADM1Code ASC
      , PollingUnitNo ASC
      , CandidateNo ASC
      , RevoteNo ASC
      , PartyId ASC
      , PersonId ASC
    )
)
GO

CREATE INDEX IX_MPDVoteSummary_ThaiYear ON MPDVoteSummary(ThaiYear ASC)
GO

CREATE INDEX IX_MPDVoteSummary_ADM1Code ON MPDVoteSummary(ADM1Code ASC)
GO

CREATE INDEX IX_MPDVoteSummary_PollingUnitNo ON MPDVoteSummary(PollingUnitNo ASC)
GO

CREATE INDEX IX_MPDVoteSummary_CandidateNo ON MPDVoteSummary(CandidateNo ASC)
GO

CREATE INDEX IX_MPDVoteSummary_RevoteNo ON MPDVoteSummary(RevoteNo ASC)
GO

CREATE INDEX IX_MPDVoteSummary_PartyId ON MPDVoteSummary(PartyId ASC)
GO

CREATE INDEX IX_MPDVoteSummary_PersonId ON MPDVoteSummary(PersonId ASC)
GO

ALTER TABLE MPDVoteSummary ADD  CONSTRAINT DF_MPDVoteSummary_CandidateNo  DEFAULT 0 FOR CandidateNo
GO

ALTER TABLE MPDVoteSummary ADD  CONSTRAINT DF_MPDVoteSummary_RevoteNo  DEFAULT 0 FOR RevoteNo
GO

ALTER TABLE MPDVoteSummary ADD  CONSTRAINT DF_MPDVoteSummary_VoteCount  DEFAULT 0 FOR VoteCount
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MPDStatVoter ******/ 
CREATE TABLE MPDStatVoter (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	RightCount int NOT NULL,
	ExerciseCount int NOT NULL,
	InvalidCount int NOT NULL,
	NoVoteCount int NOT NULL,
    CONSTRAINT PK_MPDStatVoter PRIMARY KEY 
    (
        ThaiYear ASC
      , ADM1Code ASC
      , PollingUnitNo ASC
    )
)
GO

CREATE INDEX IX_MPDStatVoter_ThaiYear ON MPDStatVoter(ThaiYear ASC)
GO

CREATE INDEX IX_MPDStatVoter_ADM1Code ON MPDStatVoter(ADM1Code ASC)
GO

CREATE INDEX IX_MPDStatVoter_PollingUnitNo ON MPDStatVoter(PollingUnitNo ASC)
GO

ALTER TABLE MPDStatVoter ADD  CONSTRAINT DF_MPDStatVoter_RightCount  DEFAULT 0 FOR RightCount
GO

ALTER TABLE MPDStatVoter ADD  CONSTRAINT DF_MPDStatVoter_ExerciseCount  DEFAULT 0 FOR ExerciseCount
GO

ALTER TABLE MPDStatVoter ADD  CONSTRAINT DF_MPDStatVoter_InvalidCount  DEFAULT 0 FOR InvalidCount
GO

ALTER TABLE MPDStatVoter ADD  CONSTRAINT DF_MPDStatVoter_NoVoteCount  DEFAULT 0 FOR NoVoteCount
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** MPDVoteStatistic ******/ 
CREATE TABLE MPDC (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	CandidateNo int NOT NULL,
	PersonId int NOT NULL,
	PrevPartyId int NULL,
	EducationId int NULL,
    [Remark] nvarchar(max) NULL,
    SubGroup nvarchar(max) NULL,
    CONSTRAINT PK_MPDC PRIMARY KEY 
    (
        ThaiYear ASC
      , ADM1Code ASC
      , PollingUnitNo ASC
      , CandidateNo ASC
    )
)
GO

CREATE INDEX IX_MPDC_ThaiYear ON MPDC(ThaiYear ASC)
GO

CREATE INDEX IX_MPDC_ADM1Code ON MPDC(ADM1Code ASC)
GO

CREATE INDEX IX_MPDC_PollingUnitNo ON MPDC(PollingUnitNo ASC)
GO

CREATE INDEX IX_MPDC_CandidateNo ON MPDC(CandidateNo ASC)
GO

ALTER TABLE MPDC ADD  CONSTRAINT DF_MPDC_CandidateNo  DEFAULT 0 FOR CandidateNo
GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[MTitleView]    Script Date: 11/26/2022 1:56:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MTitleView]
AS
	SELECT TitleId
         , [Description]
	     , GenderId
		 , LEN([Description]) AS DLen
	  FROM MTitle

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[UserInfoView]    Script Date: 11/27/2022 10:10:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW UserInfoView
AS
	SELECT A.UserId
	     , A.FullName
	     , A.UserName
	     , A.[Password]
		 , A.Active
         , A.LastUpdated
		 , A.RoleId
		 , B.RoleName
	  FROM UserInfo A
	     , UserRole B
	 WHERE A.RoleId = B.RoleId

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[MProvinceView]    Script Date: 11/26/2022 2:48:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MProvinceView]
AS
	SELECT A.ADM1Code
	     , A.ProvinceNameTH
	     , A.ProvinceNameEN
	     , A.AreaM2 AS ProvinceAreaM2
		 , A.ProvinceId
	     , B.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
	  FROM MProvince A LEFT OUTER JOIN MRegion B ON B.RegionId = A.RegionId

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[MDistrictView]    Script Date: 11/29/2022 7:38:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MDistrictView]
AS
	SELECT A.ADM2Code
		 , A.AreaM2 AS DistrictAreaM2
         , A.DistrictId
		 , A.DistrictNameTH
		 , A.DistrictNameEN
		 , A.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ADM1Code
		 , A.ProvinceId
		 , C.ProvinceNameTH
		 , C.ProvinceNameEN
		 , C.AreaM2 AS ProvinceAreaM2
	  FROM MDistrict A
		 , MProvince C LEFT OUTER JOIN MRegion B ON B.RegionId = C.RegionId
	 WHERE A.ADM1Code = C.ADM1Code

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[MSubdistrictView]    Script Date: 11/27/2022 10:18:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MSubdistrictView]
AS
	SELECT A.ADM3Code
		 , A.SubdistrictNameTH
		 , A.SubdistrictNameEN
		 , A.AreaM2 AS SubdistrictAreaM2
		 , C.ADM1Code
		 , D.ADM2Code
		 , A.RegionId
		 , A.ProvinceId
         , A.DistrictId
		 , A.SubdistrictId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ProvinceNameTH
		 , C.ProvinceNameEN
		 , D.DistrictNameTH
		 , D.DistrictNameEN
		 , C.AreaM2 AS ProvinceAreaM2
		 , D.AreaM2 AS DistrictAreaM2
	  FROM MSubdistrict A
		 , MDistrict D 
		 , MProvince C LEFT OUTER JOIN MRegion B ON B.RegionId = C.RegionId
	 WHERE A.ADM1Code = C.ADM1Code
	   AND A.ADM2Code = D.ADM2Code

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[PollingUnitView]    Script Date: 11/30/2022 12:35:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW PollingUnitView
AS
	SELECT A.ThaiYear
         , A.ADM1Code
	     , A.PollingUnitNo
	     , A.PollingUnitCount
	     , A.AreaRemark
		 , B.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , B.ProvinceId
		 , B.ProvinceNameEN
		 , B.ProvinceNameTH
	  FROM PollingUnit A LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[MPDVoteSummaryView]    Script Date: 11/26/2022 1:56:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[MPD2562VoteSummaryView]    Script Date: 12/2/2022 6:00:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********** Script Update Date: 2022-10-09  ***********/
CREATE VIEW [dbo].[MPDVoteSummaryView]
AS
    SELECT ROW_NUMBER() OVER
		   (
			   ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo, VoteCount DESC
		   ) AS RowNo
		 , ROW_NUMBER() OVER
		   (
		       PARTITION BY ThaiYear, ProvinceNameTH, PollingUnitNo
			   ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo, VoteCount DESC
		   ) AS RankNo
         , A.ThaiYear
         , A.ADM1Code
         , B.ProvinceId
         , B.ProvinceNameTH
         , B.ProvinceNameEN
         , B.RegionId
         , B.RegionName
         , B.GeoGroup
         , B.GeoSubgroup
	     , A.PollingUnitNo
	     , A.CandidateNo
	     , A.RevoteNo
	     , A.PartyId
         , C.PartyName
         , C.[Data] AS PartyImageData
	     , A.PersonId
         , D.Prefix
         , D.FirstName
         , D.LastName
         , LTRIM(RTRIM(
            LTRIM(RTRIM(D.Prefix)) + ' ' + 
            LTRIM(RTRIM(D.FirstName))+ ' ' + 
            LTRIM(RTRIM(D.LastName))
           )) AS FullName
         , D.DOB
         , D.GenderId
         , D.EducationId
         , D.OccupationId
         , D.[Remark] AS PersonRemark
         , D.[Data] AS PersonImageData
	     , A.VoteCount
	  FROM MPDVoteSummary A 
        LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code
        LEFT OUTER JOIN MParty C ON C.PartyId = A.PartyId
        LEFT OUTER JOIN MPerson D ON D.PersonId = A.PersonId

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[MPDStatVoterView]    Script Date: 12/4/2022 9:16:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDStatVoterView]
AS
	SELECT A.ThaiYear
         , A.ADM1Code
         , B.ProvinceId
         , B.ProvinceNameTH
         , B.ProvinceNameEN
         , B.RegionId
         , B.RegionName
         , B.GeoGroup
         , B.GeoSubgroup
	     , A.PollingUnitNo
         , A.RightCount
         , A.ExerciseCount
         , A.InvalidCount
         , A.NoVoteCount
		 , B.FullName
		 , B.PartyName
		 , B.VoteCount
		 , C.PollingUnitCount
	  FROM MPDStatVoter A
	  INNER JOIN PollingUnit C
		ON (   
		        C.ThaiYear = A.ThaiYear
			AND C.ADM1Code = A.ADM1Code
			AND C.PollingUnitNo = A.PollingUnitNo
		   )
	  INNER JOIN MPDVoteSummaryView B
		ON (
		        B.ThaiYear = A.ThaiYear
			AND	B.ADM1Code = A.ADM1Code
			AND B.PollingUnitNo = A.PollingUnitNo
		   )

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[MPDCView]    Script Date: 11/26/2022 1:56:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDCView]
AS
	SELECT A.ThaiYear
         , A.ADM1Code
         , B.ProvinceId
         , B.ProvinceNameTH
         , B.ProvinceNameEN
         , B.RegionId
         , B.RegionName
         , B.GeoGroup
         , B.GeoSubgroup
	     , A.PollingUnitNo
         , A.CandidateNo
         , A.PersonId
         , D.Prefix
         , D.FirstName
         , D.LastName
         , LTRIM(RTRIM(
            LTRIM(RTRIM(D.Prefix)) + ' ' + 
            LTRIM(RTRIM(D.FirstName))+ ' ' + 
            LTRIM(RTRIM(D.LastName))
           )) AS FullName
         , D.DOB
         , D.GenderId
         , D.OccupationId
         , D.[Remark] AS PersonRemark
         , D.[Data] AS PersonImageData
         , A.PrevPartyId
         , C.PartyName
         , C.[Data] AS PartyImageData
         , A.EducationId
         , E.[Description] AS EducationDescription
         , A.[Remark] AS CandidateRemark
         , A.SubGroup As CandidateSubGroup
	  FROM MPDC A
        LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code
        LEFT OUTER JOIN MParty C ON C.PartyId = A.PrevPartyId
        LEFT OUTER JOIN MPerson D ON D.PersonId = A.PersonId
        LEFT OUTER JOIN MEducation E ON E.EducationId = A.EducationId

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[MPDStatVoterSummaryView]    Script Date: 12/4/2022 9:22:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[__MPDStatVoterSummaryView]
AS
	SELECT POL.ThaiYear
		 , POL.ADM1Code
		 , POL.PollingUnitNo
		 , STA.RightCount
		 , STA.ExerciseCount
		 , STA.InvalidCount
		 , STA.NoVoteCount
		 , MVS.PartyId
		 , MVS.PartyName
		 , MVS.PersonId
		 , MVS.FullName
		 , MVS.VoteCount
	  FROM PollingUnit POL
	  JOIN 
		   MPDStatVoter STA ON (    STA.ThaiYear = POL.ThaiYear 
								AND STA.ADM1Code = POL.ADM1Code 
								AND STA.PollingUnitNo = POL.PollingUnitNo)
	  LEFT OUTER JOIN
		   (
			SELECT VSO.ThaiYear
				 , VSO.ADM1Code
				 , VSO.PollingUnitNo
				 , VSO.CandidateNo
				 , VSO.PartyId
				 , VSO.PartyName
				 , VSO.PersonId
				 , VSO.FullName
				 , VSO.VoteCount
			  FROM MPDVoteSummaryView VSO
			 WHERE VSO.VoteCount = 
				   (
					SELECT MAX(VS.VoteCount) AS VoteCount
					  FROM MPDVoteSummary VS
					 WHERE VS.ThaiYear = VSO.ThaiYear
					   AND VS.ADM1Code = VSO.ADM1Code
					   AND VS.PollingUnitNo = VSO.PollingUnitNo
					 GROUP BY VS.ThaiYear, VS.ADM1Code, VS.PollingUnitNo
				   )
		   ) MVS ON (    MVS.ThaiYear = POL.ThaiYear 
					 AND MVS.ADM1Code = POL.ADM1Code 
					 AND MVS.PollingUnitNo = POL.PollingUnitNo)

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  View [dbo].[MPDStatVoterSummaryView]    Script Date: 12/4/2022 9:22:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDStatVoterSummaryView]
AS
	SELECT A.ThaiYear
		 , A.ADM1Code
		 , B.ProvinceId
		 , B.ProvinceNameTH
		 , B.ProvinceNameEN
         , B.RegionId
         , B.RegionName
         , B.GeoGroup
         , B.GeoSubGroup
		 , A.PollingUnitNo
		 , D.PollingUnitCount
		 , A.RightCount
		 , A.ExerciseCount
		 , A.InvalidCount
		 , A.NoVoteCount
		 , A.PartyId
		 , A.PartyName
		 , A.PersonId
		 , C.Prefix
		 , C.FirstName
		 , C.LastName
		 , A.FullName
		 , A.VoteCount
      FROM __MPDStatVoterSummaryView A
	  LEFT OUTER JOIN MProvinceView B ON (A.ADM1Code = B.ADM1Code)
	  LEFT OUTER JOIN MPerson C ON (A.PersonId = C.PersonId)
	  LEFT OUTER JOIN PollingUnit D ON (A.ThaiYear = D.ThaiYear and A.ADM1Code = D.ADM1Code AND A.PollingUnitNo = D.PollingUnitNo)

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  UserDefinedFunction [dbo].[IsNullOrEmpty]    Script Date: 11/26/2022 2:02:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsNullOrEmpty.
-- Description:	IsNullOrEmpty is function to check is string is in null or empty
--              returns 1 if string is null or empty string otherwise return 0.
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.IsNullOrEmpty(null) AS RET;     -- NULL Returns 1
--SELECT dbo.IsNullOrEmpty('') AS RET;       -- Empty Returns 1
--SELECT dbo.IsNullOrEmpty(' ') AS RET;      -- Whitespace Returns 1
--SELECT dbo.IsNullOrEmpty('Test') AS RET;   -- Has data Returns 0
-- =============================================
CREATE FUNCTION [dbo].[IsNullOrEmpty](@str nvarchar)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    IF @str IS NULL OR RTRIM(LTRIM(@str)) = N''
		SET @result = 1
	ELSE SET @result = 0

    RETURN @result;
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  UserDefinedFunction [dbo].[SplitStringT]    Script Date: 11/26/2022 2:01:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SplitStringT.
-- Description:	Split String into substring (Remove empty elements).
-- [== History ==]
-- <2022-08-31> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.SplitStringT(N'Test  XXX  ', N' ')
--
-- =============================================
CREATE FUNCTION [dbo].[SplitStringT] 
( 
  @string nvarchar(MAX)
, @delim nvarchar(100)
)
RETURNS
@result TABLE 
( 
  [RowId] int  NOT NULL
, [Item] nvarchar(MAX) NOT NULL
, [Index] int NOT NULL 
, [Length] int  NOT NULL
)
AS
BEGIN
DECLARE   @str nvarchar(MAX)
		, @pos int 
		, @length int
		, @max int = LEN(@string)
		, @prv int = 1
		, @rowId int = 1

	SELECT @pos = CHARINDEX(@delim, @string)
	WHILE @pos > 0
	BEGIN
		SELECT @str = SUBSTRING(@string, @prv, @pos - @prv)
		SET @length = @pos - @prv;

		IF (LEN(LTRIM(RTRIM(@str))) > 0)
		BEGIN
			INSERT INTO @result SELECT @rowId
									 , LTRIM(RTRIM(@str))
									 , @prv
									 , @length
			SET @rowId = @rowId + 1 -- SET ROW ID AFTER INSERT
		END

		SELECT @prv = @pos + LEN(@delim)
		     , @pos = CHARINDEX(@delim, @string, @pos + 1)
	END

	SET @length = @max - @prv;
	SET @str = SUBSTRING(@string, @prv, @max)
	IF (LEN(LTRIM(RTRIM(@str))) > 0)
	BEGIN
		INSERT INTO @result SELECT @rowId
								 , LTRIM(RTRIM(@str))
								 , @prv
								 , @length
	END

	RETURN
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[Parse_FullName]    Script Date: 11/26/2022 2:05:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Extract Prefix, FirstName, LastName from FullName
-- [== History ==]
-- <2022-11-15> :
--	- Stored Procedure Created.
-- <2022-11-16> :
--	- Recheck after change MTitle structure.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[Parse_FullName] (
  @fullName nvarchar(MAX)
, @prefix nvarchar(MAX) = NULL out
, @firstName nvarchar(MAX) = NULL out
, @lastName nvarchar(MAX) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @sFullName nvarchar(MAX);
DECLARE @deli nvarchar(20) = N' ';
DECLARE @isRemove int; -- 0: Not Removed, 1: Removed
DECLARE @el nvarchar(MAX) = NULL;
DECLARE @sTest nvarchar(MAX);
DECLARE @sRemain nvarchar(MAX); -- Remain Text
DECLARE @fullTitle nvarchar(MAX);
DECLARE @matchTitle nvarchar(MAX);
	BEGIN TRY
		SET @prefix = NULL
		SET @firstName = NULL
		SET @lastName = NULL

		-- CHECK PARAMETERS
		IF (@fullName IS NULL OR LEN(@fullName) = 0)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = N'Parameter(s) is null.';
		END

		SET @sFullName = REPLACE(@fullName, N' ', N'') -- FullName that remove all spaces

		SELECT TOP 1 
		       @fullTitle = [Description]
			 , @matchTitle = REPLACE([Description], N' ', N'')
		  FROM MTitleView
		 WHERE @sFullName LIKE REPLACE([Description], N' ', N'') + N'%'
		 ORDER BY DLen DESC

		IF (@fullTitle IS NOT NULL)
		BEGIN
			SET @prefix = @fullTitle
			SET @isRemove = 0
			SET @sTest = N''
		END

		DECLARE SPLIT_STR_CURSOR CURSOR 
		  LOCAL FORWARD_ONLY READ_ONLY FAST_FORWARD 
		FOR  
		  SELECT Item FROM dbo.SplitStringT(@fullName, @deli)

		OPEN SPLIT_STR_CURSOR  
		-- FETCH FIRST
		FETCH NEXT FROM SPLIT_STR_CURSOR INTO @el

		WHILE @@FETCH_STATUS = 0  
		BEGIN
			IF ((@matchTitle IS NOT NULL) AND (@isRemove = 0))
			BEGIN
				-- @matchTitle is Title that remove all spaces.
				-- and @sTest also remove all spaces.
				IF (@sTest IS NULL) SET @sTest = N''
				SET @sTest = LTRIM(RTRIM(@sTest + @el))

				IF (@sTest LIKE @matchTitle + N'%')
				BEGIN
					SET @sRemain = REPLACE(@sTest, @matchTitle, N'')
					IF (LEN(@sRemain) > 0) SET @firstName = @sRemain
					SET @isRemove = 1 -- MARK AS REMOVED
				END
			END
			ELSE
			BEGIN
				-- PREFIX NOT FOUND -> FIND FIRST NAME
				IF (@firstName IS NULL)
				BEGIN
					-- FIRST NAME NOT FOUND SO USER CURRENT TEST VARIABLE
					SET @firstName = @el
				END
				ELSE
				BEGIN
					-- FIRST NAME FOUND THE REMAIN TEXT IS LAST NAME
					IF (@lastName IS NULL) SET @lastName = N''
					SET @lastName = LTRIM(RTRIM(@lastName + ' ' + @el))
				END
			END
			-- FETCH NEXT
			FETCH NEXT FROM SPLIT_STR_CURSOR INTO @el
		END

		CLOSE SPLIT_STR_CURSOR  
		DEALLOCATE SPLIT_STR_CURSOR 	

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMAges]    Script Date: 11/27/2022 9:58:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMAges
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMAges NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMAges]
(
  @active int = 1
)
AS
BEGIN
	SELECT *
	  FROM MAge
	 WHERE Active = COALESCE(@active, Active)
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMTitles]    Script Date: 11/27/2022 10:05:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMTitles
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMTitles NULL, NULL    -- Gets all
-- EXEC GetMTitles N'นาง', NULL  -- Search all that Description contains 'นาง'
-- EXEC GetMTitles NULL, 1       -- Search all that gender is male (0 - None, 1 - Male, 2 - Female)
-- =============================================
CREATE PROCEDURE [dbo].[GetMTitles]
(
  @description nvarchar(200) = NULL
, @genderId int = NULL
)
AS
BEGIN
	SELECT A.TitleId
         , A.[Description]
	     , B.[Description] AS GenderName
	     , A.GenderId
	     , A.DLen
	  FROM MTitleView A, MGender B
	 WHERE A.GenderId = B.GenderId
	   AND UPPER(LTRIM(RTRIM(A.[Description]))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@description, A.[Description])))) + '%'
	   AND A.GenderId = COALESCE(@genderId, A.GenderId)
	 ORDER BY A.DLen DESC
			, A.[Description]
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetUserRoles]    Script Date: 11/27/2022 10:08:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUserRoles
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetUserRoles NULL, NULL      -- Gets all
-- EXEC GetUserRoles 1, NULL         -- Get RoleId 1
-- EXEC GetUserRoles NULL, N'adm'    -- Gets all person images
-- =============================================
CREATE PROCEDURE [dbo].[GetUserRoles]
(
  @RoleId int = NULL
, @RoleName nvarchar(100) = NULL
)
AS
BEGIN
	SELECT *
	  FROM UserRole
	 WHERE RoleId = COALESCE(@RoleId, RoleId)
       AND UPPER(LTRIM(RTRIM(RoleName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RoleName, RoleName)))) + '%'
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetUsers]    Script Date: 11/27/2022 10:10:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUsers
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetUsers                                  -- Gets all active users
-- EXEC GetUsers N'user'                          -- Gets active all users that full name contains 'user'
-- EXEC GetUsers NULL, N'sup'                     -- Gets all active users that user name contains 'sup'
-- EXEC GetUsers NULL, NULL, N'u'                 -- Gets all active users that role name contains 'u'
-- EXEC GetUsers NULL, NULL, N'u', 10             -- Gets all active users that role name contains 'u' and RoleId = 10
-- EXEC GetUsers NULL, NULL, NULL, NULL, NULL     -- Gets all users (active/inactive)
-- =============================================
CREATE PROCEDURE [dbo].[GetUsers]
(
  @FullName nvarchar(200) = NULL
, @UserName nvarchar(100) = NULL
, @RoleName nvarchar(100) = NULL
, @RoleId int = NULL
, @Active int = 1
)
AS
BEGIN
	SELECT *
	  FROM UserInfoView
	 WHERE UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
       AND UPPER(LTRIM(RTRIM(UserName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@UserName, UserName)))) + '%'
       AND UPPER(LTRIM(RTRIM(RoleName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RoleName, RoleName)))) + '%'
       AND RoleId = COALESCE(@RoleId, RoleId)
       AND Active = COALESCE(@Active, Active)
     ORDER BY FullName, UserName
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetUser]    Script Date: 11/27/2022 10:15:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUser
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetUser N'user1', N'123'  -- Get active user that has UserName = 'user1' and password = '123'
-- =============================================
CREATE PROCEDURE [dbo].[GetUser]
(
  @UserName nvarchar(100)
, @Password nvarchar(100)
)
AS
BEGIN
	SELECT *
	  FROM UserInfoView
	 WHERE UPPER(LTRIM(RTRIM(UserName))) = UPPER(LTRIM(RTRIM(@UserName)))
       AND UPPER(LTRIM(RTRIM([Password]))) = UPPER(LTRIM(RTRIM(@Password)))
       AND Active = 1
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMGenders]    Script Date: 11/27/2022 10:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMGenders
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMGenders
-- =============================================
CREATE PROCEDURE [dbo].[GetMGenders]
AS
BEGIN
	SELECT GenderId
         , [Description]
	  FROM MGender
	 ORDER BY GenderId
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMOccupations]    Script Date: 11/27/2022 9:58:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMOccupations
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMOccupations NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMOccupations]
(
  @active int = 1
)
AS
BEGIN
	SELECT *
	  FROM MOccupation
	 WHERE Active = COALESCE(@active, Active)
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMEducations]    Script Date: 11/27/2022 9:58:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMEducations
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMEducations NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMEducations]
(
  @active int = 1
)
AS
BEGIN
	SELECT *
	  FROM MEducation
	 WHERE Active = COALESCE(@active, Active)
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  UserDefinedFunction [dbo].[CheckPartyIdReferences]    Script Date: 11/26/2022 2:02:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: CheckPartyIdReferences.
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.CheckPartyIdReferences(6) AS Count;
-- =============================================
CREATE FUNCTION [dbo].[CheckPartyIdReferences](@PartyId int)
RETURNS int
AS
BEGIN
DECLARE @result int;
DECLARE @cntMPD int
DECLARE @cntMPDC int
    SET @result = 0
    IF (@PartyId IS NOT NULL)
    BEGIN
            SELECT @cntMPD = COUNT(*) FROM MPDVoteSummary WHERE PartyId = @PartyId
            SELECT @cntMPDC = COUNT(*) FROM MPDC WHERE PrevPartyId = @PartyId

            SET @result = @cntMPD + @cntMPDC
    END

    RETURN @result;
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  UserDefinedFunction [dbo].[CheckPersonIdReferences]    Script Date: 11/26/2022 2:02:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: CheckPersonIdReferences.
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.CheckPersonIdReferences(6) AS Count;
-- =============================================
CREATE FUNCTION [dbo].[CheckPersonIdReferences](@PersonId int)
RETURNS int
AS
BEGIN
DECLARE @result int;
DECLARE @cntMPD int
DECLARE @cntMPDC int
    SET @result = 0
    IF (@PersonId IS NOT NULL)
    BEGIN
            SELECT @cntMPD = COUNT(*) FROM MPDVoteSummary WHERE PersonId = @PersonId
            SELECT @cntMPDC = COUNT(*) FROM MPDC WHERE PersonId = @PersonId

            SET @result = @cntMPD + @cntMPDC
    END

    RETURN @result;
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMRegion
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveMRegion N'01', N'ภาค 1', N'กลาง', N'กลาง';
--exec SaveMRegion N'02', N'ภาค 2', N'ตะวันออก', N'ตะวันออก';
--exec SaveMRegion N'03', N'ภาค 3', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนล่าง';
--exec SaveMRegion N'04', N'ภาค 4', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนบน';
--exec SaveMRegion N'05', N'ภาค 5', N'เหนือ', N'เหนือตอนบน';
--exec SaveMRegion N'06', N'ภาค 6', N'เหนือ', N'เหนือตอนล่าง';
--exec SaveMRegion N'07', N'ภาค 7', N'ตะวันตก', N'ตะวันตก';
--exec SaveMRegion N'08', N'ภาค 8', N'ใต้', N'ใต้ตอนบน';
--exec SaveMRegion N'09', N'ภาค 9', N'ใต้', N'ใต้ตอนล่าง';
--exec SaveMRegion N'10', N'ภาค 10', N'กลาง', N'กรุงเทพมหานคร';
-- =============================================
CREATE PROCEDURE SaveMRegion (
  @RegionId nvarchar(10)
, @RegionName nvarchar(100)
, @GeoGroup nvarchar(100)
, @GeoSubGroup nvarchar(100)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF ((@RegionId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MRegion
				 WHERE RegionId = @RegionId
			)
		   )
		BEGIN
			INSERT INTO MRegion
			(
				  RegionId
				, RegionName 
				, GeoGroup
				, GeoSubGroup
			)
			VALUES
			(
				  @RegionId
				, @RegionName
				, @GeoGroup
				, @GeoSubGroup
			);
		END
		ELSE
		BEGIN
			UPDATE MRegion
			   SET RegionName = @RegionName
				 , GeoGroup = @GeoGroup
				 , GeoSubGroup = @GeoSubGroup
			 WHERE RegionId = @RegionId
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMRegions
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMRegions NULL, NULL, NULL, NULL      -- Gets all
-- EXEC GetMRegions NULL, N'1', NULL, NULL      -- Search all that RegionName contains '1'
-- EXEC GetMRegions NULL, NULL, N'เหนือ', NULL   -- Search all that GeoGroup contains 'เหนือ'
-- EXEC GetMRegions NULL, NULL, NULL, N'ตอนบน'  -- Search all that GeoSubGroup contains 'ตอนบน'
-- =============================================
CREATE PROCEDURE GetMRegions
(
  @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(200) = NULL
, @GeoGroup nvarchar(200) = NULL
, @GeoSubGroup nvarchar(200) = NULL
)
AS
BEGIN
	SELECT RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
	  FROM MRegion
	 WHERE UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY RegionId
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMProvinces]    Script Date: 12/2/2022 6:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMProvinces
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMProvinces NULL, NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMProvinces]
(
  @RegionId nvarchar(20) = NULL
, @ADM1Code nvarchar(20) = NULL
)
AS
BEGIN
	SELECT ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , ProvinceAreaM2
	  FROM MProvinceView
	 WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	   AND (   UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
            OR (RegionId IS NULL AND @RegionId IS NULL)
           )
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMDistricts]    Script Date: 11/26/2022 3:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMDistricts
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMDistricts NULL, NULL, NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMDistricts]
(
  @RegionId nvarchar(20) = NULL
, @ADM1Code nvarchar(20) = NULL
, @ADM2Code nvarchar(20) = NULL
)
AS
BEGIN
	SELECT DistrictId
	     , DistrictNameTH
	     , DistrictNameEN
	     , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , ADM2Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , DistrictAreaM2
	  FROM MDistrictView
	 WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM2Code, ADM2Code))))
	   AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	   AND (   UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
            OR (RegionId IS NULL AND @RegionId IS NULL)
           )
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMSubdistricts]    Script Date: 11/26/2022 3:11:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMSubdistricts
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMSubdistricts]
(
  @RegionId nvarchar(20) = NULL
, @ADM1Code nvarchar(20) = NULL
, @ADM2Code nvarchar(20) = NULL
, @ADM3Code nvarchar(20) = NULL
)
AS
BEGIN
	SELECT SubdistrictId
	     , SubdistrictNameTH
	     , SubdistrictNameEN
	     , DistrictId
	     , DistrictNameTH
	     , DistrictNameEN
	     , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , ADM2Code
	     , ADM3Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , SubdistrictAreaM2
	  FROM MSubdistrictView
	 WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM3Code, ADM3Code))))
	   AND UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM2Code, ADM2Code))))
	   AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	   AND (   UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
            OR (RegionId IS NULL AND @RegionId IS NULL)
           )
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportADM1]    Script Date: 11/26/2022 3:17:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportADM1
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC ImportADM1 N'TH10', N'กรุงเทพมหานคร', N'Bangkok'
-- =============================================
CREATE PROCEDURE [dbo].[ImportADM1] (
  @ADM1Code nvarchar(20)
, @ProvinceNameTH nvarchar(200)
, @ProvinceNameEN nvarchar(200)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ADM1Code IS NULL OR @ProvinceNameTH IS NULL OR @ProvinceNameEN IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM MProvince
               WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
           ))
		BEGIN
			UPDATE MProvince
			   SET ProvinceNameEN = LTRIM(RTRIM(COALESCE(@ProvinceNameEN, ProvinceNameEN)))
				 , ProvinceNameTH = LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))
				 , AreaM2 = @AreaM2
			 WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
		END
        ELSE
        BEGIN
            INSERT INTO MProvince
            (
                  ADM1Code
                , ProvinceNameEN
                , ProvinceNameTH
                , AreaM2
            )
            VALUES
            (
                  LTRIM(RTRIM(@ADM1Code))
                , LTRIM(RTRIM(@ProvinceNameEN))
                , LTRIM(RTRIM(@ProvinceNameTH))
                , LTRIM(RTRIM(@AreaM2))
            )
        END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportADM2]    Script Date: 11/29/2022 7:02:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportADM2
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- ImportADM2 N'TH4711', N'อากาศอำนวย', N'Akat Amnuai', N'สกลนคร', N'Sakon Nakhon', 661338974.564
-- =============================================
CREATE PROCEDURE [dbo].[ImportADM2] (
  @ADM2Code nvarchar(20)
, @DistrictNameTH nvarchar(200)
, @DistrictNameEN nvarchar(200)
, @ProvinceNameTH nvarchar(200)
, @ProvinceNameEN nvarchar(200)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ADM1Code nvarchar(20)
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
			OR @ProvinceNameEN IS NULL 
		    OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL 
			OR @ADM2Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @ADM1Code = ADM1Code 
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
		   AND UPPER(LTRIM(RTRIM(ProvinceNameEN))) = UPPER(LTRIM(RTRIM(@ProvinceNameEN)))

		IF (@ADM1Code IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'ADM1Code is null';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM MDistrict
               WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(@ADM2Code)))
           ))
		BEGIN
			UPDATE MDistrict
			   SET DistrictNameEN = LTRIM(RTRIM(COALESCE(@DistrictNameEN, DistrictNameEN)))
				 , DistrictNameTH = LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH)))
				 , ADM1Code = UPPER(LTRIM(RTRIM(@ADM1Code)))
				 , AreaM2 = @AreaM2
			 WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(@ADM2Code)))
		END
        ELSE
        BEGIN
            INSERT INTO MDistrict
            (
                  ADM2Code
                , DistrictNameEN
                , DistrictNameTH
                , ADM1Code
                , AreaM2
            )
            VALUES
            (
                  LTRIM(RTRIM(@ADM2Code))
                , LTRIM(RTRIM(@DistrictNameEN))
                , LTRIM(RTRIM(@DistrictNameTH))
                , LTRIM(RTRIM(@ADM1Code))
                , LTRIM(RTRIM(@AreaM2))
            )
        END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportADM3]    Script Date: 11/29/2022 7:23:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportADM3
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC ImportADM3 N'TH200117', N'อากาศ', N'Akat', N'อากาศอำนวย', N'Akat Amnuai', N'สกลนคร', N'Sakon Nakhon', 6568129.19107
-- =============================================
CREATE PROCEDURE [dbo].[ImportADM3] (
  @ADM3Code nvarchar(20)
, @SubdistrictNameTH nvarchar(200)
, @SubdistrictNameEN nvarchar(200) = NULL
, @DistrictNameTH nvarchar(200)
, @DistrictNameEN nvarchar(200)
, @ProvinceNameTH nvarchar(200)
, @ProvinceNameEN nvarchar(200)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ADM1Code nvarchar(20)
DECLARE @ADM2Code nvarchar(20)
	BEGIN TRY
		IF (   @SubdistrictNameTH IS NULL 
			OR @SubdistrictNameEN IS NULL
		    OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL
		    OR @ProvinceNameTH IS NULL 
			OR @ProvinceNameEN IS NULL
			OR @ADM3Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @ADM1Code = ADM1Code 
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
		   AND UPPER(LTRIM(RTRIM(ProvinceNameEN))) = UPPER(LTRIM(RTRIM(@ProvinceNameEN)))

		SELECT @ADM2Code = ADM2Code 
		  FROM MDistrict
		 WHERE UPPER(LTRIM(RTRIM(DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))
		   AND UPPER(LTRIM(RTRIM(DistrictNameEN))) = UPPER(LTRIM(RTRIM(@DistrictNameEN)))

		IF (@ADM1Code IS NULL OR @ADM2Code IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'ADM1Code or ADM2Code is null';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM MSubdistrict
               WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(@ADM3Code)))
           ))
		BEGIN
			UPDATE MSubdistrict
			   SET SubdistrictNameEN = LTRIM(RTRIM(COALESCE(@SubdistrictNameEN, SubdistrictNameEN)))
				 , SubdistrictNameTH = LTRIM(RTRIM(COALESCE(@SubdistrictNameTH, SubdistrictNameTH)))
				 , ADM1Code = UPPER(LTRIM(RTRIM(@ADM1Code)))
				 , ADM2Code = UPPER(LTRIM(RTRIM(@ADM2Code)))
				 , AreaM2 = @AreaM2
			 WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(@ADM3Code)))
		END
        ELSE
        BEGIN
            INSERT INTO MSubdistrict
            (
                  ADM3Code
                , SubdistrictNameEN
                , SubdistrictNameTH
                , ADM1Code
                , ADM2Code
                , AreaM2
            )
            VALUES
            (
                  LTRIM(RTRIM(@ADM3Code))
                , LTRIM(RTRIM(@SubdistrictNameEN))
                , LTRIM(RTRIM(@SubdistrictNameTH))
                , LTRIM(RTRIM(@ADM1Code))
                , LTRIM(RTRIM(@ADM2Code))
                , LTRIM(RTRIM(@AreaM2))
            )
        END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportADMPak]    Script Date: 11/29/2022 8:11:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportADMPak
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportADMPak] (
  @RegionName nvarchar(200)
, @ProvinceId nvarchar(20)
, @ProvinceNameTH nvarchar(200)
, @DistrictId nvarchar(20)
, @DistrictNameTH nvarchar(200)
, @SubdistrictId nvarchar(20)
, @SubdistrictNameTH nvarchar(200)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @RegionId nvarchar(20)
DECLARE @ADM1Code nvarchar(20)
DECLARE @ADM2Code nvarchar(20)
DECLARE @ADM3Code nvarchar(20)
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
		    OR @DistrictNameTH IS NULL 
		    OR @SubdistrictNameTH IS NULL 
		    OR @ProvinceId IS NULL 
		    OR @DistrictId IS NULL 
		    OR @SubdistrictId IS NULL 
			OR @RegionName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @RegionId = RegionId
		  FROM MRegion
		 WHERE UPPER(LTRIM(RTRIM(RegionName))) = UPPER(LTRIM(RTRIM(@RegionName)))

		SELECT @ADM1Code = ADM1Code
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))

		SELECT @ADM2Code = ADM2Code 
		  FROM MDistrict
		 WHERE UPPER(LTRIM(RTRIM(DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))

		SELECT @ADM3Code = ADM3Code 
		  FROM MSubdistrict
		 WHERE UPPER(LTRIM(RTRIM(SubdistrictNameTH))) = UPPER(LTRIM(RTRIM(@SubdistrictNameTH)))

        /*
		IF (   @RegionId IS NULL
		    OR @ADM1Code IS NULL 
			OR @ADM2Code IS NULL
			OR @ADM3Code IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'RegionId or ADM1Code or ADM2Code or ADM3Code is null';
			RETURN
		END
        */

		-- Province
        IF (EXISTS(
              SELECT * 
			    FROM MProvince
               WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
           ))
		BEGIN
			UPDATE MProvince
			   SET RegionId = @RegionId
			     , ProvinceId = @ProvinceId
			 WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
		END

		-- District
        IF (EXISTS(
              SELECT * 
			    FROM MDistrict
               WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(@ADM2Code)))
           ))
		BEGIN
			UPDATE MDistrict
			   SET RegionId = @RegionId
			     , ProvinceId = @ProvinceId
			     , DistrictId = @DistrictId
			 WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(@ADM2Code)))
		END

		-- Subdistrict
        IF (EXISTS(
              SELECT * 
			    FROM MSubdistrict
               WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(@ADM3Code)))
           ))
		BEGIN
			UPDATE MSubdistrict
			   SET RegionId = @RegionId
			     , ProvinceId = @ProvinceId
			     , DistrictId = @DistrictId
			     , SubdistrictId = @SubdistrictId
			 WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(@ADM3Code)))
		END

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMADMPaks]    Script Date: 12/2/2022 1:47:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMADMPaks
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMADMPaks]
(
  @RegionId nvarchar(20) = NULL
, @ADM1Code nvarchar(20) = NULL
, @ADM2Code nvarchar(20) = NULL
, @ADM3Code nvarchar(20) = NULL
)
AS
BEGIN
	SELECT SubdistrictId
	     , SubdistrictNameTH
	     , SubdistrictNameEN
	     , DistrictId
	     , DistrictNameTH
	     , DistrictNameEN
	     , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , ADM2Code
	     , ADM3Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , SubdistrictAreaM2
	  FROM MSubdistrictView
	 WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM3Code, ADM3Code))))
	   AND UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM2Code, ADM2Code))))
	   AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	   AND (   UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
            OR (RegionId IS NULL AND @RegionId IS NULL)
           )
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetPollingUnits]    Script Date: 11/26/2022 3:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPollingUnits
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPollingUnits]
(
  @ThaiYear int = NULL
, @ADM1Code nvarchar(20) = NULL
, @ProvinceNameTH nvarchar(200) = NULL
, @RegionId nvarchar(20) = NULL
, @RegionName nvarchar(200) = NULL
, @GeoGroup nvarchar(200) = NULL
, @GeoSubGroup nvarchar(200) = NULL
)
AS
BEGIN
	SELECT ThaiYear
         , ADM1Code
	     , PollingUnitNo
	     , PollingUnitCount
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
         , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
         , AreaRemark
	  FROM PollingUnitView
	 WHERE ThaiYear = COALESCE(@ThaiYear, ThaiYear)
       AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY ThaiYear, RegionId, RegionName, ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportPollingUnit]    Script Date: 11/26/2022 3:17:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportPollingUnit
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportPollingUnit] (
  @ThaiYear int    
, @ProvinceNameTH nvarchar(200)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @AreaRemark nvarchar(MAX) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ADM1Code nvarchar(20)
	BEGIN TRY
		IF (   @ThaiYear IS NULL 
            OR @ProvinceNameTH IS NULL 
            OR @PollingUnitNo IS NULL 
            OR @PollingUnitCount IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @ADM1Code = ADM1Code 
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))

		IF (@ADM1Code IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'ADM1Code is null';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM PollingUnit
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
           ))
		BEGIN
			UPDATE PollingUnit
			   SET PollingUnitCount = COALESCE(@PollingUnitCount, PollingUnitCount)
				 , AreaRemark = LTRIM(RTRIM(COALESCE(@AreaRemark, AreaRemark)))
			 WHERE ThaiYear = @ThaiYear
               AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
               AND PollingUnitNo = @PollingUnitNo
		END
        ELSE
        BEGIN
            INSERT INTO PollingUnit
            (
                  ThaiYear
                , ADM1Code
                , PollingUnitNo
                , PollingUnitCount
                , AreaRemark
            )
            VALUES
            (
                  @ThaiYear
                , LTRIM(RTRIM(@ADM1Code))
                , @PollingUnitNo
                , @PollingUnitCount
                , LTRIM(RTRIM(@AreaRemark))
            )
        END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMParties]    Script Date: 11/26/2022 1:15:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMParties
-- [== History ==]
-- <2022-09-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--DECLARE @pageNum as int = 1
--DECLARE @rowsPerPage as int = 10
--DECLARE @totalRecords as int = 0
--DECLARE @maxPage as int = 0
--
--EXEC GetMParties 'กร', @pageNum out, @rowsPerPage out, @totalRecords out, @maxPage out
--SELECT @totalRecords AS TotalPage, @maxPage AS MaxPage
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMParties]
(
  @PartyName nvarchar(200) = null
, @pageNum as int = 1 out
, @rowsPerPage as int = 10 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @sPartyName nvarchar(100)
	BEGIN TRY
		IF (@PartyName IS NULL)
		BEGIN
			SET @sPartyName = N''
		END
		ELSE
		BEGIN
			SET @sPartyName = UPPER(RTRIM(LTRIM(@PartyName)))
		END

		-- calculate total record and maxpages
		SELECT @totalRecords = COUNT(PartyId) 
		  FROM MParty
		 WHERE UPPER(RTRIM(LTRIM(PartyName))) LIKE '%' + @sPartyName + '%'

		SELECT @maxPage = 
			CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
				(@totalRecords / @rowsPerPage) + 1
			ELSE 
				(@totalRecords / @rowsPerPage)
			END;

		WITH SQLPaging AS
		(
			SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY PartyName) AS RowNo
			     , PartyId
			     , PartyName
				 , [Data]
			  FROM MParty
			 WHERE UPPER(RTRIM(LTRIM(PartyName))) LIKE '%' + @sPartyName + '%'
			 ORDER BY PartyName
		)
		SELECT * FROM SQLPaging WITH (NOLOCK) 
			WHERE RowNo > ((@pageNum - 1) * @rowsPerPage);

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH

END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMParty]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMParty
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @partyId int
-- DECLARE @partyName nvarchar(200)
-- 
-- SET @partyName = N'พลังประชารัฐ 2';
-- EXEC SaveMParty @partyName, @partyId out, @errNum out, @errMsg out
-- 
-- SELECT @partyId AS PartyId
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MParty
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SaveMParty] (
  @partyName nvarchar(200)
, @PartyId int = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @matchId int
	BEGIN TRY
        -- FIND ID
        IF (@PartyId IS NULL OR @PartyId <= 0)
        BEGIN
            SELECT @matchId = PartyId 
              FROM MParty 
             WHERE UPPER(LTRIM(RTRIM(PartyName))) = UPPER(LTRIM(RTRIM(@PartyName)))
            -- REPLACE ID IN CASE PartyName is EXISTS but not specificed Id when call this SP
            SET @PartyId = @matchId
        END

		IF (@PartyId IS NULL)
		BEGIN
			INSERT INTO MParty
			(
				  PartyName 
			)
			VALUES
			(
				  LTRIM(RTRIM(@PartyName))
			);

			SET @PartyId = @@IDENTITY;
		END
        ELSE
        BEGIN
            UPDATE MParty
               SET PartyName = LTRIM(RTRIM(@PartyName))
             WHERE PartyId = @PartyId;
        END

        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMParty]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMParty
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMParty] (
  @PartyId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
        SELECT PartyId
             , PartyName
          FROM MParty
         WHERE PartyId = @PartyId
        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPartyImage]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPartyImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @PartyId int
-- 
-- DECLARE @jsonData NVARCHAR(MAX) = N'{"age":1,"name":"sample"}'
-- DECLARE @data VARBINARY(MAX) = CONVERT(VARBINARY(MAX), @jsonData)
-- 
-- SET @PartyId = 3;
-- EXEC SaveMPartyImage @PartyId, @data, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MParty
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SaveMPartyImage] (
  @PartyId int
, @Data varbinary(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@PartyId IS NOT NULL)
		BEGIN
            UPDATE MParty
               SET [Data] = @Data
             WHERE PartyId = @PartyId;
        END

        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPartyImage]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPartyImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @PartyId int
--
-- SET @PartyId = 3
-- 
-- EXEC GetMPartyImage @PartyId, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMPartyImage] (
  @PartyId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
        SELECT PartyId
             , PartyName
             , [Data]
          FROM MParty
         WHERE PartyId = @PartyId
        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[DeleteMParty]    Script Date: 11/26/2022 1:31:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeleteMParty
-- [== History ==]
-- <2022-09-12> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- 
-- EXEC DeleteMParty 4, @errNum out, @errMsg out
--  
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MParty
-- 
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMParty] (
  @PartyId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @cnt int
	BEGIN TRY
        IF (@PartyId IS NOT NULL)
        BEGIN
            SELECT @cnt = dbo.CheckPartyIdReferences(@PartyId)

            IF (@cnt > 0)
            BEGIN
		        SET @errNum = 201;
		        SET @errMsg = N'Cannot delete data that in used in another table(s).';
                RETURN
            END

            DELETE 
              FROM MParty
             WHERE PartyId = @PartyId
        END

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPartyImage]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPartyImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @partyName nvarchar(200)
-- 
-- DECLARE @jsonData NVARCHAR(MAX) = N'{"age":1,"name":"sample"}'
-- DECLARE @data VARBINARY(MAX) = CONVERT(VARBINARY(MAX), @jsonData)
-- 
-- SET @partyName = N'พลังประชารัฐ';
-- EXEC ImportMPartyImage @partyName, @data, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MParty
-- 
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPartyImage] (
  @PartyName nvarchar(200)
, @Data varbinary(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @PartyId int;
	BEGIN TRY
        -- Call Save to get PartyId
        EXEC SaveMParty @PartyName, @PartyId out, @errNum out, @errMsg out

        IF (@errNum <> 0)
        BEGIN
            RETURN
        END

		IF (@PartyId IS NOT NULL)
		BEGIN
            UPDATE MParty
               SET [Data] = @Data
             WHERE PartyId = @PartyId;
        END

        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPersons]    Script Date: 11/26/2022 1:35:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPersons
-- [== History ==]
-- <2022-09-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--DECLARE @pageNum as int = 1
--DECLARE @rowsPerPage as int = 10
--DECLARE @totalRecords as int = 0
--DECLARE @maxPage as int = 0
--
--EXEC GetMPersons NULL, 'กร', NULL, @pageNum out, @rowsPerPage out, @totalRecords out, @maxPage out
--SELECT @totalRecords AS TotalPage, @maxPage AS MaxPage
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPersons]
(
  @Prefix nvarchar(100) = null
, @FirstName nvarchar(200) = null
, @LastName nvarchar(200) = null
, @pageNum as int = 1 out
, @rowsPerPage as int = 10 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
	BEGIN TRY
		-- calculate total record and maxpages
		SELECT @totalRecords = COUNT(*) 
		  FROM MPerson
		 WHERE UPPER(RTRIM(LTRIM(Prefix))) LIKE '%' + COALESCE(@Prefix, Prefix) + '%'
           AND UPPER(RTRIM(LTRIM(FirstName))) LIKE '%' + COALESCE(@FirstName, FirstName) + '%'
           AND UPPER(RTRIM(LTRIM(LastName))) LIKE '%' + COALESCE(@LastName, LastName) + '%'

		SELECT @maxPage = 
			CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
				(@totalRecords / @rowsPerPage) + 1
			ELSE 
				(@totalRecords / @rowsPerPage)
			END;

		WITH SQLPaging AS
		(
			SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() 
              OVER (ORDER BY FirstName, LastName) AS RowNo
			     , PersonId
			     , Prefix
			     , FirstName
			     , LastName
                 , DOB
                 , GenderId
                 , EducationId
                 , OccupationId
                 , [Remark]
				 , [Data]
			  FROM MPerson
		     WHERE UPPER(RTRIM(LTRIM(Prefix))) LIKE '%' + COALESCE(@Prefix, Prefix) + '%'
               AND UPPER(RTRIM(LTRIM(FirstName))) LIKE '%' + COALESCE(@FirstName, FirstName) + '%'
               AND UPPER(RTRIM(LTRIM(LastName))) LIKE '%' + COALESCE(@LastName, LastName) + '%'
		)
		SELECT * FROM SQLPaging WITH (NOLOCK) 
			WHERE RowNo > ((@pageNum - 1) * @rowsPerPage);

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH

END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPerson]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPerson
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SaveMPerson] (
  @Prefix nvarchar(100)
, @FirstName nvarchar(200)
, @LastName nvarchar(200)
, @DOB datetime = NULL
, @GenderId int = NULL
, @EducationId int = NULL
, @OccupationId int = NULL
, @Remark nvarchar(MAX) = NULL
, @PersonId int = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @matchId int
	BEGIN TRY
        -- FIND ID
        IF (@PersonId IS NULL OR @PersonId <= 0)
        BEGIN
            SELECT @matchId = PersonId 
              FROM MPerson 
             WHERE UPPER(LTRIM(RTRIM(FirstName))) = UPPER(LTRIM(RTRIM(@FirstName)))
               AND UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@LastName)))
            -- REPLACE ID IN CASE PartyName is EXISTS but not specificed Id when call this SP
            SET @PersonId = @matchId
        END

		IF (@PersonId IS NULL)
		BEGIN
			INSERT INTO MPerson
			(
				  Prefix 
                , FirstName 
                , LastName 
                , DOB
                , GenderId
                , EducationId
                , OccupationId
                , [Remark]
			)
			VALUES
			(
				  LTRIM(RTRIM(@Prefix))
                , LTRIM(RTRIM(@FirstName))
                , LTRIM(RTRIM(@LastName))
                , @DOB
                , @GenderId
                , @EducationId
                , @OccupationId
                , LTRIM(RTRIM(@Remark))
			);

			SET @PersonId = @@IDENTITY;
		END
        ELSE
        BEGIN
            UPDATE MPerson
               SET Prefix = LTRIM(RTRIM(COALESCE(@Prefix, Prefix)))
                 , FirstName = LTRIM(RTRIM(COALESCE(@FirstName, FirstName)))
                 , LastName = LTRIM(RTRIM(COALESCE(@LastName, LastName)))
                 , DOB = COALESCE(@DOB, DOB)
                 , GenderId = COALESCE(@GenderId, GenderId)
                 , EducationId = COALESCE(@EducationId, EducationId)
                 , OccupationId = COALESCE(@OccupationId, OccupationId)
                 , [Remark] = LTRIM(RTRIM(COALESCE(@Remark, Remark)))
             WHERE PersonId = @PersonId;
        END

        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPerson]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPerson
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMPerson] (
  @PersonId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
        SELECT A.PersonId
             , A.Prefix
             , A.FirstName
             , A.LastName
             , LTRIM(RTRIM(
                LTRIM(RTRIM(A.Prefix)) + ' ' + 
                LTRIM(RTRIM(A.FirstName)) + ' ' + 
                LTRIM(RTRIM(A.LastName))
               )) AS FullName
             , A.DOB
             , A.GenderId
             , B.[Description] AS GenderDescription
             , A.EducationId
             , C.[Description] AS EducationDescription
             , A.OccupationId
             , D.[Description] AS OccupationDescription
             , A.[Remark]
          FROM MPerson A 
            LEFT OUTER JOIN MGender B ON B.GenderId = A.GenderId
            LEFT OUTER JOIN MEducation C ON C.EducationId = A.EducationId
            LEFT OUTER JOIN MOccupation D ON D.OccupationId = A.OccupationId
         WHERE A.PersonId = @PersonId
        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPersonImage]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPersonImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @PersonId int
-- 
-- DECLARE @jsonData NVARCHAR(MAX) = N'{"age":1,"name":"sample"}'
-- DECLARE @data VARBINARY(MAX) = CONVERT(VARBINARY(MAX), @jsonData)
-- 
-- SET @PersonId = 3;
-- EXEC SaveMPersonImage @PersonId, @data, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MPerson
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SaveMPersonImage] (
  @PersonId int
, @Data varbinary(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@PersonId IS NOT NULL)
		BEGIN
            UPDATE MPerson
               SET [Data] = @Data
             WHERE PersonId = @PersonId;
        END

        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPersonImage]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPersonImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @PersonId int
--
-- SET @PersonId = 3
-- 
-- EXEC GetMPersonImage @PersonId, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMPersonImage] (
  @PersonId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
        SELECT A.PersonId
             , A.Prefix
             , A.FirstName
             , A.LastName
             , LTRIM(RTRIM(
                LTRIM(RTRIM(A.Prefix)) + ' ' + 
                LTRIM(RTRIM(A.FirstName)) + ' ' + 
                LTRIM(RTRIM(A.LastName))
               )) AS FullName
             , A.DOB
             , A.GenderId
             , B.[Description] AS GenderDescription
             , A.EducationId
             , C.[Description] AS EducationDescription
             , A.OccupationId
             , D.[Description] AS OccupationDescription
             , A.[Remark]
             , A.[Data]
          FROM MPerson A 
            LEFT OUTER JOIN MGender B ON B.GenderId = A.GenderId
            LEFT OUTER JOIN MEducation C ON C.EducationId = A.EducationId
            LEFT OUTER JOIN MOccupation D ON D.OccupationId = A.OccupationId
         WHERE A.PersonId = @PersonId
        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[DeleteMPerson]    Script Date: 11/26/2022 1:31:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeleteMPerson
-- [== History ==]
-- <2022-09-12> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- 
-- EXEC DeleteMPerson 4, @errNum out, @errMsg out
--  
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MPerson
-- 
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMPerson] (
  @PersonId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @cnt int
	BEGIN TRY
        IF (@PersonId IS NOT NULL)
        BEGIN
            SELECT @cnt = dbo.CheckPersonIdReferences(@PersonId)

            IF (@cnt > 0)
            BEGIN
		        SET @errNum = 201;
		        SET @errMsg = N'Cannot delete data that in used in another table(s).';
                RETURN
            END

            DELETE 
              FROM MPerson
             WHERE PersonId = @PersonId
        END

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPersonImage]    Script Date: 11/26/2022 1:41:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPersonImage
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPersonImage] (
  @FullName nvarchar(MAX)
, @Data varbinary(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @PersonId int;
DECLARE @Prefix nvarchar(100)
DECLARE @FirstName nvarchar(200)
DECLARE @LastName nvarchar(200)
DECLARE @GenderId int;
	BEGIN TRY
        -- Parse Full Name into Prefix, FirstName, LastName
        EXEC Parse_FullName @FullName, @Prefix out, @FirstName out, @LastName out

        IF (@FirstName IS NULL AND @LastName IS NULL)
        BEGIN
		    SET @errNum = 100;
		    SET @errMsg = 'Parser cannot extract firstname and lastname.';
            RETURN
        END

        SELECT @GenderId = GenderId 
          FROM MTitle 
         WHERE UPPER(LTRIM(RTRIM([Description]))) = UPPER(LTRIM(RTRIM(@Prefix)))
        
        IF (@GenderId IS NULL) SET @GenderId = 0

        -- Call Save to get PartyId
        EXEC SaveMPerson @Prefix, @FirstName, @LastName
                       , NULL -- DOB
                       , @GenderId -- GenderId
                       , NULL -- EducationId
                       , NULL -- OccupationId
                       , NULL -- Remark
                       , @PersonId out -- PersonId
                       , @errNum out, @errMsg out

        IF (@errNum <> 0)
        BEGIN
            RETURN
        END

		IF (@PersonId IS NOT NULL)
		BEGIN
			UPDATE MPerson
			   SET [Data] = @Data
             WHERE PersonId = @PersonId;
		END

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPDVoteSummary]    Script Date: 11/26/2022 3:17:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPDVoteSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(max)
-- DECLARE @ProvinceName nvarchar(200)
-- DECLARE @PollingUnitNo int
-- DECLARE @CandidateNo int
-- DECLARE @PartyName nvarchar(200)
-- DECLARE @FullName nvarchar(max)
-- DECLARE @VoteCount int
-- DECLARE @RevoteNo int
-- 
-- SET @ProvinceName = N'เชียงใหม่'
-- SET @PollingUnitNo = 1
-- SET @CandidateNo = 6
-- SET @PartyName = N'เพื่อไทย'
-- SET @FullName = N'นางสาว ทัศนีย์ บูรณุปกรณ์'
-- SET @VoteCount = 46034
-- SET @RevoteNo = 0
-- 
-- EXEC ImportMPDVoteSummary 2562
--                         , @ProvinceName, @PollingUnitNo
-- 						   , @CandidateNo
-- 						   , @PartyName, @FullName
-- 						   , @VoteCount, @RevoteNo
-- 						   , @errNum out, @errMsg out
-- SELECT @errNum as ErrNum, @errMsg as ErrMsg
-- 
-- -- =============================================
CREATE PROCEDURE [dbo].[ImportMPDVoteSummary] (
  @ThaiYear int    
, @ProvinceNameTH nvarchar(200)
, @PollingUnitNo int
, @CandidateNo int
, @PartyName nvarchar(200)
, @FullName nvarchar(MAX)
, @VoteCount int = 0
, @RevoteNo int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ADM1Code nvarchar(20)
DECLARE @GenderId int
DECLARE @PartyId int
DECLARE @PersonId int
DECLARE @Prefix nvarchar(MAX) = null
DECLARE @FirstName nvarchar(MAX) = null
DECLARE @LastName nvarchar(MAX) = null
	BEGIN TRY
		IF (   @ThaiYear IS NULL 
            OR @ProvinceNameTH IS NULL 
            OR @PollingUnitNo IS NULL 
            OR @CandidateNo IS NULL
            OR @RevoteNo IS NULL
            OR @PartyName IS NULL
            OR @FullName IS NULL
           )
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @ADM1Code = ADM1Code 
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))

        -- Call Save to get PartyId
        EXEC SaveMParty @PartyName, @PartyId out, @errNum out, @errMsg out

        IF (@errNum <> 0)
        BEGIN
            RETURN
        END

		IF (@ADM1Code IS NULL OR @PartyId IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'ADM1Code or PartyId is null';
			RETURN
		END

        EXEC Parse_FullName @FullName, @Prefix out, @FirstName out, @LastName out

		IF (@FirstName IS NULL OR @LastName IS NULL)
		BEGIN
			SET @errNum = 102;
			SET @errMsg = 'Cannot Parse FullName.';
			RETURN
		END

        -- Call Save to get PersonId
        EXEC SaveMPerson @Prefix, @FirstName, @LastName
                       , NULL -- DOB
                       , @GenderId -- GenderId
                       , NULL -- EducationId
                       , NULL -- OccupationId
                       , NULL -- Remark
                       , @PersonId out -- PersonId
                       , @errNum out, @errMsg out

        IF (@errNum <> 0)
        BEGIN
            RETURN
        END

		IF (@PersonId IS NULL)
		BEGIN
			SET @errNum = 103;
			SET @errMsg = 'Cannot find PersonId.';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM MPDVoteSummary
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
                 AND CandidateNo = @CandidateNo
                 AND RevoteNo = @RevoteNo
                 AND PartyId = @PartyId
                 AND PersonId = @PersonId
           ))
		BEGIN
			  UPDATE MPDVoteSummary
			     SET VoteCount = COALESCE(@VoteCount, VoteCount)
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
                 AND CandidateNo = @CandidateNo
                 AND RevoteNo = @RevoteNo
                 AND PartyId = @PartyId
                 AND PersonId = @PersonId
		END
        ELSE
        BEGIN
            INSERT INTO MPDVoteSummary
            (
                  ThaiYear
                , ADM1Code
                , PollingUnitNo
                , CandidateNo
                , RevoteNo
                , PartyId
                , PersonId
                , VoteCount
            )
            VALUES
            (
                  @ThaiYear
                , LTRIM(RTRIM(@ADM1Code))
                , @PollingUnitNo
                , @CandidateNo
                , @RevoteNo
                , @PartyId
                , @PersonId
                , @VoteCount
            )
        END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPDStatVoter]    Script Date: 11/26/2022 3:17:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPDStatVoter
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(max)
-- DECLARE @ProvinceName nvarchar(200)
-- DECLARE @PollingUnitNo int
-- DECLARE @RightCount int
-- DECLARE @ExerciseCount int
-- DECLARE @InvalidCount int
-- DECLARE @NoVoteCount int
-- 
-- SET @ProvinceName = N'เชียงใหม่'
-- SET @PollingUnitNo = 1
-- SET @RightCount = 20
-- SET @ExerciseCount = 10
-- SET @InvalidCount = 6
-- SET @NoVoteCount = 4
-- 
-- EXEC ImportMPDStatVoter 2562
--                       , @ProvinceName, @PollingUnitNo
-- 						 , @RightCount, @ExerciseCount, @InvalidCount, @NoVoteCount
-- 						 , @errNum out, @errMsg out
-- SELECT @errNum as ErrNum, @errMsg as ErrMsg
-- 
-- -- =============================================
CREATE PROCEDURE [dbo].[ImportMPDStatVoter] (
  @ThaiYear int    
, @ProvinceNameTH nvarchar(200)
, @PollingUnitNo int
, @RightCount int = 0
, @ExerciseCount int = 0
, @InvalidCount int = 0
, @NoVoteCount int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ADM1Code nvarchar(20)
DECLARE @Prefix nvarchar(MAX) = null
DECLARE @FirstName nvarchar(MAX) = null
DECLARE @LastName nvarchar(MAX) = null
	BEGIN TRY
		IF (   @ThaiYear IS NULL 
            OR @ProvinceNameTH IS NULL 
            OR @PollingUnitNo IS NULL
           )
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @ADM1Code = ADM1Code 
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))

		IF (@ADM1Code IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'ADM1Code is null';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM MPDStatVoter
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
           ))
		BEGIN
            UPDATE MPDStatVoter
               SET RightCount = COALESCE(@RightCount, RightCount)
                 , ExerciseCount = COALESCE(@ExerciseCount, ExerciseCount)
                 , InvalidCount = COALESCE(@InvalidCount, InvalidCount)
                 , NoVoteCount = COALESCE(@NoVoteCount, NoVoteCount)
             WHERE ThaiYear = @ThaiYear
               AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
               AND PollingUnitNo = @PollingUnitNo
		END
        ELSE
        BEGIN
            INSERT INTO MPDStatVoter
            (
                  ThaiYear
                , ADM1Code
                , PollingUnitNo
                , RightCount
                , ExerciseCount
                , InvalidCount
                , NoVoteCount
            )
            VALUES
            (
                  @ThaiYear
                , LTRIM(RTRIM(@ADM1Code))
                , @PollingUnitNo
                , @RightCount
                , @ExerciseCount
                , @InvalidCount
                , @NoVoteCount
            )
        END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPDC]    Script Date: 11/26/2022 3:17:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPDC
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(max)
-- DECLARE @ProvinceName nvarchar(200)
-- DECLARE @PollingUnitNo int
-- DECLARE @CandidateNo int
-- DECLARE @PrevPartyName nvarchar(200)
-- DECLARE @FullName nvarchar(max)
-- DECLARE @Remark nvarchar(max)
-- DECLARE @SubGroup nvarchar(max)
-- DECLARE @EducationId int
-- 
-- SET @ProvinceName = N'กรุงเทพมหานคร'
-- SET @PollingUnitNo = 1
-- SET @CandidateNo = 1
-- SET @FullName = N'นางสาว กานต์กนิษฐ์ แห้วสันตติ'
-- SET @PrevPartyName = NULL
-- SET @Remark = N'ข้อมูลทดสอบ หมายเหตุ'
-- SET @SubGroup = N'อ.แหม่ม'
-- SET @EducationId = NULL
-- 
-- EXEC ImportMPDC 2566
--               , @ProvinceName, @PollingUnitNo
-- 			     , @CandidateNo
-- 				 , @FullName, @PrevPartyName
-- 			     , @Remark, @SubGroup, @EducationId
-- 				 , @errNum out, @errMsg out
-- SELECT @errNum as ErrNum, @errMsg as ErrMsg
-- 
-- -- =============================================
CREATE PROCEDURE [dbo].[ImportMPDC] (
  @ThaiYear int    
, @ProvinceNameTH nvarchar(200)
, @PollingUnitNo int
, @CandidateNo int
, @FullName nvarchar(MAX)
, @PrevPartyName nvarchar(200) = NULL
, @Remark nvarchar(max) = NULL
, @SubGroup nvarchar(max) = NULL
, @EducationId int = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ADM1Code nvarchar(20)
DECLARE @GenderId int
DECLARE @PartyId int
DECLARE @PersonId int
DECLARE @Prefix nvarchar(MAX) = null
DECLARE @FirstName nvarchar(MAX) = null
DECLARE @LastName nvarchar(MAX) = null
	BEGIN TRY
		IF (   @ThaiYear IS NULL 
            OR @ProvinceNameTH IS NULL 
            OR @PollingUnitNo IS NULL 
            OR @CandidateNo IS NULL
            OR @FullName IS NULL
           )
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @ADM1Code = ADM1Code 
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))

		IF (@ADM1Code IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'ADM1Code is null';
			RETURN
		END

        EXEC Parse_FullName @FullName, @Prefix out, @FirstName out, @LastName out

		IF (@FirstName IS NULL OR @LastName IS NULL)
		BEGIN
			SET @errNum = 102;
			SET @errMsg = 'Cannot Parse FullName.';
			RETURN
		END

        -- Call Save to get PersonId
        EXEC SaveMPerson @Prefix, @FirstName, @LastName
                       , NULL -- DOB
                       , @GenderId -- GenderId
                       , NULL -- EducationId
                       , NULL -- OccupationId
                       , NULL -- Remark
                       , @PersonId out -- PersonId
                       , @errNum out, @errMsg out

        IF (@errNum <> 0)
        BEGIN
            RETURN
        END

        -- CHECK Prev Party
        IF (@PrevPartyName IS NOT NULL)
        BEGIN
            -- Call Save to get PartyId
            EXEC SaveMParty @PrevPartyName, @PartyId out, @errNum out, @errMsg out

            IF (@errNum <> 0)
            BEGIN
                RETURN
            END
        END

		IF (@PersonId IS NULL)
		BEGIN
			SET @errNum = 103;
			SET @errMsg = 'Cannot find PersonId.';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM MPDC
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
                 AND CandidateNo = @CandidateNo
           ))
		BEGIN
			  UPDATE MPDC
			     SET PersonId = @PersonId
                   , PrevPartyId = @PartyId
                   , EducationId = COALESCE(@EducationId, EducationId)
                   , [Remark] = COALESCE(@Remark, [Remark])
                   , SubGroup = COALESCE(@SubGroup, SubGroup)
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
                 AND CandidateNo = @CandidateNo
		END
        ELSE
        BEGIN
            INSERT INTO MPDC
            (
                  ThaiYear
                , ADM1Code
                , PollingUnitNo
                , CandidateNo
                , PersonId
                , PrevPartyId
                , EducationId
                , [Remark]
                , SubGroup
            )
            VALUES
            (
                  @ThaiYear
                , LTRIM(RTRIM(@ADM1Code))
                , @PollingUnitNo
                , @CandidateNo
                , @PersonId
                , @PartyId
                , @EducationId
                , @Remark
                , @SubGroup
            )
        END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[DeleteMPDC]    Script Date: 12/2/2022 6:53:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeleteMPDC
-- [== History ==]
-- <2022-10-08> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMPDC] (
  @ThaiYear int    
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @CandidateNo int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int
	BEGIN TRY
		IF (@ThaiYear IS NULL
         OR @ADM1Code IS NULL 
		 OR @PollingUnitNo IS NULL
		 OR @CandidateNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END

		DELETE  
		  FROM MPDC
		 WHERE ThaiYear = @ThaiYear
           AND ADM1Code = @ADM1Code
		   AND PollingUnitNo = @PollingUnitNo
		   AND CandidateNo = @CandidateNo

		UPDATE MPDC
		  SET CandidateNo = CandidateNo - 1
		 WHERE ThaiYear = @ThaiYear
           AND ADM1Code = @ADM1Code
		   AND PollingUnitNo = @PollingUnitNo
		   AND CandidateNo >= @CandidateNo

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPDC]    Script Date: 12/2/2022 7:20:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPDC
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-07> :
--	- Add SubGroup parameter.
-- <2022-10-08> :
--	- Add Data parameter.
--	- Add ProvinceNameOri parameter.
--	- Add PollingUnitNoOri parameter.
--	- Add CandidateNoOri parameter.
--	- Add FullNameOri parameter.
--  - Add ImageFullNameOri parameter
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[SaveMPDC] (
  @ThaiYear int    
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @CandidateNo int
, @Prefix nvarchar(100)
, @FirstName nvarchar(200)
, @LastName nvarchar(200)
, @PrevPartyId int = NULL
, @Remark nvarchar(max) = NULL
, @SubGroup nvarchar(max) = NULL
, @EducationId int = null
, @ADM1CodeOri nvarchar(100) = NULL
, @PollingUnitNoOri int = NULL
, @CandidateNoOri int = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @PersonId int
DECLARE @SkipNo int
DECLARE @iCnt int
DECLARE @iMaxCandidateNo int
	BEGIN TRY
		IF (@ThaiYear IS NULL 
		 OR @ADM1Code IS NULL 
		 OR @PollingUnitNo IS NULL 
		 OR @PollingUnitNo < 1 
		 OR @CandidateNo IS NULL
		 OR @FirstName IS NULL
		 OR @LastName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END

        -- Call Save to get PersonId
        EXEC SaveMPerson @Prefix, @FirstName, @LastName
                       , NULL -- DOB
                       , NULL -- GenderId
                       , NULL -- EducationId
                       , NULL -- OccupationId
                       , NULL -- Remark
                       , @PersonId out -- PersonId
                       , @errNum out, @errMsg out

        IF (@errNum <> 0)
        BEGIN
            RETURN
        END

		IF (@PersonId IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'Cannot find PersonId from firstname and lastname.';
			RETURN
		END

		IF ((@ADM1CodeOri IS NULL) AND
		    (@PollingUnitNoOri IS NULL OR @PollingUnitNoOri <= 0) AND
			(@CandidateNoOri IS NULL OR @CandidateNoOri <= 0))
		BEGIN
			-- NO PREVIOUS DATA (SAME PERSON)
			IF (EXISTS (
				SELECT * 
				  FROM MPDC
				 WHERE ThaiYear = @ThaiYear
                   AND LTRIM(RTRIM(ADM1Code)) = LTRIM(RTRIM(@ADM1Code))
				   AND PollingUnitNo = @PollingUnitNo
				   AND PersonId = @PersonId
				))
			BEGIN
				-- CANDIDATE EXIST SO FIRST DELETE SAME PROVINCE + POLLING UNIT
				DELETE FROM MPDC 
				 WHERE ThaiYear = @ThaiYear
                   AND ADM1Code = @ADM1Code
				   AND PollingUnitNo = @PollingUnitNo
				   AND PersonId = @PersonId
			END

			IF (@CandidateNo = 0) SET @CandidateNo = 1

			IF (EXISTS(
				SELECT CandidateNo 
				  FROM MPDC
				 WHERE ThaiYear = @ThaiYear
				   AND ADM1Code = @ADM1Code
				   AND PollingUnitNo = @PollingUnitNo
				   AND CandidateNo = @CandidateNo
			   ))
			BEGIN
				-- SLOT IN USED REORDER ALL IN SAME PROVINCE + POLLING UNIT AND MAKE EMPTY SLOT
				UPDATE MPDC
				   SET CandidateNo = CandidateNo + 1
				 WHERE ThaiYear = @ThaiYear
				   AND ADM1Code = @ADM1Code
				   AND PollingUnitNo = @PollingUnitNo
				   AND CandidateNo >= @CandidateNo
			END

			-- INSERT PERSON ON PROVINCE + POLLING UNIT
			INSERT INTO MPDC
			(
				  ThaiYear
                , ADM1Code
				, PollingUnitNo
				, CandidateNo 
				, PersonId
				, PrevPartyId
				, SubGroup
				, [Remark]
				, EducationId
			)
			VALUES
			(
				  @ThaiYear
				, @ADM1Code
				, @PollingUnitNo
				, @CandidateNo
				, @PersonId
				, @PrevPartyId
				, @SubGroup
				, @Remark
				, @EducationId
			);
		END
		ELSE
		BEGIN
			-- HAS PREVIOUS DATA
			IF ((@ADM1CodeOri IS NOT NULL) AND
			    (@PollingUnitNoOri IS NOT NULL AND @PollingUnitNoOri >= 1) AND 
			    (@CandidateNoOri IS NOT NULL AND @CandidateNoOri >= 1) AND 
			    (@PersonId IS NOT NULL))
			BEGIN
				-- CANDIDATE ORDER CHANGE SO DELETE PREVIOUS
				DELETE FROM MPDC 
				 WHERE ThaiYear = @ThaiYear
                   AND ADM1Code = @ADM1CodeOri
				   AND PollingUnitNo = @PollingUnitNoOri
				   AND CandidateNo = @CandidateNoOri
				   AND PersonId = @PersonId

				-- REORDER PREVIOUS PROVINCE + POLLING UNIT
				UPDATE MPDC
				   SET CandidateNo = CandidateNo - 1
				 WHERE ThaiYear = @ThaiYear
				   AND ADM1Code = @ADM1CodeOri
				   AND PollingUnitNo = @PollingUnitNoOri
				   AND CandidateNo >= @CandidateNoOri

				-- FIND MAX CandidateNo THAT NEED TO REARRANGE ORDER
				SELECT @iMaxCandidateNo = MIN(CandidateNo)
				  FROM MPDC
				 WHERE ThaiYear = @ThaiYear
				   AND ADM1Code = @ADM1CodeOri
				   AND PollingUnitNo = @PollingUnitNoOri
				   AND CandidateNo > @CandidateNoOri

				-- REORDER NEW PROVINCE + POLLING UNIT TO MAKE EMPTY SLOT
				UPDATE MPDC
				   SET CandidateNo = CandidateNo + 1
				 WHERE ThaiYear = @ThaiYear
				   AND ADM1Code = @ADM1Code
				   AND PollingUnitNo = @PollingUnitNo
				   AND CandidateNo >= @CandidateNo
				   AND CandidateNo < @iMaxCandidateNo

				-- INSERT DATA TO NEW PROVINCE + POLLING UNIT
				INSERT INTO MPDC
				(
					  ThaiYear
                    , ADM1Code
					, PollingUnitNo
					, CandidateNo 
					, PersonId
					, PrevPartyId
					, SubGroup
					, [Remark]
					, EducationId
				)
				VALUES
				(
					  @ThaiYear
					, @ADM1Code
					, @PollingUnitNo
					, @CandidateNo
					, @PersonId
					, @PrevPartyId
					, @SubGroup
					, @Remark
					, @EducationId
				);
			END
			ELSE
			BEGIN
				-- MISSING REQUIRED DATA
				PRINT 'MISSING REQUIRED DATA'
				--SET @errNum = 200;
				--SET @errMsg = 'Some previous parameter(s) is null.';
				--RETURN
			END
		END

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDVoteSummaries]    Script Date: 12/2/2022 5:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDVoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
-- <2022-10-09> :
--	- Add PartyNamne parameter.
--	- Add FullNamne parameter.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDVoteSummaries]
(
  @ThaiYear int
, @RegionId nvarchar(20) = NULL
, @RegionName nvarchar(200) = NULL
, @ProvinceNameTH nvarchar(20) = NULL
, @PartyName nvarchar(200) = NULL
, @FullName nvarchar(MAX) = NULL
)
AS
BEGIN
    ;WITH MPDVoteSum
    AS
    -- Define the Vote Summary by Province and PollingUnit query.
    (
        SELECT RowNo
		     , RankNo
			 , ThaiYear
			 , ADM1Code 
			 , PollingUnitNo
			 , CandidateNo
			 , RevoteNo
			 , VoteCount
			 , PartyId
			 , PartyName
			 --, PartyImageData
			 , PersonId
			 , Prefix
			 , FirstName
			 , LastName
			 , FullName
			 --, PersonImageData
			 , DOB
			 , GenderId
			 , EducationId
			 , OccupationId
			 , PersonRemark
			 , ProvinceId 
			 , ProvinceNameTH
			 , ProvinceNameEN 
			 , RegionId
			 , RegionName
			 , GeoGroup
			 , GeoSubgroup
          FROM MPDVoteSummaryView
         WHERE ThaiYear = @ThaiYear
		   AND UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
		   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
		   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
		   AND UPPER(LTRIM(RTRIM(PartyName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@PartyName, PartyName)))) + '%'
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
    )
    SELECT * 
      FROM MPDVoteSum 
     ORDER BY ProvinceNameTH, PollingUnitNo, VoteCount DESC

END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDStatVoters]    Script Date: 12/4/2022 7:46:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDStatVoters
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDStatVoters]
(
  @ThaiYear int
, @ProvinceNameTH nvarchar(100) = NULL
)
AS
BEGIN
	SELECT ThaiYear
         , ADM1Code
         , ProvinceId
         , ProvinceNameTH
         , ProvinceNameEN
         , RegionId
         , RegionName
         , GeoGroup
         , GeoSubgroup
	     , PollingUnitNo
         , RightCount
         , ExerciseCount
         , InvalidCount
         , NoVoteCount
		 , FullName
		 , PartyName
		 , VoteCount
		 , PollingUnitCount
      FROM MPDStatVoterView
     WHERE @ThaiYear = COALESCE(@ThaiYear, ThaiYear)
       AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
     ORDER BY ProvinceNameTH, PollingUnitNo
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDStatVoterSummaries]    Script Date: 12/4/2022 7:46:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDStatVoterSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDStatVoterSummaries]
(
  @ThaiYear int
, @ProvinceNameTH nvarchar(100) = NULL
)
AS
BEGIN
	SELECT ThaiYear
         , ADM1Code
         , ProvinceId
         , ProvinceNameTH
         , ProvinceNameEN
         , RegionId
         , RegionName
         , GeoGroup
         , GeoSubgroup
	     , PollingUnitNo
         , RightCount
         , ExerciseCount
         , InvalidCount
         , NoVoteCount
		 , FullName
		 , PartyName
		 , VoteCount
		 , PollingUnitCount
      FROM MPDStatVoterSummaryView
     WHERE @ThaiYear = COALESCE(@ThaiYear, ThaiYear)
       AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
     ORDER BY ProvinceNameTH, PollingUnitNo
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetRegionMenuItems]    Script Date: 11/30/2022 2:13:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetRegionMenuItems
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetRegionMenuItems]
AS
BEGIN
    SELECT RegionId, RegionName
      FROM MRegion 
     ORDER BY RegionId
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetProvinceMenuItems]    Script Date: 11/30/2022 2:13:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetProvinceMenuItems
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetProvinceMenuItems]
(
  @RegionId nvarchar(10)
)
AS
BEGIN
    ;WITH PU_2562
    AS
    (
        SELECT RegionId, ADM1Code, ProvinceNameTH
             , COUNT(PollingUnitNo) AS UnitCount
         FROM PollingUnitView
        WHERE RegionId IS NOT NULL
          AND RegionId = @RegionId
          AND ThaiYear = 2562
        GROUP BY RegionId, ADM1Code, ProvinceNameTH
        --ORDER BY RegionId, ProvinceNameTH
    ), PU_2566
    AS
    (
        SELECT RegionId, ADM1Code, ProvinceNameTH
             , COUNT(PollingUnitNo) AS UnitCount
         FROM PollingUnitView
        WHERE RegionId IS NOT NULL
          AND RegionId = @RegionId
          AND ThaiYear = 2566
        GROUP BY RegionId, ADM1Code, ProvinceNameTH
        --ORDER BY RegionId, ProvinceNameTH
    ), PU
    AS
    (
        SELECT * FROM PU_2562
        UNION
        (
            SELECT * FROM PU_2566 
            EXCEPT
            SELECT * FROM PU_2562
        )
        
    )
    SELECT RegionId, ADM1Code, ProvinceNameTH
         , MIN(UnitCount) AS MinUnitCount
         , MAX(UnitCount) AS MaxUnitCount
     FROM PU
    GROUP BY RegionId, ADM1Code, ProvinceNameTH
    ORDER BY RegionId, ProvinceNameTH
END

GO


/*********** Script Update Date: 2022-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[GetPollingUnitMenuItems]    Script Date: 11/30/2022 2:13:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPollingUnitMenuItems
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
/*
CREATE PROCEDURE [dbo].[GetPollingUnitMenuItems]
(
  @RegionId nvarchar(10)
, @ProvinceId nvarchar(10)
)
AS
BEGIN
    SELECT *
      FROM MPDPollingUnitSummary
     WHERE RegionId = @RegionId
       AND ProvinceId = @ProvinceId
END

GO
*/

/*********** Script Update Date: 2022-11-20  ***********/
-- CREATE DEFAULT USER ROLES
INSERT INTO UserRole(RoleId, RoleName) VALUES(1, N'Admistrator');
INSERT INTO UserRole(RoleId, RoleName) VALUES(10, N'Supervisor');
INSERT INTO UserRole(RoleId, RoleName) VALUES(20, N'User');
GO

-- CREATE DEFAULT USERS
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(1, N'Administrator', N'admin', N'admin');

INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(10, N'Supervisor 1', N'sup1', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(10, N'Supervisor 2', N'sup2', N'123');

INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 1', N'user1', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 2', N'user2', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 3', N'user3', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 4', N'user4', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 5', N'user5', N'123');
GO


/*********** Script Update Date: 2022-11-20  ***********/
INSERT INTO MTitle ([Description], GenderId) VALUES
	 (N'ก.ญ.', 1), 
	 (N'ก.ต.', 1), 
	 (N'ก.ท.', 1), 
	 (N'ก.อ.', 1), 
	 (N'คุณ', 0), 
	 (N'คุณพระ', 1), 
	 (N'คุณหญิง', 2), 
	 (N'จ.ต.', 1), 
	 (N'จ.ท.', 1), 
	 (N'จ.ส.ต.', 1), 
	 (N'จ.ส.ต. ม.ร.ว.', 1), 
	 (N'จ.ส.ต. หญิง', 2), 
	 (N'จ.ส.ต.ม.ร.ว.', 1), 
	 (N'จ.ส.ต.ม.ล.', 1), 
	 (N'จ.ส.ต.หญิง', 2), 
	 (N'จ.ส.ต.หม่อมราชวงศ์', 1), 
	 (N'จ.ส.ท.', 1), 
	 (N'จ.ส.ท. ม.ร.ว.', 1), 
	 (N'จ.ส.ท.ม.ร.ว.', 1), 
	 (N'จ.ส.ท.หม่อมราชวงศ์', 1), 
	 (N'จ.ส.อ.', 1), 
	 (N'จ.ส.อ. (พิเศษ)', 1), 
	 (N'จ.ส.อ. ม.ร.ว.', 1), 
	 (N'จ.ส.อ.(พิเศษ)', 1), 
	 (N'จ.ส.อ.พิเศษ', 1), 
	 (N'จ.ส.อ.ม.ร.ว.', 1), 
	 (N'จ.ส.อ.ม.ล.', 1), 
	 (N'จ.ส.อ.หม่อมราชวงศ์', 1), 
	 (N'จ.อ.', 1), 
	 (N'จอมพล', 1), 
	 (N'จ่าตรี', 1), 
	 (N'จ่าโท', 1), 
	 (N'จ่าสำรอง', 1), 
	 (N'จ่าสิบตรี', 1), 
	 (N'จ่าสิบตรี ม.ร.ว.', 1), 
	 (N'จ่าสิบตรี หม่อมราชวงศ์', 1), 
	 (N'จ่าสิบตรีหม่อมราชวงศ์', 1), 
	 (N'จ่าสิบตรีหม่อมหลวง', 1), 
	 (N'จ่าสิบตำรวจ', 1), 
	 (N'จ่าสิบตำรวจ หญิง', 2), 
	 (N'จ่าสิบตำรวจหญิง', 2), 
	 (N'จ่าสิบโท', 1), 
	 (N'จ่าสิบโท ม.ร.ว.', 1), 
	 (N'จ่าสิบโท หม่อมราชวงศ์', 1), 
	 (N'จ่าสิบโทหม่อมราชวงศ์', 1), 
	 (N'จ่าสิบเอก', 1), 
	 (N'จ่าสิบเอก (พิเศษ)', 1), 
	 (N'จ่าสิบเอก ม.ร.ว.', 1), 
	 (N'จ่าสิบเอก หม่อมราชวงศ์', 1), 
	 (N'จ่าสิบเอก(พิเศษ)', 1), 
	 (N'จ่าสิบเอก.(พิเศษ)', 1), 
	 (N'จ่าสิบเอก.พิเศษ', 1), 
	 (N'จ่าสิบเอกพิเศษ', 1), 
	 (N'จ่าสิบเอกหม่อมราชวงศ์', 1), 
	 (N'จ่าสิบเอกหม่อมหลวง', 1), 
	 (N'จ่าอากาศตรี', 1), 
	 (N'จ่าอากาศโท', 1), 
	 (N'จ่าอากาศเอก', 1), 
	 (N'จ่าเอก', 1), 
	 (N'เจ้า', 1), 
	 (N'เจ้าคุณ', 1), 
	 (N'เจ้าชาย', 1), 
	 (N'เจ้านาง', 2), 
	 (N'เจ้าฟ้า', 1), 
	 (N'เจ้าหญิง', 2), 
	 (N'เจ้าอธิการ', 1), 
	 (N'ซิสเตอร์', 2), 
	 (N'ด.ช.', 1), 
	 (N'ด.ญ.', 2), 
	 (N'ด.ต.', 1), 
	 (N'ด.ต. หญิง', 2), 
	 (N'ด.ต.ม.ล.', 1), 
	 (N'ด.ต.หญิง', 2), 
	 (N'ดร.', 1), 
	 (N'ดอกเตอร์', 1), 
	 (N'ดาบตำรวจ หญิง', 2), 
	 (N'ดาบตำรวจหญิง', 2), 
	 (N'เด็กชาย', 1), 
	 (N'เด็กหญิง', 2), 
	 (N'ท.ญ.', 2), 
	 (N'ท.พ.', 1), 
	 (N'ทัณตแพทย์', 1), 
	 (N'ทัณตแพทย์ หญิง', 2), 
	 (N'ทัณตแพทย์หญิง', 2), 
	 (N'ท่านผู้หญิง', 2), 
	 (N'ท่านผู้หญิง ม.ร.ว.', 2), 
	 (N'ท่านผู้หญิง ม.ล.', 2), 
	 (N'ท่านผู้หญิง หม่อมราชวงศ์', 2), 
	 (N'ท่านผู้หญิงม.ร.ว.', 2), 
	 (N'ท่านผู้หญิงหม่อมราชวงศ์', 2), 
	 (N'ท่านผู้หญิงหม่อมหลวง', 2), 
	 (N'ท้าว', 1), 
	 (N'ทูลกระหม่อม', 1), 
	 (N'น.ช.', 1), 
	 (N'น.ช. จ.ส.อ.', 2), 
	 (N'น.ช. จ.อ.', 1), 
	 (N'น.ช. จ่าสิบเอก', 2), 
	 (N'น.ช. จ่าเอก', 1), 
	 (N'น.ช. พลทหาร', 1), 
	 (N'น.ช. พลฯ', 1), 
	 (N'น.ช. ม.ล.', 1), 
	 (N'น.ช. ร.ต.', 1), 
	 (N'น.ช. ร้อยตรี', 1), 
	 (N'น.ช. หม่อมหลวง', 1), 
	 (N'น.ช.จ.ส.อ.', 2), 
	 (N'น.ช.จ.อ.', 1), 
	 (N'น.ช.จ่าสิบเอก', 2), 
	 (N'น.ช.จ่าเอก', 1), 
	 (N'น.ช.พลฯ.', 1), 
	 (N'น.ช.ม.ล.', 1), 
	 (N'น.ช.ร.ต.', 1), 
	 (N'น.ญ.', 2), 
	 (N'น.ต.', 1), 
	 (N'น.ต. น.พ.', 1), 
	 (N'น.ต. นายแพทย์', 1), 
	 (N'น.ต. พ.ญ.', 2), 
	 (N'น.ต. แพทย์หญิง', 2), 
	 (N'น.ต. ม.ร.ว.', 1), 
	 (N'น.ต.น.พ.', 1), 
	 (N'น.ต.พ.ญ.', 2), 
	 (N'น.ต.ม.จ.', 1), 
	 (N'น.ต.ม.ร.ว.', 1), 
	 (N'น.ต.ม.ล.', 1), 
	 (N'น.ต.หม่อมราชวงศ์', 1), 
	 (N'น.ท.', 1), 
	 (N'น.ท. น.พ.', 1), 
	 (N'น.ท. นายแพทย์', 1), 
	 (N'น.ท. พ.ญ.', 2), 
	 (N'น.ท. แพทย์หญิง', 2), 
	 (N'น.ท. ม.ร.ว.', 1), 
	 (N'น.ท.น.พ.', 1), 
	 (N'น.ท.พ.ญ.', 2), 
	 (N'น.ท.ม.จ.', 1), 
	 (N'น.ท.ม.ร.ว.', 1), 
	 (N'น.ท.ม.ล.', 1), 
	 (N'น.ท.หม่อมราชวงศ์', 1), 
	 (N'น.พ.', 1), 
	 (N'น.พ.อ.', 1), 
	 (N'น.ร. จ.อ.', 1), 
	 (N'น.ร. จอ', 1), 
	 (N'น.ร. จ่าอากาศ', 1), 
	 (N'น.ร. น.อ.', 1), 
	 (N'น.ร. นอ.', 1), 
	 (N'น.ร. นายเรืออากาศ', 1), 
	 (N'น.ร.จ.อ', 1), 
	 (N'น.ร.จอ', 1), 
	 (N'น.ร.จ่าอากาศ', 1), 
	 (N'น.ร.น.อ.', 1), 
	 (N'น.ร.นอ.', 1), 
	 (N'น.ร.นายเรืออากาศ', 1), 
	 (N'น.ส.', 2), 
	 (N'น.อ.', 1), 
	 (N'น.อ. (พิเศษ)', 1), 
	 (N'น.อ. น.พ.', 1), 
	 (N'น.อ. นายแพทย์', 1), 
	 (N'น.อ. พ.ญ.', 2), 
	 (N'น.อ. แพทย์หญิง', 2), 
	 (N'น.อ. ม.ร.ว.', 1), 
	 (N'น.อ.(พิเศษ)', 1), 
	 (N'น.อ.น.พ.', 1), 
	 (N'น.อ.พ.ญ.', 2), 
	 (N'น.อ.พิเศษ', 1), 
	 (N'น.อ.ม.จ.', 1), 
	 (N'น.อ.ม.ร.ว.', 1), 
	 (N'น.อ.ม.ล.', 1), 
	 (N'น.อ.หม่อมราชวงศ์', 1), 
	 (N'น.อ.หลวง', 1), 
	 (N'นจอ.', 1), 
	 (N'นนร.', 1), 
	 (N'นนร.ม.ล.', 1), 
	 (N'นนส.', 1), 
	 (N'นนอ.', 1), 
	 (N'นพต.', 1), 
	 (N'นรจ.', 1), 
	 (N'นรต.', 1), 
	 (N'นรต.ม.จ.', 1), 
	 (N'นรต.ม.ล.', 1), 
	 (N'นสต.', 1), 
	 (N'นักโทษ ชาย', 1), 
	 (N'นักโทษ ชาย จ.อ.', 1), 
	 (N'นักโทษ ชาย จ่าเอก', 1), 
	 (N'นักโทษ ชาย พลทหาร', 1), 
	 (N'นักโทษ ชาย พลฯ', 1), 
	 (N'นักโทษ ชาย ร.ต.', 1), 
	 (N'นักโทษ หญิง', 2), 
	 (N'นักโทษชาย', 1), 
	 (N'นักโทษชาย จ.ส.อ.', 2), 
	 (N'นักโทษชาย จ.อ.', 1), 
	 (N'นักโทษชาย จ่าสิบเอก', 2), 
	 (N'นักโทษชาย จ่าเอก', 1), 
	 (N'นักโทษชาย พลทหาร', 1), 
	 (N'นักโทษชาย พลฯ', 1), 
	 (N'นักโทษชาย ร.ต.', 1), 
	 (N'นักโทษชาย หม่อมหลวง', 1), 
	 (N'นักโทษชายจ่าสิบเอก', 2), 
	 (N'นักโทษชายจ่าเอก', 1), 
	 (N'นักโทษชายพลทหาร', 1), 
	 (N'นักโทษชายร้อยตรี', 1), 
	 (N'นักโทษชายหม่อมหลวง', 1), 
	 (N'นักโทษหญิง', 2), 
	 (N'นักบวช', 1), 
	 (N'นักเรียนจ่าทหารเรือ', 1), 
	 (N'นักเรียนจ่าอากาศ', 1), 
	 (N'นักเรียนนายร้อย', 1), 
	 (N'นักเรียนนายร้อยตำรวจ', 1), 
	 (N'นักเรียนนายร้อยตำรวจหม่อมเจ้า', 1), 
	 (N'นักเรียนนายร้อยตำรวจหม่อมหลวง', 1), 
	 (N'นักเรียนนายร้อยหม่อมหลวง', 1), 
	 (N'นักเรียนนายเรือ', 1), 
	 (N'นักเรียนนายเรืออากาศ', 1), 
	 (N'นักเรียนนายสิบ', 1), 
	 (N'นักเรียนนายสิบตำรวจ', 1), 
	 (N'นักเรียนพยาบาล ท.อ.', 1), 
	 (N'นักเรียนพยาบาลทหารอากาศ', 1), 
	 (N'นักเรียนพลตำรวจ', 1), 
	 (N'นาง', 2), 
	 (N'นางสาว', 2), 
	 (N'นาย', 1), 
	 (N'นายกองตรี', 1), 
	 (N'นายกองโท', 1), 
	 (N'นายกองใหญ่', 1), 
	 (N'นายกองเอก', 1), 
	 (N'นายดาบตำรวจ', 1), 
	 (N'นายดาบตำรวจหม่อมหลวง', 1), 
	 (N'นายแพทย์', 1), 
	 (N'นายหมวดตรี', 1), 
	 (N'นายหมวดโท', 1), 
	 (N'นายหมวดเอก', 1), 
	 (N'นายหมู่ตรี', 1), 
	 (N'นายหมู่โท', 1), 
	 (N'นายหมู่ใหญ่', 1), 
	 (N'นายหมู่เอก', 1), 
	 (N'นาวาตรี', 1), 
	 (N'นาวาตรี น.พ.', 1), 
	 (N'นาวาตรี นายแพทย์', 1), 
	 (N'นาวาตรี พ.ญ.', 2), 
	 (N'นาวาตรี แพทย์หญิง', 2), 
	 (N'นาวาตรี ม.ร.ว.', 1), 
	 (N'นาวาตรี หม่อมราชวงศ์', 1), 
	 (N'นาวาตรีนายแพทย์', 1), 
	 (N'นาวาตรีแพทย์หญิง', 2), 
	 (N'นาวาตรีหม่อมเจ้า', 1), 
	 (N'นาวาตรีหม่อมราชวงศ์', 1), 
	 (N'นาวาตรีหม่อมหลวง', 1), 
	 (N'นาวาโท', 1), 
	 (N'นาวาโท น.พ.', 1), 
	 (N'นาวาโท นายแพทย์', 1), 
	 (N'นาวาโท พ.ญ.', 2), 
	 (N'นาวาโท แพทย์หญิง', 2), 
	 (N'นาวาโท ม.ร.ว.', 1), 
	 (N'นาวาโท หม่อมราชวงศ์', 1), 
	 (N'นาวาโทนายแพทย์', 1), 
	 (N'นาวาโทแพทย์หญิง', 2), 
	 (N'นาวาโทหม่อมเจ้า', 1), 
	 (N'นาวาโทหม่อมราชวงศ์', 1), 
	 (N'นาวาโทหม่อมหลวง', 1), 
	 (N'นาวาอากาศตรี', 1), 
	 (N'นาวาอากาศโท', 1), 
	 (N'นาวาอากาศเอก', 1), 
	 (N'นาวาอากาศเอก (พิเศษ)', 1), 
	 (N'นาวาอากาศเอก(พิเศษ)', 1), 
	 (N'นาวาอากาศเอกพิเศษ', 1), 
	 (N'นาวาอากาศเอกหม่อมหลวง', 1), 
	 (N'นาวาอากาศเอกหลวง', 1), 
	 (N'นาวาเอก', 1), 
	 (N'นาวาเอก (พิเศษ)', 1), 
	 (N'นาวาเอก น.พ.', 1), 
	 (N'นาวาเอก นายแพทย์', 1), 
	 (N'นาวาเอก พ.ญ.', 2), 
	 (N'นาวาเอก แพทย์หญิง', 2), 
	 (N'นาวาเอก ม.ร.ว.', 1), 
	 (N'นาวาเอก หม่อมราชวงศ์', 1), 
	 (N'นาวาเอก(พิเศษ)', 1), 
	 (N'นาวาเอก.(พิเศษ)', 1), 
	 (N'นาวาเอกนายแพทย์', 1), 
	 (N'นาวาเอกพิเศษ', 1), 
	 (N'นาวาเอกแพทย์หญิง', 2), 
	 (N'นาวาเอกหม่อมเจ้า', 1), 
	 (N'นาวาเอกหม่อมราชวงศ์', 1), 
	 (N'บาทหลวง', 1), 
	 (N'ผศ.', 1), 
	 (N'ผู้ช่วยศาสตราจารย์', 1), 
	 (N'พ.จ.ต.', 1), 
	 (N'พ.จ.ท.', 1), 
	 (N'พ.จ.อ.', 1), 
	 (N'พ.จ.อ.ม.ล.', 1), 
	 (N'พ.ญ.', 2), 
	 (N'พ.ญ. คุณหญิง', 2), 
	 (N'พ.ญ.คุณหญิง', 2), 
	 (N'พ.ต.', 1), 
	 (N'พ.ต. คุณหญิง', 2), 
	 (N'พ.ต. น.พ.', 1), 
	 (N'พ.ต. ม.จ.', 1), 
	 (N'พ.ต. ม.ร.ว.', 1), 
	 (N'พ.ต. หม่อมเจ้า', 1), 
	 (N'พ.ต.คุณหญิง', 2), 
	 (N'พ.ต.ต.', 1), 
	 (N'พ.ต.ต. ดร.', 1), 
	 (N'พ.ต.ต. ดอกเตอร์', 1), 
	 (N'พ.ต.ต. นพ.', 1), 
	 (N'พ.ต.ต. ม.ร.ว.', 1), 
	 (N'พ.ต.ต. หญิง', 2), 
	 (N'พ.ต.ต.ดร.', 1), 
	 (N'พ.ต.ต.ดอกเตอร์', 1), 
	 (N'พ.ต.ต.นพ.', 1), 
	 (N'พ.ต.ต.นายแพทย์', 1), 
	 (N'พ.ต.ต.ม.ร.ว.', 1), 
	 (N'พ.ต.ต.ม.ล.', 1), 
	 (N'พ.ต.ต.หญิง', 2), 
	 (N'พ.ต.ต.หญิง ท่านผู้หญิง', 2), 
	 (N'พ.ต.ต.หม่อมราชวงศ์', 1), 
	 (N'พ.ต.ต.หลวง', 1), 
	 (N'พ.ต.ท.', 1), 
	 (N'พ.ต.ท. ดร.', 1), 
	 (N'พ.ต.ท. ดอกเตอร์', 1), 
	 (N'พ.ต.ท. นพ.', 1), 
	 (N'พ.ต.ท. ม.ร.ว.', 1), 
	 (N'พ.ต.ท. หญิง', 2), 
	 (N'พ.ต.ท.ดร.', 1), 
	 (N'พ.ต.ท.ดอกเตอร์', 1), 
	 (N'พ.ต.ท.น.พ.', 1), 
	 (N'พ.ต.ท.นายแพทย์', 1), 
	 (N'พ.ต.ท.ม.จ.', 1), 
	 (N'พ.ต.ท.ม.ร.ว.', 1), 
	 (N'พ.ต.ท.ม.ล.', 1), 
	 (N'พ.ต.ท.หญิง', 2), 
	 (N'พ.ต.ท.หญิง ท่านผู้หญิง', 2), 
	 (N'พ.ต.ท.หม่อมราชวงศ์', 1), 
	 (N'พ.ต.น.พ.', 1), 
	 (N'พ.ต.นายแพทย์', 1), 
	 (N'พ.ต.พระเจ้าวรวงศ์เธอพระองค์', 1), 
	 (N'พ.ต.พระเจ้าวรวงศ์เธอพระองค์เจ้า', 1), 
	 (N'พ.ต.ม.จ.', 1), 
	 (N'พ.ต.ม.ร.ว.', 1), 
	 (N'พ.ต.ม.ล.', 1), 
	 (N'พ.ต.หม่อมเจ้า', 1), 
	 (N'พ.ต.หม่อมราชวงศ์', 1), 
	 (N'พ.ต.หลวง', 1), 
	 (N'พ.ต.อ.', 1), 
	 (N'พ.ต.อ. (พิเศษ)', 1), 
	 (N'พ.ต.อ. ดร.', 1), 
	 (N'พ.ต.อ. ดอกเตอร์', 1), 
	 (N'พ.ต.อ. นพ.', 1), 
	 (N'พ.ต.อ. ม.ร.ว.', 1), 
	 (N'พ.ต.อ. หญิง', 2), 
	 (N'พ.ต.อ.ดร.', 1), 
	 (N'พ.ต.อ.ดอกเตอร์', 1), 
	 (N'พ.ต.อ.น.พ.', 1), 
	 (N'พ.ต.อ.นายแพทย์', 1), 
	 (N'พ.ต.อ.ม.จ.', 1), 
	 (N'พ.ต.อ.ม.ร.ว.', 1), 
	 (N'พ.ต.อ.ม.ล.', 1), 
	 (N'พ.ต.อ.หญิง', 2), 
	 (N'พ.ต.อ.หญิง ท่านผู้หญิง', 2), 
	 (N'พ.ต.อ.หม่อมราชวงศ์', 1), 
	 (N'พ.ท.', 1), 
	 (N'พ.ท. คุณหญิง', 2), 
	 (N'พ.ท. น.พ.', 1), 
	 (N'พ.ท. ม.จ.', 1), 
	 (N'พ.ท. ม.ร.ว.', 1), 
	 (N'พ.ท. หม่อมเจ้า', 1), 
	 (N'พ.ท.คุณหญิง', 2), 
	 (N'พ.ท.น.พ.', 1), 
	 (N'พ.ท.นายแพทย์', 1), 
	 (N'พ.ท.ม.จ.', 1), 
	 (N'พ.ท.ม.ร.ว.', 1), 
	 (N'พ.ท.ม.ล.', 1), 
	 (N'พ.ท.หม่อมเจ้า', 1), 
	 (N'พ.ท.หม่อมราชวงศ์', 1), 
	 (N'พ.ท.หลวง', 1), 
	 (N'พ.อ.', 1), 
	 (N'พ.อ. (พิเศษ) ม.ร.ว.', 1), 
	 (N'พ.อ. (พิเศษ) หม่อมราชวงศ์', 1), 
	 (N'พ.อ. (พิเศษ)ม.ร.ว.', 1), 
	 (N'พ.อ. (พิเศษ)หม่อมราชวงศ์', 1), 
	 (N'พ.อ. น.พ.', 1), 
	 (N'พ.อ. ม.จ.', 1), 
	 (N'พ.อ. ม.ร.ว.', 1), 
	 (N'พ.อ. หม่อมเจ้า', 1), 
	 (N'พ.อ.(พิเศษ)', 1), 
	 (N'พ.อ.(พิเศษ) ม.ร.ว.', 1), 
	 (N'พ.อ.(พิเศษ) หม่อมราชวงศ์', 1), 
	 (N'พ.อ.(พิเศษ)ม.ร.ว.', 1), 
	 (N'พ.อ.ต.', 1), 
	 (N'พ.อ.ต. ม.ร.ว.', 1), 
	 (N'พ.อ.ต.ม.ร.ว.', 1), 
	 (N'พ.อ.ต.หม่อมราชวงศ์', 1), 
	 (N'พ.อ.ท.', 1), 
	 (N'พ.อ.ท. ม.ร.ว.', 1), 
	 (N'พ.อ.ท.ม.ร.ว.', 1), 
	 (N'พ.อ.ท.หม่อมราชวงศ์', 1), 
	 (N'พ.อ.น.พ.', 1), 
	 (N'พ.อ.นายแพทย์', 1), 
	 (N'พ.อ.ม.จ.', 1), 
	 (N'พ.อ.ม.ร.ว.', 1), 
	 (N'พ.อ.ม.ล.', 1), 
	 (N'พ.อ.หญิง คุณหญิง', 2), 
	 (N'พ.อ.หญิงคุณหญิง', 2), 
	 (N'พ.อ.หม่อมเจ้า', 1), 
	 (N'พ.อ.หม่อมราชวงศ์', 1), 
	 (N'พ.อ.อ.', 1), 
	 (N'พ.อ.อ. ม.ร.ว.', 1), 
	 (N'พ.อ.อ.ม.ร.ว.', 1), 
	 (N'พ.อ.อ.ม.ล.', 1), 
	 (N'พ.อ.อ.หม่อมราชวงศ์', 1), 
	 (N'พระ', 1), 
	 (N'พระครู', 1), 
	 (N'พระครูกาญจนยติกิจ', 1), 
	 (N'พระครูกิตติกาญจนวงศ์', 1), 
	 (N'พระครูเกษมธรรมานันท์', 1), 
	 (N'พระครูโกวิทธรรมโสภณ', 1), 
	 (N'พระครูจันทเขมคุณ', 1), 
	 (N'พระครูจารุธรรมกิตติ์', 1), 
	 (N'พระครูถาวรสันติคุณ', 1), 
	 (N'พระครูธรรมธร', 1), 
	 (N'พระครูนิเทศปิยธรรม', 1), 
	 (N'พระครูบรรณวัตร', 1), 
	 (N'พระครูบวรรัตนวงศ์', 1), 
	 (N'พระครูใบฎีกา', 1), 
	 (N'พระครูปภัสสราธิคุณ', 1), 
	 (N'พระครูประกาศพุทธพากย์', 1), 
	 (N'พระครูประโชติธรรมรัตน์', 1), 
	 (N'พระครูประโชติธรรมานุกูล', 1), 
	 (N'พระครูปลัด', 1), 
	 (N'พระครูปลัดวิมลสิริวัฒน์', 1), 
	 (N'พระครูปลัดสัมพิพัฒนวิริยาจารย์', 1), 
	 (N'พระครูปลัดสุวัฒนญาณคุณ', 1), 
	 (N'พระครูปลัดอาจารย์วัฒน์', 1), 
	 (N'พระครูปัญญาภรณโสภณ', 1), 
	 (N'พระครูปิยสีลสาร', 1), 
	 (N'พระครูผาสุกวิหารการ', 1), 
	 (N'พระครูพรหมวีรสุนทร', 1), 
	 (N'พระครูพัฒนสารคุณ', 1), 
	 (N'พระครูพิทักษ์พรหมรังษี', 1), 
	 (N'พระครูพิบูลโชติธรรม', 1), 
	 (N'พระครูพิบูลสมณธรรม', 1), 
	 (N'พระครูพิพัฒน์ชินวงศ์', 1), 
	 (N'พระครูพิพัฒน์บรรณกิจ', 1), 
	 (N'พระครูพิพิธวรคุณ', 1), 
	 (N'พระครูพิพิธอุดมคุณ', 1), 
	 (N'พระครูพิศิษฎ์ศาสนการ', 1), 
	 (N'พระครูพุทธิธรรมานุศาสน์', 1), 
	 (N'พระครูไพบูลชัยสิทธิ์', 1), 
	 (N'พระครูไพโรจน์อริญชัย', 1), 
	 (N'พระครูไพศาลศุภกิจ', 1), 
	 (N'พระครูภาวนาวรกิจ', 1), 
	 (N'พระครูเมธีธรรมานุยุต', 1), 
	 (N'พระครูวชิรวุฒิกร', 1), 
	 (N'พระครูวรสังฆกิจ', 1), 
	 (N'พระครูวัชรสีลาภรณ์', 1), 
	 (N'พระครูวิจารณ์สังฆกิจ', 1), 
	 (N'พระครูวิชิตพัฒนคุณ', 1), 
	 (N'พระครูวินัยธร', 1), 
	 (N'พระครูวิบูลกาญจนกิจ', 1), 
	 (N'พระครูวิบูลธรรมกิจ', 1), 
	 (N'พระครูวิบูลย์ธรรมศาสก์', 1), 
	 (N'พระครูวิมลญาณโสภณ', 1), 
	 (N'พระครูวิมลภาณ', 1), 
	 (N'พระครูวิมลสารวิสุทธิ์', 1), 
	 (N'พระครูวิมลสิริวัฒน์', 1), 
	 (N'พระครูวิศาลปัญญาคุณ', 1), 
	 (N'พระครูวิสุทธาจาร', 1), 
	 (N'พระครูวิสุทธาจารวิมล', 1), 
	 (N'พระครูวิสุทธิ์กิจจานุกูล', 1), 
	 (N'พระครูศรัทธาธรรมโสภณ', 1), 
	 (N'พระครูศรีธวัชคุณาภรณ์', 1), 
	 (N'พระครูศรีศาสนคุณ', 1), 
	 (N'พระครูศัพทมงคล', 1), 
	 (N'พระครูศีลกันตาภรณ์', 1), 
	 (N'พระครูศีลสารวิสุทธิ์', 1), 
	 (N'พระครูสถิตบุญวัฒน์', 1), 
	 (N'พระครูสถิตย์บุญวัฒน์', 1), 
	 (N'พระครูสมุทรขันตยาภรณ์', 1), 
	 (N'พระครูสมุห์', 1), 
	 (N'พระครูสังฆบริรักษ์', 1), 
	 (N'พระครูสังฆภารวิชัย', 1), 
	 (N'พระครูสังฆรักษ์', 1), 
	 (N'พระครูสังฆวิชัย', 1), 
	 (N'พระครูสังฆวิชิต', 1), 
	 (N'พระครูสิริคุณารักษ์', 1), 
	 (N'พระครูสิริชัยสถิต', 1), 
	 (N'พระครูสุทัศน์ธรรมาภิรม', 1), 
	 (N'พระครูสุธรรมโสภิต', 1), 
	 (N'พระครูสุนทรคณาภิรักษ์', 1), 
	 (N'พระครูสุนทรปภากร', 1), 
	 (N'พระครูสุนทรวรธัช', 1), 
	 (N'พระครูสุนทรวรวัฒน์', 1), 
	 (N'พระครูสุนทรสมณคุณ', 1), 
	 (N'พระครูสุพจน์วรคุณ', 1), 
	 (N'พระครูสุพจน์วราภรณ์', 1), 
	 (N'พระครูสุวรรณพัฒนคุณ', 1), 
	 (N'พระครูโสภณคุณานุกูล', 1), 
	 (N'พระครูโสภณปริยัติคุณ', 1), 
	 (N'พระครูโสภณสมุทรคุณ', 1), 
	 (N'พระครูโสภิตวัชรกิจ', 1), 
	 (N'พระครูอมรธรรมนายก', 1), 
	 (N'พระครูอมรวิสุทธิคุณ', 1), 
	 (N'พระครูอาทรโพธิกิจ', 1), 
	 (N'พระครูอุเทศธรรมนิวิฐ', 1), 
	 (N'พระครูอุปถัมภ์นันทกิจ', 1), 
	 (N'พระครูอุปถัมภ์วชิโรภาส', 1), 
	 (N'พระครูโอภาสธรรมพิมล', 1), 
	 (N'พระครูโอภาสสมาจาร', 1), 
	 (N'พระคาร์ดินัล', 1), 
	 (N'พระคุณเจ้า', 1), 
	 (N'พระเจ้าบรมวงศ์เธอ', 1), 
	 (N'พระเจ้าวรวงศ์เธอ', 1), 
	 (N'พระเจ้าวรวงศ์เธอ พระองค์เจ้า', 1), 
	 (N'พระเจ้าวรวงศ์เธอพระองค์หญิง', 2), 
	 (N'พระเจ้าหลานเธอ', 1), 
	 (N'พระเจ้าหลานเธอ พระองค์เจ้า', 1), 
	 (N'พระเจ้าหลานยาเธอ', 1), 
	 (N'พระญาณ', 1), 
	 (N'พระญาณโศภณ', 1), 
	 (N'พระเทพ', 1), 
	 (N'พระเทพชลธารมุนี ศรีชลบุราจารย์', 1), 
	 (N'พระเทพญาณกวี', 1), 
	 (N'พระธรรม', 1), 
	 (N'พระธรรมเมธาจารย์', 1), 
	 (N'พระธรรมโสภณ', 1), 
	 (N'พระบาทสมเด็จพระเจ้าอยู่หัว', 1), 
	 (N'พระปริยัติ', 1), 
	 (N'พระปลัด', 1), 
	 (N'พระปลัดขวา', 1), 
	 (N'พระปลัดซ้าย', 1), 
	 (N'พระปิฎก', 1), 
	 (N'พระเปรียญธรรม', 1), 
	 (N'พระพรหมมุนี', 1), 
	 (N'พระพรหมวชิรญาณ', 1), 
	 (N'พระพิศาลสารคุณ', 1), 
	 (N'พระมหา', 1), 
	 (N'พระมหานายก', 1), 
	 (N'พระยา', 1), 
	 (N'พระรัตน', 1), 
	 (N'พระรัตนมงคลวิสุทธ์', 1), 
	 (N'พระราช', 1), 
	 (N'พระราชญาณ', 1), 
	 (N'พระราชบัณฑิต', 1), 
	 (N'พระราชปัญญา', 1), 
	 (N'พระราชพัชราภรณ์', 1), 
	 (N'พระราชเมธาภรณ์', 1), 
	 (N'พระราชวชิราภรณ์', 1), 
	 (N'พระราชวิมลโมลี', 1), 
	 (N'พระราชาคณะ', 1), 
	 (N'พระราชาวิมลโมลี', 1), 
	 (N'พระวรวงศ์เธอ', 1), 
	 (N'พระวรวงศ์เธอพระองค์เจ้า', 1), 
	 (N'พระวิริวัฒน์วิสุทธิ์', 1), 
	 (N'พระศรีปริยัติธาดา', 1), 
	 (N'พระศรีปริยัติบัณฑิต', 1), 
	 (N'พระศรีปริยัติโมลี', 1), 
	 (N'พระศรีวชิราภรณ์', 1), 
	 (N'พระสมุห์', 1), 
	 (N'พระสรภาณโกศล', 1), 
	 (N'พระสังฆราช', 1), 
	 (N'พระสัญญาบัตร', 1), 
	 (N'พระสาสนโสภณ', 1), 
	 (N'พระสุธีวัชโรดม', 1), 
	 (N'พระโสภณธรรมาภรณ์', 1), 
	 (N'พระโสภณปริยัติธรรม', 1), 
	 (N'พระหิรัญยบัฏ', 1), 
	 (N'พระองค์เจ้า', 1), 
	 (N'พระอธิการ', 1), 
	 (N'พระอธิธรรม', 1), 
	 (N'พระอัครสังฆราช', 1), 
	 (N'พระอุดมสารโสภณ', 1), 
	 (N'พล.จ.', 1), 
	 (N'พล.จ.หลวง', 1), 
	 (N'พล.ต.', 1), 
	 (N'พล.ต. น.พ.', 1), 
	 (N'พล.ต. ม.จ', 1), 
	 (N'พล.ต. หม่อมเจ้า', 1), 
	 (N'พล.ต.จ.', 1), 
	 (N'พล.ต.ต.', 1), 
	 (N'พล.ต.ต. ดร.', 1), 
	 (N'พล.ต.ต. ดอกเตอร์', 1), 
	 (N'พล.ต.ต. ม.ร.ว.', 1), 
	 (N'พล.ต.ต. หญิง', 2), 
	 (N'พล.ต.ต.ดร.', 1), 
	 (N'พล.ต.ต.ดอกเตอร์', 1), 
	 (N'พล.ต.ต.ม.ร.ว.', 1), 
	 (N'พล.ต.ต.ม.ล.', 1), 
	 (N'พล.ต.ต.หญิง', 2), 
	 (N'พล.ต.ต.หม่อมราชวงศ์', 1), 
	 (N'พล.ต.ท.', 1), 
	 (N'พล.ต.ท. ดร.', 1), 
	 (N'พล.ต.ท. ดอกเตอร์', 1), 
	 (N'พล.ต.ท. ม.ร.ว.', 1), 
	 (N'พล.ต.ท. หญิง', 2), 
	 (N'พล.ต.ท.ดร.', 1), 
	 (N'พล.ต.ท.ดอกเตอร์', 1), 
	 (N'พล.ต.ท.ม.ร.ว.', 1), 
	 (N'พล.ต.ท.หญิง', 2), 
	 (N'พล.ต.ท.หม่อมราชวงศ์', 1), 
	 (N'พล.ต.น.พ.', 1), 
	 (N'พล.ต.นายแพทย์', 1), 
	 (N'พล.ต.ม.จ.', 1), 
	 (N'พล.ต.ม.ร.ว.', 1), 
	 (N'พล.ต.ม.ล.', 1), 
	 (N'พล.ต.หญิง คุณหญิง', 2), 
	 (N'พล.ต.หม่อมเจ้า', 1), 
	 (N'พล.ต.อ.', 1), 
	 (N'พล.ต.อ. ดร.', 1), 
	 (N'พล.ต.อ. ดอกเตอร์', 1), 
	 (N'พล.ต.อ. ม.ร.ว.', 1), 
	 (N'พล.ต.อ. หญิง', 2), 
	 (N'พล.ต.อ.ดร.', 1), 
	 (N'พล.ต.อ.ดอกเตอร์', 1), 
	 (N'พล.ต.อ.ม.ร.ว.', 1), 
	 (N'พล.ต.อ.หญิง', 2), 
	 (N'พล.ต.อ.หม่อมราชวงศ์', 1), 
	 (N'พล.ท.', 1), 
	 (N'พล.ท. น.พ.', 1), 
	 (N'พล.ท. ม.จ.', 1), 
	 (N'พล.ท. หม่อมเจ้า', 1), 
	 (N'พล.ท.น.พ.', 1), 
	 (N'พล.ท.นายแพทย์', 1), 
	 (N'พล.ท.ม.จ.', 1), 
	 (N'พล.ท.ม.ล.', 1), 
	 (N'พล.ท.หญิง คุณหญิง', 2), 
	 (N'พล.ท.หม่อมเจ้า', 1), 
	 (N'พล.ท.หลวง', 1), 
	 (N'พล.ร จัตวา', 1), 
	 (N'พล.ร.จ.', 1), 
	 (N'พล.ร.จัตวา', 1), 
	 (N'พล.ร.ต.', 1), 
	 (N'พล.ร.ต. ม.ร.ว.', 1), 
	 (N'พล.ร.ต.ม.จ.', 1), 
	 (N'พล.ร.ต.ม.ร.ว.', 1), 
	 (N'พล.ร.ต.ม.ล.', 1), 
	 (N'พล.ร.ต.หม่อมราชวงศ์', 1), 
	 (N'พล.ร.ท.', 1), 
	 (N'พล.ร.ท. ม.ร.ว.', 1), 
	 (N'พล.ร.ท. หม่อมราชวงศ์', 1), 
	 (N'พล.ร.ท.ม.ร.ว.', 1), 
	 (N'พล.ร.อ.', 1), 
	 (N'พล.ร.อ. ม.ร.ว.', 1), 
	 (N'พล.ร.อ.ม.ร.ว.', 1), 
	 (N'พล.ร.อ.หม่อมราชวงศ์', 1), 
	 (N'พล.อ.', 1), 
	 (N'พล.อ. น.พ.', 1), 
	 (N'พล.อ. ม.จ', 1), 
	 (N'พล.อ. หม่อมเจ้า', 1), 
	 (N'พล.อ.จ.', 1), 
	 (N'พล.อ.ต.', 1), 
	 (N'พล.อ.ต. ม.ร.ว.', 1), 
	 (N'พล.อ.ต. หญิง', 1), 
	 (N'พล.อ.ต. หญิง ดร.', 1), 
	 (N'พล.อ.ต.ม.ร.ว.', 1), 
	 (N'พล.อ.ต.ม.ล.', 1), 
	 (N'พล.อ.ต.หญิง', 1), 
	 (N'พล.อ.ต.หญิง ดร.', 1), 
	 (N'พล.อ.ต.หม่อมราชวงศ์', 1), 
	 (N'พล.อ.ตรี', 1), 
	 (N'พล.อ.ท.', 1), 
	 (N'พล.อ.ท. ม.ร.ว.', 1), 
	 (N'พล.อ.ท. หญิง', 1), 
	 (N'พล.อ.ท. หญิง ดร.', 1), 
	 (N'พล.อ.ท.ม.ร.ว.', 1), 
	 (N'พล.อ.ท.ม.ล.', 1), 
	 (N'พล.อ.ท.หญิง', 1), 
	 (N'พล.อ.ท.หญิง ดร.', 1), 
	 (N'พล.อ.ท.หม่อมราชวงศ์', 1), 
	 (N'พล.อ.โท', 1), 
	 (N'พล.อ.น.พ.', 1), 
	 (N'พล.อ.นายแพทย์', 1), 
	 (N'พล.อ.ม.จ.', 1), 
	 (N'พล.อ.มล.', 1), 
	 (N'พล.อ.หญิง คุณหญิง', 2), 
	 (N'พล.อ.หม่อมเจ้า', 1), 
	 (N'พล.อ.อ.', 1), 
	 (N'พล.อ.อ. ม.ร.ว.', 1), 
	 (N'พล.อ.อ. หญิง', 1), 
	 (N'พล.อ.อ. หญิง ดร.', 1), 
	 (N'พล.อ.อ.ม.ร.ว.', 1), 
	 (N'พล.อ.อ.หญิง', 1), 
	 (N'พล.อ.อ.หญิง ดร.', 1), 
	 (N'พล.อ.อ.หม่อมราชวงศ์', 1), 
	 (N'พล.อ.เอก', 1), 
	 (N'พลจัตวา', 1), 
	 (N'พลจัตวาหลวง', 1), 
	 (N'พลตรี', 1), 
	 (N'พลตรี น.พ.', 1), 
	 (N'พลตรี นายแพทย์', 1), 
	 (N'พลตรี ม.จ', 1), 
	 (N'พลตรี หม่อมเจ้า', 1), 
	 (N'พลตรีนายแพทย์', 1), 
	 (N'พลตรีสมเด็จพระเทพรัตนราชสุดา', 2), 
	 (N'พลตรีหญิง คุณหญิง', 2), 
	 (N'พลตรีหม่อมเจ้า', 1), 
	 (N'พลตรีหม่อมราชวงศ์', 1), 
	 (N'พลตรีหม่อมหลวง', 1), 
	 (N'พลตำรวจ', 1), 
	 (N'พลตำรวจ (พิเศษ)', 1), 
	 (N'พลตำรวจ (สมัคร)', 1), 
	 (N'พลตำรวจ (สำรอง)', 1), 
	 (N'พลตำรวจ (อาสา)', 1), 
	 (N'พลตำรวจ สำรอง', 1), 
	 (N'พลตำรวจ สำรอง (พิเศษ)', 1), 
	 (N'พลตำรวจ สำรอง พิเศษ', 1), 
	 (N'พลตำรวจ สำรอง(พิเศษ)', 1), 
	 (N'พลตำรวจ สำรองพิเศษ', 1), 
	 (N'พลตำรวจ อาสา', 1), 
	 (N'พลตำรวจ อาสาสมัคร', 1), 
	 (N'พลตำรวจ(พิเศษ)', 1), 
	 (N'พลตำรวจ(สมัคร)', 1), 
	 (N'พลตำรวจ(สำรอง)', 1), 
	 (N'พลตำรวจ(อาสา)', 1), 
	 (N'พลตำรวจ.พิเศษ', 1), 
	 (N'พลตำรวจจัตวา', 1), 
	 (N'พลตำรวจตรี', 1), 
	 (N'พลตำรวจตรี ดร.', 1), 
	 (N'พลตำรวจตรี ดอกเตอร์', 1), 
	 (N'พลตำรวจตรี ม.ร.ว.', 1), 
	 (N'พลตำรวจตรี หญิง', 2), 
	 (N'พลตำรวจตรี หม่อมราชวงศ์', 1), 
	 (N'พลตำรวจตรีดอกเตอร์', 1), 
	 (N'พลตำรวจตรีหญิง', 2), 
	 (N'พลตำรวจตรีหม่อมราชวงศ์', 1), 
	 (N'พลตำรวจตรีหม่อมหลวง', 1), 
	 (N'พลตำรวจโท', 1), 
	 (N'พลตำรวจโท ดร.', 1), 
	 (N'พลตำรวจโท ดอกเตอร์', 1), 
	 (N'พลตำรวจโท ม.ร.ว.', 1), 
	 (N'พลตำรวจโท หญิง', 2), 
	 (N'พลตำรวจโท หม่อมราชวงศ์', 1), 
	 (N'พลตำรวจโทดอกเตอร์', 1), 
	 (N'พลตำรวจโทหญิง', 2), 
	 (N'พลตำรวจโทหม่อมราชวงศ์', 1), 
	 (N'พลตำรวจพิเศษ', 1), 
	 (N'พลตำรวจสมัคร', 1), 
	 (N'พลตำรวจสำรอง', 1), 
	 (N'พลตำรวจสำรองพิเศษ', 1), 
	 (N'พลตำรวจอาสาสมัคร', 1), 
	 (N'พลตำรวจเอก', 1), 
	 (N'พลตำรวจเอก ดร.', 1), 
	 (N'พลตำรวจเอก ดอกเตอร์', 1), 
	 (N'พลตำรวจเอก ม.ร.ว.', 1), 
	 (N'พลตำรวจเอก หญิง', 2), 
	 (N'พลตำรวจเอก หม่อมราชวงศ์', 1), 
	 (N'พลตำรวจเอกดอกเตอร์', 1), 
	 (N'พลตำรวจเอกหญิง', 2), 
	 (N'พลตำรวจเอกหม่อมราชวงศ์', 1), 
	 (N'พลทหาร', 1), 
	 (N'พลโท', 1), 
	 (N'พลโท น.พ.', 1), 
	 (N'พลโท นายแพทย์', 1), 
	 (N'พลโท ม.จ.', 1), 
	 (N'พลโท หม่อมเจ้า', 1), 
	 (N'พลโทนายแพทย์', 1), 
	 (N'พลโทสมเด็จพระบรมโอรสาธิราช', 1), 
	 (N'พลโทหญิง คุณหญิง', 2), 
	 (N'พลโทหม่อมเจ้า', 1), 
	 (N'พลโทหม่อมหลวง', 1), 
	 (N'พลโทหลวง', 1), 
	 (N'พลเรือ จ.', 1), 
	 (N'พลเรือ จัตวา', 1), 
	 (N'พลเรือจัตวา', 1), 
	 (N'พลเรือตรี', 1), 
	 (N'พลเรือตรี ม.ร.ว.', 1), 
	 (N'พลเรือตรี หม่อมราชวงศ์', 1), 
	 (N'พลเรือตรีหม่อมเจ้า', 1), 
	 (N'พลเรือตรีหม่อมราชวงศ์', 1), 
	 (N'พลเรือตรีหม่อมหลวง', 1), 
	 (N'พลเรือโท', 1), 
	 (N'พลเรือโท ม.ร.ว.', 1), 
	 (N'พลเรือโท หม่อมราชวงศ์', 1), 
	 (N'พลเรือโทหม่อมราชวงศ์', 1), 
	 (N'พลเรือเอก', 1), 
	 (N'พลเรือเอก ม.ร.ว.', 1), 
	 (N'พลเรือเอก หม่อมราชวงศ์', 1), 
	 (N'พลเรือเอกหม่อมราชวงศ์', 1), 
	 (N'พลสารวัตร', 1), 
	 (N'พลอากาศจัตวา', 1), 
	 (N'พลอากาศตรี', 1), 
	 (N'พลอากาศตรี ม.ร.ว.', 1), 
	 (N'พลอากาศตรี หญิง', 1), 
	 (N'พลอากาศตรี หม่อมราชวงศ์', 1), 
	 (N'พลอากาศตรีหญิง', 1), 
	 (N'พลอากาศตรีหญิง ดร.', 1), 
	 (N'พลอากาศตรีหญิง.ดร.', 1), 
	 (N'พลอากาศตรีหม่อมราชวงศ์', 1), 
	 (N'พลอากาศตรีหม่อมหลวง', 1), 
	 (N'พลอากาศโท', 1), 
	 (N'พลอากาศโท ม.ร.ว.', 1), 
	 (N'พลอากาศโท หญิง', 1), 
	 (N'พลอากาศโท หม่อมราชวงศ์', 1), 
	 (N'พลอากาศโทหญิง', 1), 
	 (N'พลอากาศโทหญิง ดร.', 1), 
	 (N'พลอากาศโทหญิง.ดร.', 1), 
	 (N'พลอากาศโทหม่อมราชวงศ์', 1), 
	 (N'พลอากาศโทหม่อมหลวง', 1), 
	 (N'พลอากาศเอก', 1), 
	 (N'พลอากาศเอก ม.ร.ว.', 1), 
	 (N'พลอากาศเอก หญิง', 1), 
	 (N'พลอากาศเอก หม่อมราชวงศ์', 1), 
	 (N'พลอากาศเอกหญิง', 1), 
	 (N'พลอากาศเอกหญิง ดร.', 1), 
	 (N'พลอากาศเอกหญิง.ดร.', 1), 
	 (N'พลอากาศเอกหม่อมราชวงศ์', 1), 
	 (N'พลเอก', 1), 
	 (N'พลเอก น.พ.', 1), 
	 (N'พลเอก นายแพทย์', 1), 
	 (N'พลเอก ม.จ', 1), 
	 (N'พลเอกนายแพทย์', 1), 
	 (N'พลเอกหญิง คุณหญิง', 2), 
	 (N'พลเอกหม่อมเจ้า', 1), 
	 (N'พลเอกหม่อมหลวง', 1), 
	 (N'พลฯ', 1), 
	 (N'พลฯ (พิเศษ)', 1), 
	 (N'พลฯ (สมัคร)', 1), 
	 (N'พลฯ (สำรอง)', 1), 
	 (N'พลฯ (อาสา)', 1), 
	 (N'พลฯ ท.อ.', 1), 
	 (N'พลฯ ทร', 1), 
	 (N'พลฯ ทหารเรือ', 1), 
	 (N'พลฯ ทหารอากาศ', 1), 
	 (N'พลฯ สำรอง', 1), 
	 (N'พลฯ สำรอง (พิเศษ)', 1), 
	 (N'พลฯ สำรอง พิเศษ', 1), 
	 (N'พลฯ สำรอง(พิเศษ)', 1), 
	 (N'พลฯ สำรองพิเศษ', 1), 
	 (N'พลฯ อาสา', 1), 
	 (N'พลฯ อาสาสมัคร', 1), 
	 (N'พลฯ(พิเศษ)', 1), 
	 (N'พลฯ(สมัคร)', 1), 
	 (N'พลฯ(สำรอง)', 1), 
	 (N'พลฯ(อาสา)', 1), 
	 (N'พลฯ.ท.อ.', 1), 
	 (N'พลฯ.ทร', 1), 
	 (N'พลฯ.ทหารอากาศ', 1), 
	 (N'พลฯ.พิเศษ', 1), 
	 (N'พลฯทหารเรือ', 1), 
	 (N'พลฯทหารอากาศ', 1), 
	 (N'พลฯพิเศษ', 1), 
	 (N'พลฯม.ล.', 1), 
	 (N'พลฯสมัคร', 1), 
	 (N'พลฯสำรอง', 1), 
	 (N'พลฯสำรอง (พิเศษ)', 1), 
	 (N'พลฯสำรอง พิเศษ', 1), 
	 (N'พลฯสำรอง(พิเศษ)', 1), 
	 (N'พลฯสำรองพิเศษ', 1), 
	 (N'พลฯหม่อมหลวง', 1), 
	 (N'พลฯอาสา', 1), 
	 (N'พลฯอาสาสมัคร', 1), 
	 (N'พันจ่าตรี', 1), 
	 (N'พันจ่าโท', 1), 
	 (N'พันจ่าอากาศตรี', 1), 
	 (N'พันจ่าอากาศโท', 1), 
	 (N'พันจ่าอากาศเอก', 1), 
	 (N'พันจ่าอากาศเอกหม่อมหลวง', 1), 
	 (N'พันจ่าเอก', 1), 
	 (N'พันจ่าเอกหม่อมหลวง', 1), 
	 (N'พันตรี', 1), 
	 (N'พันตรี คุณหญิง', 2), 
	 (N'พันตรี น.พ.', 1), 
	 (N'พันตรี นายแพทย์', 1), 
	 (N'พันตรี ม.จ.', 1), 
	 (N'พันตรี ม.ร.ว.', 1), 
	 (N'พันตรี หม่อมเจ้า', 1), 
	 (N'พันตรี หม่อมราชวงศ์', 1), 
	 (N'พันตรีคุณหญิง', 2), 
	 (N'พันตรีนายแพทย์', 1), 
	 (N'พันตรีพระเจ้าวรวงศ์เธอพระองค์', 1), 
	 (N'พันตรีพระเจ้าวรวงศ์เธอพระองค์เจ้า', 1), 
	 (N'พันตรีหม่อมเจ้า', 1), 
	 (N'พันตรีหม่อมราชวงศ์', 1), 
	 (N'พันตรีหม่อมหลวง', 1), 
	 (N'พันตรีหลวง', 1), 
	 (N'พันตำรวจตรี', 1), 
	 (N'พันตำรวจตรี ดร.', 1), 
	 (N'พันตำรวจตรี ดอกเตอร์', 1), 
	 (N'พันตำรวจตรี นพ.', 1), 
	 (N'พันตำรวจตรี นายแพทย์', 1), 
	 (N'พันตำรวจตรี ม.ร.ว.', 1), 
	 (N'พันตำรวจตรี หญิง', 2), 
	 (N'พันตำรวจตรี หม่อมราชวงศ์', 1), 
	 (N'พันตำรวจตรีดอกเตอร์', 1), 
	 (N'พันตำรวจตรีนายแพทย์', 1), 
	 (N'พันตำรวจตรีหญิง', 2), 
	 (N'พันตำรวจตรีหญิง ท่านผู้หญิง', 2), 
	 (N'พันตำรวจตรีหม่อมราชวงศ์', 1), 
	 (N'พันตำรวจตรีหม่อมหลวง', 1), 
	 (N'พันตำรวจตรีหลวง', 1), 
	 (N'พันตำรวจโท', 1), 
	 (N'พันตำรวจโท ดร.', 1), 
	 (N'พันตำรวจโท ดอกเตอร์', 1), 
	 (N'พันตำรวจโท นพ.', 1), 
	 (N'พันตำรวจโท นายแพทย์', 1), 
	 (N'พันตำรวจโท ม.ร.ว.', 1), 
	 (N'พันตำรวจโท หญิง', 2), 
	 (N'พันตำรวจโท หม่อมราชวงศ์', 1), 
	 (N'พันตำรวจโทดอกเตอร์', 1), 
	 (N'พันตำรวจโทนายแพทย์', 1), 
	 (N'พันตำรวจโทหญิง', 2), 
	 (N'พันตำรวจโทหญิง ท่านผู้หญิง', 2), 
	 (N'พันตำรวจโทหม่อมเจ้า', 1), 
	 (N'พันตำรวจโทหม่อมราชวงศ์', 1), 
	 (N'พันตำรวจโทหม่อมหลวง', 1), 
	 (N'พันตำรวจเอก', 1), 
	 (N'พันตำรวจเอก (พิเศษ)', 1), 
	 (N'พันตำรวจเอก ดร.', 1), 
	 (N'พันตำรวจเอก ดอกเตอร์', 1), 
	 (N'พันตำรวจเอก นพ.', 1), 
	 (N'พันตำรวจเอก นายแพทย์', 1), 
	 (N'พันตำรวจเอก ม.ร.ว.', 1), 
	 (N'พันตำรวจเอก หญิง', 2), 
	 (N'พันตำรวจเอก หม่อมราชวงศ์', 1), 
	 (N'พันตำรวจเอกดอกเตอร์', 1), 
	 (N'พันตำรวจเอกนายแพทย์', 1), 
	 (N'พันตำรวจเอกหญิง', 2), 
	 (N'พันตำรวจเอกหญิง ท่านผู้หญิง', 2), 
	 (N'พันตำรวจเอกหม่อมเจ้า', 1), 
	 (N'พันตำรวจเอกหม่อมราชวงศ์', 1), 
	 (N'พันตำรวจเอกหม่อมหลวง', 1), 
	 (N'พันโท', 1), 
	 (N'พันโท คุณหญิง', 2), 
	 (N'พันโท น.พ.', 1), 
	 (N'พันโท นายแพทย์', 1), 
	 (N'พันโท ม.จ.', 1), 
	 (N'พันโท ม.ร.ว.', 1), 
	 (N'พันโท หม่อมเจ้า', 1), 
	 (N'พันโท หม่อมราชวงศ์', 1), 
	 (N'พันโทคุณหญิง', 2), 
	 (N'พันโทนายแพทย์', 1), 
	 (N'พันโทหม่อมเจ้า', 1), 
	 (N'พันโทหม่อมราชวงศ์', 1), 
	 (N'พันโทหม่อมหลวง', 1), 
	 (N'พันโทหลวง', 1), 
	 (N'พันอากาศตรี ม.ร.ว.', 1), 
	 (N'พันอากาศตรี หม่อมราชวงศ์', 1), 
	 (N'พันอากาศตรีหม่อมราชวงศ์', 1), 
	 (N'พันอากาศโท ม.ร.ว.', 1), 
	 (N'พันอากาศโท หม่อมราชวงศ์', 1), 
	 (N'พันอากาศโทหม่อมราชวงศ์', 1), 
	 (N'พันอากาศเอก ม.ร.ว.', 1), 
	 (N'พันอากาศเอก หม่อมราชวงศ์', 1), 
	 (N'พันอากาศเอกหม่อมราชวงศ์', 1), 
	 (N'พันเอก', 1), 
	 (N'พันเอก (พิเศษ)', 1), 
	 (N'พันเอก (พิเศษ) หม่อมราชวงศ์', 1), 
	 (N'พันเอก (พิเศษ)หม่อมราชวงศ์', 1), 
	 (N'พันเอก น.พ.', 1), 
	 (N'พันเอก นายแพทย์', 1), 
	 (N'พันเอก พิเศษ', 1), 
	 (N'พันเอก ม.จ.', 1), 
	 (N'พันเอก ม.ร.ว.', 1), 
	 (N'พันเอก หม่อมเจ้า', 1), 
	 (N'พันเอก หม่อมราชวงศ์', 1), 
	 (N'พันเอก(พิเศษ)', 1), 
	 (N'พันเอก(พิเศษ) หม่อมราชวงศ์', 1), 
	 (N'พันเอก(พิเศษ)หม่อมราชวงศ์', 1), 
	 (N'พันเอกนายแพทย์', 1), 
	 (N'พันเอกพิเศษ', 1), 
	 (N'พันเอกหญิง คุณหญิง', 2), 
	 (N'พันเอกหญิงคุณหญิง', 2), 
	 (N'พันเอกหม่อมเจ้า', 1), 
	 (N'พันเอกหม่อมราชวงศ์', 1), 
	 (N'พันเอกหม่อมหลวง', 1), 
	 (N'แพทย์หญิง', 2), 
	 (N'แพทย์หญิง คุณหญิง', 2), 
	 (N'แพทย์หญิงคุณหญิง', 2), 
	 (N'ภก.', 1), 
	 (N'ภญ.', 2), 
	 (N'ภาราดา', 1), 
	 (N'เภสัชกรชาย', 1), 
	 (N'เภสัชกรหญิง', 2), 
	 (N'ม.จ.', 1), 
	 (N'ม.จ.หญิง', 2), 
	 (N'ม.ญ.', 1), 
	 (N'ม.ต.', 1), 
	 (N'ม.ท.', 1), 
	 (N'ม.ร.ว.', 1), 
	 (N'ม.ล.', 1), 
	 (N'ม.อ.', 1), 
	 (N'มว.ต.', 1), 
	 (N'มว.ท.', 1), 
	 (N'มว.อ.', 1), 
	 (N'แม่ชี', 2), 
	 (N'ร.ต.', 1), 
	 (N'ร.ต. ดร.', 1), 
	 (N'ร.ต. ดอกเตอร์', 1), 
	 (N'ร.ต. น.พ.', 1), 
	 (N'ร.ต. นายแพทย์', 1), 
	 (N'ร.ต. พ.ญ.', 2), 
	 (N'ร.ต. ม.จ.', 1), 
	 (N'ร.ต. ม.ร.ว.', 1), 
	 (N'ร.ต. หม่อมเจ้า', 1), 
	 (N'ร.ต.ดร.', 1), 
	 (N'ร.ต.ดอกเตอร์', 1), 
	 (N'ร.ต.ต.', 1), 
	 (N'ร.ต.ต. ดร.', 1), 
	 (N'ร.ต.ต. ดอกเตอร์', 1), 
	 (N'ร.ต.ต. น.พ.', 1), 
	 (N'ร.ต.ต. ม.ร.ว.', 1), 
	 (N'ร.ต.ต. หญิง', 2), 
	 (N'ร.ต.ต.ดร.', 1), 
	 (N'ร.ต.ต.ดอกเตอร์', 1), 
	 (N'ร.ต.ต.น.พ.', 1), 
	 (N'ร.ต.ต.นายแพทย์', 1);
GO

INSERT INTO MTitle ([Description], GenderId) VALUES
	 (N'ร.ต.ต.ม.ร.ว.', 1), 
	 (N'ร.ต.ต.หญิง', 2), 
	 (N'ร.ต.ต.หม่อมราชวงศ์', 1), 
	 (N'ร.ต.ท.', 1), 
	 (N'ร.ต.ท. ดร.', 1), 
	 (N'ร.ต.ท. ดอกเตอร์', 1), 
	 (N'ร.ต.ท. น.พ.', 1), 
	 (N'ร.ต.ท. ม.ร.ว.', 1), 
	 (N'ร.ต.ท. หญิง', 2), 
	 (N'ร.ต.ท.ดร.', 1), 
	 (N'ร.ต.ท.ดอกเตอร์', 1), 
	 (N'ร.ต.ท.น.พ.', 1), 
	 (N'ร.ต.ท.นายแพทย์', 1), 
	 (N'ร.ต.ท.ม.ร.ว.', 1), 
	 (N'ร.ต.ท.ม.ล.', 1), 
	 (N'ร.ต.ท.หญิง', 2), 
	 (N'ร.ต.ท.หม่อมราชวงศ์', 1), 
	 (N'ร.ต.น.พ.', 1), 
	 (N'ร.ต.นายแพทย์', 1), 
	 (N'ร.ต.พ.ญ.', 2), 
	 (N'ร.ต.แพทย์หญิง', 2), 
	 (N'ร.ต.ม.จ.', 1), 
	 (N'ร.ต.ม.ร.ว.', 1), 
	 (N'ร.ต.ม.ล.', 1), 
	 (N'ร.ต.หม่อมเจ้า', 1), 
	 (N'ร.ต.หม่อมราชวงศ์', 1), 
	 (N'ร.ต.อ.', 1), 
	 (N'ร.ต.อ. ดร.', 1), 
	 (N'ร.ต.อ. ดอกเตอร์', 1), 
	 (N'ร.ต.อ. น.พ.', 1), 
	 (N'ร.ต.อ. ม.ร.ว.', 1), 
	 (N'ร.ต.อ. หญิง', 2), 
	 (N'ร.ต.อ.ดร.', 1), 
	 (N'ร.ต.อ.ดอกเตอร์', 1), 
	 (N'ร.ต.อ.น.พ.', 1), 
	 (N'ร.ต.อ.นายแพทย์', 1), 
	 (N'ร.ต.อ.ม.ร.ว.', 1), 
	 (N'ร.ต.อ.ม.ล.', 1), 
	 (N'ร.ต.อ.หญิง', 2), 
	 (N'ร.ต.อ.หม่อมราชวงศ์', 1), 
	 (N'ร.ท.', 1), 
	 (N'ร.ท. ดร.', 1), 
	 (N'ร.ท. ดอกเตอร์', 1), 
	 (N'ร.ท. น.พ.', 1), 
	 (N'ร.ท. นายแพทย์', 1), 
	 (N'ร.ท. พ.ญ.', 2), 
	 (N'ร.ท. ม.จ.', 1), 
	 (N'ร.ท. ม.ร.ว.', 1), 
	 (N'ร.ท. หม่อมเจ้า', 1), 
	 (N'ร.ท.ขุน', 1), 
	 (N'ร.ท.ดร.', 1), 
	 (N'ร.ท.ดอกเตอร์', 1), 
	 (N'ร.ท.น.พ.', 1), 
	 (N'ร.ท.นายแพทย์', 1), 
	 (N'ร.ท.พ.ญ.', 2), 
	 (N'ร.ท.แพทย์หญิง', 2), 
	 (N'ร.ท.ม.จ.', 1), 
	 (N'ร.ท.ม.ร.ว.', 1), 
	 (N'ร.ท.ม.ล.', 1), 
	 (N'ร.ท.หม่อมเจ้า', 1), 
	 (N'ร.ท.หม่อมราชวงศ์', 1), 
	 (N'ร.อ.', 1), 
	 (N'ร.อ. ดร.', 1), 
	 (N'ร.อ. ดอกเตอร์', 1), 
	 (N'ร.อ. น.พ.', 1), 
	 (N'ร.อ. นายแพทย์', 1), 
	 (N'ร.อ. พ.ญ.', 2), 
	 (N'ร.อ. ม.จ.', 1), 
	 (N'ร.อ. ม.ร.ว.', 1), 
	 (N'ร.อ. หม่อมเจ้า', 1), 
	 (N'ร.อ.ดร.', 1), 
	 (N'ร.อ.ดอกเตอร์', 1), 
	 (N'ร.อ.น.พ.', 1), 
	 (N'ร.อ.นายแพทย์', 1), 
	 (N'ร.อ.พ.ญ.', 2), 
	 (N'ร.อ.แพทย์หญิง', 2), 
	 (N'ร.อ.ม.จ.', 1), 
	 (N'ร.อ.ม.ร.ว.', 1), 
	 (N'ร.อ.ม.ล.', 1), 
	 (N'ร.อ.หม่อมราชวงศ์', 1), 
	 (N'รศ.', 1), 
	 (N'รองเจ้าอธิการ', 1), 
	 (N'รองศาสตราจารย์', 1), 
	 (N'รองสมเด็จพระราชาคณะ', 1), 
	 (N'รองเสวกตรี', 1), 
	 (N'รองอำมาตย์ตรี', 1), 
	 (N'รองอำมาตย์เอก', 1), 
	 (N'ร้อยตรี', 1), 
	 (N'ร้อยตรี ดร.', 1), 
	 (N'ร้อยตรี ดอกเตอร์', 1), 
	 (N'ร้อยตรี น.พ.', 1), 
	 (N'ร้อยตรี นายแพทย์', 1), 
	 (N'ร้อยตรี พ.ญ.', 2), 
	 (N'ร้อยตรี แพทย์หญิง', 2), 
	 (N'ร้อยตรี ม.จ.', 1), 
	 (N'ร้อยตรี ม.ร.ว.', 1), 
	 (N'ร้อยตรี หม่อมเจ้า', 1), 
	 (N'ร้อยตรี หม่อมราชวงศ์', 1), 
	 (N'ร้อยตรีดอกเตอร์', 1), 
	 (N'ร้อยตรีนายแพทย์', 1), 
	 (N'ร้อยตรีแพทย์หญิง', 2), 
	 (N'ร้อยตรีหม่อมเจ้า', 1), 
	 (N'ร้อยตรีหม่อมราชวงศ์', 1), 
	 (N'ร้อยตรีหม่อมหลวง', 1), 
	 (N'ร้อยตำรวจตรี', 1), 
	 (N'ร้อยตำรวจตรี ดร.', 1), 
	 (N'ร้อยตำรวจตรี ดอกเตอร์', 1), 
	 (N'ร้อยตำรวจตรี น.พ.', 1), 
	 (N'ร้อยตำรวจตรี นายแพทย์', 1), 
	 (N'ร้อยตำรวจตรี ม.ร.ว.', 1), 
	 (N'ร้อยตำรวจตรี หญิง', 2), 
	 (N'ร้อยตำรวจตรี หม่อมราชวงศ์', 1), 
	 (N'ร้อยตำรวจตรีดอกเตอร์', 1), 
	 (N'ร้อยตำรวจตรีนายแพทย์', 1), 
	 (N'ร้อยตำรวจตรีหญิง', 2), 
	 (N'ร้อยตำรวจตรีหม่อมราชวงศ์', 1), 
	 (N'ร้อยตำรวจโท', 1), 
	 (N'ร้อยตำรวจโท ดร.', 1), 
	 (N'ร้อยตำรวจโท ดอกเตอร์', 1), 
	 (N'ร้อยตำรวจโท น.พ.', 1), 
	 (N'ร้อยตำรวจโท นายแพทย์', 1), 
	 (N'ร้อยตำรวจโท ม.ร.ว.', 1), 
	 (N'ร้อยตำรวจโท หญิง', 2), 
	 (N'ร้อยตำรวจโท หม่อมราชวงศ์', 1), 
	 (N'ร้อยตำรวจโทดอกเตอร์', 1), 
	 (N'ร้อยตำรวจโทนายแพทย์', 1), 
	 (N'ร้อยตำรวจโทหญิง', 2), 
	 (N'ร้อยตำรวจโทหม่อมราชวงศ์', 1), 
	 (N'ร้อยตำรวจโทหม่อมหลวง', 1), 
	 (N'ร้อยตำรวจเอก', 1), 
	 (N'ร้อยตำรวจเอก ดร.', 1), 
	 (N'ร้อยตำรวจเอก ดอกเตอร์', 1), 
	 (N'ร้อยตำรวจเอก น.พ.', 1), 
	 (N'ร้อยตำรวจเอก นายแพทย์', 1), 
	 (N'ร้อยตำรวจเอก ม.ร.ว.', 1), 
	 (N'ร้อยตำรวจเอก หญิง', 2), 
	 (N'ร้อยตำรวจเอก หม่อมราชวงศ์', 1), 
	 (N'ร้อยตำรวจเอกดอกเตอร์', 1), 
	 (N'ร้อยตำรวจเอกนายแพทย์', 1), 
	 (N'ร้อยตำรวจเอกหญิง', 2), 
	 (N'ร้อยตำรวจเอกหม่อมราชวงศ์', 1), 
	 (N'ร้อยตำรวจเอกหม่อมหลวง', 1), 
	 (N'ร้อยโท', 1), 
	 (N'ร้อยโท ดร.', 1), 
	 (N'ร้อยโท ดอกเตอร์', 1), 
	 (N'ร้อยโท น.พ.', 1), 
	 (N'ร้อยโท นายแพทย์', 1), 
	 (N'ร้อยโท พ.ญ.', 2), 
	 (N'ร้อยโท แพทย์หญิง', 2), 
	 (N'ร้อยโท ม.จ.', 1), 
	 (N'ร้อยโท ม.ร.ว.', 1), 
	 (N'ร้อยโท หม่อมเจ้า', 1), 
	 (N'ร้อยโท หม่อมราชวงศ์', 1), 
	 (N'ร้อยโทดอกเตอร์', 1), 
	 (N'ร้อยโทนายแพทย์', 1), 
	 (N'ร้อยโทแพทย์หญิง', 2), 
	 (N'ร้อยโทหม่อมเจ้า', 1), 
	 (N'ร้อยโทหม่อมราชวงศ์', 1), 
	 (N'ร้อยโทหม่อมหลวง', 1), 
	 (N'ร้อยเอก', 1), 
	 (N'ร้อยเอก ดร.', 1), 
	 (N'ร้อยเอก ดอกเตอร์', 1), 
	 (N'ร้อยเอก น.พ.', 1), 
	 (N'ร้อยเอก นายแพทย์', 1), 
	 (N'ร้อยเอก พ.ญ.', 2), 
	 (N'ร้อยเอก แพทย์หญิง', 2), 
	 (N'ร้อยเอก ม.จ.', 1), 
	 (N'ร้อยเอก ม.ร.ว.', 1), 
	 (N'ร้อยเอก หม่อมเจ้า', 1), 
	 (N'ร้อยเอก หม่อมราชวงศ์', 1), 
	 (N'ร้อยเอกดอกเตอร์', 1), 
	 (N'ร้อยเอกนายแพทย์', 1), 
	 (N'ร้อยเอกแพทย์หญิง', 2), 
	 (N'ร้อยเอกหม่อมเจ้า', 1), 
	 (N'ร้อยเอกหม่อมราชวงศ์', 1), 
	 (N'ร้อยเอกหม่อมหลวง', 1), 
	 (N'เรือตรี', 1), 
	 (N'เรือโท', 1), 
	 (N'เรืออากาศตรี', 1), 
	 (N'เรืออากาศตรี น.พ.', 1), 
	 (N'เรืออากาศตรี นายแพทย์', 1), 
	 (N'เรืออากาศตรีนายแพทย์', 1), 
	 (N'เรืออากาศโท', 1), 
	 (N'เรืออากาศโท น.พ.', 1), 
	 (N'เรืออากาศโท นายแพทย์', 1), 
	 (N'เรืออากาศโทขุน', 1), 
	 (N'เรืออากาศโทนายแพทย์', 1), 
	 (N'เรืออากาศเอก', 1), 
	 (N'เรืออากาศเอก น.พ.', 1), 
	 (N'เรืออากาศเอก นายแพทย์', 1), 
	 (N'เรืออากาศเอกนายแพทย์', 1), 
	 (N'เรือเอก', 1), 
	 (N'ว่าที่  น.อ. (พิเศษ)', 1), 
	 (N'ว่าที่  น.อ.(พิเศษ)', 1), 
	 (N'ว่าที่ .ร.ต.', 1), 
	 (N'ว่าที่ น.ต.', 1), 
	 (N'ว่าที่ น.ท.', 1), 
	 (N'ว่าที่ น.อ.', 1), 
	 (N'ว่าที่ น.อ. (พิเศษ)', 1), 
	 (N'ว่าที่ น.อ.(พิเศษ)', 1), 
	 (N'ว่าที่ น.อ.พิเศษ', 1), 
	 (N'ว่าที่ นาวาตรี', 1), 
	 (N'ว่าที่ นาวาโท', 1), 
	 (N'ว่าที่ นาวาอากาศตรี', 1), 
	 (N'ว่าที่ นาวาอากาศโท', 1), 
	 (N'ว่าที่ นาวาอากาศเอก', 1), 
	 (N'ว่าที่ นาวาอากาศเอก (พิเศษ)', 1), 
	 (N'ว่าที่ นาวาอากาศเอก(พิเศษ)', 1), 
	 (N'ว่าที่ นาวาอากาศเอกพิเศษ', 1), 
	 (N'ว่าที่ นาวาเอก', 1), 
	 (N'ว่าที่ นาวาเอกพิเศษ', 1), 
	 (N'ว่าที่ พ.ต.', 1), 
	 (N'ว่าที่ พ.ต.ต.', 1), 
	 (N'ว่าที่ พ.ต.ต.หญิง', 1), 
	 (N'ว่าที่ พ.ต.ตรี หญิง', 1), 
	 (N'ว่าที่ พ.ต.ตรีหญิง', 1), 
	 (N'ว่าที่ พ.ต.ท.', 1), 
	 (N'ว่าที่ พ.ต.ท.หญิง', 1), 
	 (N'ว่าที่ พ.ต.โท หญิง', 1), 
	 (N'ว่าที่ พ.ต.โทหญิง', 1), 
	 (N'ว่าที่ พ.ต.อ.', 1), 
	 (N'ว่าที่ พ.ต.อ. (พิเศษ)', 1), 
	 (N'ว่าที่ พ.ต.อ. พิเศษ', 1), 
	 (N'ว่าที่ พ.ต.อ.(พิเศษ)', 1), 
	 (N'ว่าที่ พ.ต.อ.พิเศษ', 1), 
	 (N'ว่าที่ พ.ต.อ.หญิง', 1), 
	 (N'ว่าที่ พ.ต.เอก หญิง', 1), 
	 (N'ว่าที่ พ.ต.เอกหญิง', 1), 
	 (N'ว่าที่ พ.ท.', 1), 
	 (N'ว่าที่ พ.อ.', 1), 
	 (N'ว่าที่ พ.อ. (พิเศษ)', 1), 
	 (N'ว่าที่ พ.อ.(พิเศษ)', 1), 
	 (N'ว่าที่ พล.ต.', 1), 
	 (N'ว่าที่ พล.ต.จ.หญิง', 1), 
	 (N'ว่าที่ พล.ต.จัตวา', 1), 
	 (N'ว่าที่ พล.ต.จัตวา หญิง', 1), 
	 (N'ว่าที่ พล.ต.จัตวาหญิง', 1), 
	 (N'ว่าที่ พล.ต.ต.', 1), 
	 (N'ว่าที่ พล.ต.ต.หญิง', 1), 
	 (N'ว่าที่ พล.ต.ตรี', 1), 
	 (N'ว่าที่ พล.ต.ตรี หญิง', 1), 
	 (N'ว่าที่ พล.ต.ตรีหญิง', 1), 
	 (N'ว่าที่ พล.ต.ท.', 1), 
	 (N'ว่าที่ พล.ต.ท.หญิง', 1), 
	 (N'ว่าที่ พล.ต.โท', 1), 
	 (N'ว่าที่ พล.ต.โท หญิง', 1), 
	 (N'ว่าที่ พล.ต.โทหญิง', 1), 
	 (N'ว่าที่ พล.ต.อ.', 1), 
	 (N'ว่าที่ พล.ต.อ.หญิง', 1), 
	 (N'ว่าที่ พล.ต.เอก', 1), 
	 (N'ว่าที่ พล.ต.เอก หญิง', 1), 
	 (N'ว่าที่ พล.ต.เอกหญิง', 1), 
	 (N'ว่าที่ พล.ท.', 1), 
	 (N'ว่าที่ พล.ร.ต.', 1), 
	 (N'ว่าที่ พล.ร.ท.', 1), 
	 (N'ว่าที่ พล.ร.อ.', 1), 
	 (N'ว่าที่ พล.อ.', 1), 
	 (N'ว่าที่ พล.อ.ต.', 1), 
	 (N'ว่าที่ พล.อ.ท.', 1), 
	 (N'ว่าที่ พล.อ.อ.', 1), 
	 (N'ว่าที่ พลตรี', 1), 
	 (N'ว่าที่ พลตำรวจ จัตวา', 1), 
	 (N'ว่าที่ พลตำรวจ จัตวาหญิง', 1), 
	 (N'ว่าที่ พลตำรวจ ตรี', 1), 
	 (N'ว่าที่ พลตำรวจ ตรีหญิง', 1), 
	 (N'ว่าที่ พลตำรวจ โท', 1), 
	 (N'ว่าที่ พลตำรวจ โทหญิง', 1), 
	 (N'ว่าที่ พลตำรวจ เอก', 1), 
	 (N'ว่าที่ พลตำรวจ เอกหญิง', 1), 
	 (N'ว่าที่ พลตำรวจจัตวา', 1), 
	 (N'ว่าที่ พลตำรวจจัตวา หญิง', 1), 
	 (N'ว่าที่ พลตำรวจจัตวาหญิง', 1), 
	 (N'ว่าที่ พลตำรวจตรี', 1), 
	 (N'ว่าที่ พลตำรวจตรี หญิง', 1), 
	 (N'ว่าที่ พลตำรวจตรีหญิง', 1), 
	 (N'ว่าที่ พลตำรวจโท', 1), 
	 (N'ว่าที่ พลตำรวจโท หญิง', 1), 
	 (N'ว่าที่ พลตำรวจโทหญิง', 1), 
	 (N'ว่าที่ พลตำรวจเอก', 1), 
	 (N'ว่าที่ พลตำรวจเอก หญิง', 1), 
	 (N'ว่าที่ พลตำรวจเอกหญิง', 1), 
	 (N'ว่าที่ พลโท', 1), 
	 (N'ว่าที่ พลเรือตรี', 1), 
	 (N'ว่าที่ พลเรือโท', 1), 
	 (N'ว่าที่ พลเรือเอก', 1), 
	 (N'ว่าที่ พลอากาศตรี', 1), 
	 (N'ว่าที่ พลอากาศโท', 1), 
	 (N'ว่าที่ พลอากาศเอก', 1), 
	 (N'ว่าที่ พลเอก', 1), 
	 (N'ว่าที่ พันตรี', 1), 
	 (N'ว่าที่ พันตำรวจ ตรีหญิง', 1), 
	 (N'ว่าที่ พันตำรวจ โทหญิง', 1), 
	 (N'ว่าที่ พันตำรวจ เอกหญิง', 1), 
	 (N'ว่าที่ พันตำรวจตรี', 1), 
	 (N'ว่าที่ พันตำรวจตรี หญิง', 1), 
	 (N'ว่าที่ พันตำรวจตรีหญิง', 1), 
	 (N'ว่าที่ พันตำรวจโท', 1), 
	 (N'ว่าที่ พันตำรวจโท หญิง', 1), 
	 (N'ว่าที่ พันตำรวจโทหญิง', 1), 
	 (N'ว่าที่ พันตำรวจเอก', 1), 
	 (N'ว่าที่ พันตำรวจเอก (พิเศษ)', 1), 
	 (N'ว่าที่ พันตำรวจเอก หญิง', 1), 
	 (N'ว่าที่ พันตำรวจเอก(พิเศษ)', 1), 
	 (N'ว่าที่ พันตำรวจเอกหญิง', 1), 
	 (N'ว่าที่ พันโท', 1), 
	 (N'ว่าที่ พันเอก', 1), 
	 (N'ว่าที่ พันเอก (พิเศษ)', 1), 
	 (N'ว่าที่ พันเอก พิเศษ', 1), 
	 (N'ว่าที่ พันเอก(พิเศษ)', 1), 
	 (N'ว่าที่ ร.ต.', 1), 
	 (N'ว่าที่ ร.ต. น.พ.', 1), 
	 (N'ว่าที่ ร.ต. ม.ร.ว.', 1), 
	 (N'ว่าที่ ร.ต. หญิง', 1), 
	 (N'ว่าที่ ร.ต. หม่อมราชวงศ์', 1), 
	 (N'ว่าที่ ร.ต.ต.', 1), 
	 (N'ว่าที่ ร.ต.ท.', 1), 
	 (N'ว่าที่ ร.ต.น.พ.', 1), 
	 (N'ว่าที่ ร.ต.นายแพทย์', 1), 
	 (N'ว่าที่ ร.ต.ม.ร.ว.', 1), 
	 (N'ว่าที่ ร.ต.หญิง', 1), 
	 (N'ว่าที่ ร.ต.หม่อมราชวงศ์', 1), 
	 (N'ว่าที่ ร.ต.อ.', 1), 
	 (N'ว่าที่ ร.ท.', 1), 
	 (N'ว่าที่ ร.ท. น.พ.', 1), 
	 (N'ว่าที่ ร.ท.น.พ.', 1), 
	 (N'ว่าที่ ร.ท.นายแพทย์', 1), 
	 (N'ว่าที่ ร.อ.', 1), 
	 (N'ว่าที่ ร.อ. น.พ.', 1), 
	 (N'ว่าที่ ร.อ.น.พ.', 1), 
	 (N'ว่าที่ ร.อ.นายแพทย์', 1), 
	 (N'ว่าที่ ร้อยตรี', 1), 
	 (N'ว่าที่ ร้อยตรี ม.ร.ว.', 1), 
	 (N'ว่าที่ ร้อยตรี หม่อมราชวงศ์', 1), 
	 (N'ว่าที่ ร้อยตำรวจตรี', 1), 
	 (N'ว่าที่ ร้อยตำรวจโท', 1), 
	 (N'ว่าที่ ร้อยตำรวจเอก', 1), 
	 (N'ว่าที่ ร้อยโท', 1), 
	 (N'ว่าที่ ร้อยเอก', 1), 
	 (N'ว่าที่ เรือตรี', 1), 
	 (N'ว่าที่ เรือโท', 1), 
	 (N'ว่าที่ เรืออากาศตรี', 1), 
	 (N'ว่าที่ เรืออากาศโท', 1), 
	 (N'ว่าที่ เรืออากาศเอก', 1), 
	 (N'ว่าที่ เรือเอก', 1), 
	 (N'ว่าที่ ส.ต.', 1), 
	 (N'ว่าที่ ส.ท.', 1), 
	 (N'ว่าที่ ส.อ.', 1), 
	 (N'ว่าที่ สิบตรี', 1), 
	 (N'ว่าที่ สิบโท', 1), 
	 (N'ว่าที่ สิบเอก', 1), 
	 (N'ว่าที่. น.ต.', 1), 
	 (N'ว่าที่. น.ท.', 1), 
	 (N'ว่าที่. น.อ.', 1), 
	 (N'ว่าที่. น.อ. (พิเศษ)', 1), 
	 (N'ว่าที่. น.อ.(พิเศษ)', 1), 
	 (N'ว่าที่. น.อ.พิเศษ', 1), 
	 (N'ว่าที่. พ.ต.ต.', 1), 
	 (N'ว่าที่. พ.ต.ท.', 1), 
	 (N'ว่าที่. พ.ต.อ.', 1), 
	 (N'ว่าที่. พล.ร.ต.', 1), 
	 (N'ว่าที่. พล.ร.ท.', 1), 
	 (N'ว่าที่. พล.ร.อ.', 1), 
	 (N'ว่าที่. พล.อ.ต.', 1), 
	 (N'ว่าที่. พล.อ.ท.', 1), 
	 (N'ว่าที่. พล.อ.อ.', 1), 
	 (N'ว่าที่. ร.ต.', 1), 
	 (N'ว่าที่. ร.ต.ต.', 1), 
	 (N'ว่าที่. ร.ต.ท.', 1), 
	 (N'ว่าที่. ร.ต.อ.', 1), 
	 (N'ว่าที่. ร.ท.', 1), 
	 (N'ว่าที่. ร.อ.', 1), 
	 (N'ว่าที่. ส.ต.', 1), 
	 (N'ว่าที่. ส.ท.', 1), 
	 (N'ว่าที่. ส.อ.', 1), 
	 (N'ว่าที่.น.ต.', 1), 
	 (N'ว่าที่.น.ท.', 1), 
	 (N'ว่าที่.น.อ.', 1), 
	 (N'ว่าที่.น.อ. (พิเศษ)', 1), 
	 (N'ว่าที่.น.อ.(พิเศษ)', 1), 
	 (N'ว่าที่.น.อ.พิเศษ', 1), 
	 (N'ว่าที่.พ.ต.ต.', 1), 
	 (N'ว่าที่.พ.ต.ท.', 1), 
	 (N'ว่าที่.พ.ต.อ.', 1), 
	 (N'ว่าที่.พล.ร.ต.', 1), 
	 (N'ว่าที่.พล.ร.ท.', 1), 
	 (N'ว่าที่.พล.ร.อ.', 1), 
	 (N'ว่าที่.พล.อ.ต.', 1), 
	 (N'ว่าที่.พล.อ.ท.', 1), 
	 (N'ว่าที่.พล.อ.อ.', 1), 
	 (N'ว่าที่.ร.ต.', 1), 
	 (N'ว่าที่.ร.ต.ต.', 1), 
	 (N'ว่าที่.ร.ต.ท.', 1), 
	 (N'ว่าที่.ร.ต.อ.', 1), 
	 (N'ว่าที่.ร.ท.', 1), 
	 (N'ว่าที่.ร.อ.', 1), 
	 (N'ว่าที่.เรืออากาศตรี', 1), 
	 (N'ว่าที่.เรืออากาศโท', 1), 
	 (N'ว่าที่.เรืออากาศเอก', 1), 
	 (N'ว่าที่.ส.ต.', 1), 
	 (N'ว่าที่.ส.ท.', 1), 
	 (N'ว่าที่.ส.อ.', 1), 
	 (N'ว่าที่นาวาตรี', 1), 
	 (N'ว่าที่นาวาโท', 1), 
	 (N'ว่าที่นาวาอากาศตรี', 1), 
	 (N'ว่าที่นาวาอากาศโท', 1), 
	 (N'ว่าที่นาวาอากาศเอก', 1), 
	 (N'ว่าที่นาวาอากาศเอกพิเศษ', 1), 
	 (N'ว่าที่นาวาเอก', 1), 
	 (N'ว่าที่นาวาเอกพิเศษ', 1), 
	 (N'ว่าที่พ.อ.(พิเศษ)', 1), 
	 (N'ว่าที่พล.ต.จ', 1), 
	 (N'ว่าที่พล.ต.จ หญิง', 1), 
	 (N'ว่าที่พล.ต.จ.', 1), 
	 (N'ว่าที่พล.ต.จหญิง', 1), 
	 (N'ว่าที่พล.ต.ต', 1), 
	 (N'ว่าที่พล.ต.ต หญิง', 1), 
	 (N'ว่าที่พล.ต.ตหญิง', 1), 
	 (N'ว่าที่พล.ต.ท', 1), 
	 (N'ว่าที่พล.ต.ท หญิง', 1), 
	 (N'ว่าที่พล.ต.ทหญิง', 1), 
	 (N'ว่าที่พล.ต.อ', 1), 
	 (N'ว่าที่พล.ต.อ หญิง', 1), 
	 (N'ว่าที่พล.ต.อหญิง', 1), 
	 (N'ว่าที่พลตรี', 1), 
	 (N'ว่าที่พลตำรวจจัตวา', 1), 
	 (N'ว่าที่พลตำรวจจัตวาหญิง', 1), 
	 (N'ว่าที่พลตำรวจตรี', 1), 
	 (N'ว่าที่พลตำรวจตรีหญิง', 1), 
	 (N'ว่าที่พลตำรวจโท', 1), 
	 (N'ว่าที่พลตำรวจโทหญิง', 1), 
	 (N'ว่าที่พลตำรวจเอก', 1), 
	 (N'ว่าที่พลตำรวจเอกหญิง', 1), 
	 (N'ว่าที่พลโท', 1), 
	 (N'ว่าที่พลเรือตรี', 1), 
	 (N'ว่าที่พลเรือโท', 1), 
	 (N'ว่าที่พลเรือเอก', 1), 
	 (N'ว่าที่พลอากาศตรี', 1), 
	 (N'ว่าที่พลอากาศโท', 1), 
	 (N'ว่าที่พลอากาศเอก', 1), 
	 (N'ว่าที่พลเอก', 1), 
	 (N'ว่าที่พัน.ต.ต หญิง', 1), 
	 (N'ว่าที่พัน.ต.ต.หญิง', 1), 
	 (N'ว่าที่พัน.ต.ตหญิง', 1), 
	 (N'ว่าที่พัน.ต.ท หญิง', 1), 
	 (N'ว่าที่พัน.ต.ท.หญิง', 1), 
	 (N'ว่าที่พัน.ต.ทหญิง', 1), 
	 (N'ว่าที่พัน.ต.อ หญิง', 1), 
	 (N'ว่าที่พัน.ต.อ.หญิง', 1), 
	 (N'ว่าที่พัน.ต.อหญิง', 1), 
	 (N'ว่าที่พันตรี', 1), 
	 (N'ว่าที่พันตำรวจตรี', 1), 
	 (N'ว่าที่พันตำรวจตรี หญิง', 1), 
	 (N'ว่าที่พันตำรวจตรีหญิง', 1), 
	 (N'ว่าที่พันตำรวจโท', 1), 
	 (N'ว่าที่พันตำรวจโท หญิง', 1), 
	 (N'ว่าที่พันตำรวจโทหญิง', 1), 
	 (N'ว่าที่พันตำรวจเอก', 1), 
	 (N'ว่าที่พันตำรวจเอก หญิง', 1), 
	 (N'ว่าที่พันตำรวจเอก(พิเศษ)', 1), 
	 (N'ว่าที่พันตำรวจเอกหญิง', 1), 
	 (N'ว่าที่พันโท', 1), 
	 (N'ว่าที่พันเอก', 1), 
	 (N'ว่าที่พันเอกพิเศษ', 1), 
	 (N'ว่าที่ร.ต. ม.ร.ว.', 1), 
	 (N'ว่าที่ร.ต. หม่อมราชวงศ์', 1), 
	 (N'ว่าที่ร.ต.ม.ร.ว.', 1), 
	 (N'ว่าที่ร.ต.ม.ล.', 1), 
	 (N'ว่าที่ร.ต.หม่อมราชวงศ์', 1), 
	 (N'ว่าที่ร้อยตรี', 1), 
	 (N'ว่าที่ร้อยตรี น.พ.', 1), 
	 (N'ว่าที่ร้อยตรี นายแพทย์', 1), 
	 (N'ว่าที่ร้อยตรี ม.ร.ว.', 1), 
	 (N'ว่าที่ร้อยตรี หญิง', 1), 
	 (N'ว่าที่ร้อยตรี หม่อมราชวงศ์', 1), 
	 (N'ว่าที่ร้อยตรีนายแพทย์', 1), 
	 (N'ว่าที่ร้อยตรีหญิง', 1), 
	 (N'ว่าที่ร้อยตรีหม่อมราชวงศ์', 1), 
	 (N'ว่าที่ร้อยตรีหม่อมหลวง', 1), 
	 (N'ว่าที่ร้อยตำรวจตรี', 1), 
	 (N'ว่าที่ร้อยตำรวจโท', 1), 
	 (N'ว่าที่ร้อยตำรวจเอก', 1), 
	 (N'ว่าที่ร้อยโท', 1), 
	 (N'ว่าที่ร้อยโท น.พ.', 1), 
	 (N'ว่าที่ร้อยโท นายแพทย์', 1), 
	 (N'ว่าที่ร้อยโทนายแพทย์', 1), 
	 (N'ว่าที่ร้อยเอก', 1), 
	 (N'ว่าที่ร้อยเอก น.พ.', 1), 
	 (N'ว่าที่ร้อยเอก นายแพทย์', 1), 
	 (N'ว่าที่ร้อยเอกนายแพทย์', 1), 
	 (N'ว่าที่เรือตรี', 1), 
	 (N'ว่าที่เรือโท', 1), 
	 (N'ว่าที่เรืออากาศตรี', 1), 
	 (N'ว่าที่เรืออากาศโท', 1), 
	 (N'ว่าที่เรืออากาศเอก', 1), 
	 (N'ว่าที่เรือเอก', 1), 
	 (N'ว่าที่สิบตรี', 1), 
	 (N'ว่าที่สิบโท', 1), 
	 (N'ว่าที่สิบเอก', 1), 
	 (N'ศ. ดร.', 1), 
	 (N'ศ. ดอกเตอร์', 1), 
	 (N'ศ.ดร.', 1), 
	 (N'ศ.ดอกเตอร์', 1), 
	 (N'ศจ.', 1), 
	 (N'ศจ. คุณหญิง', 2), 
	 (N'ศจ. น.พ.', 1), 
	 (N'ศจ. น.พ. พ.ต.อ.', 1), 
	 (N'ศจ. น.พ. พันตำรวจเอก', 1), 
	 (N'ศจ. น.พ.พ.ต.อ.', 1), 
	 (N'ศจ. น.พ.พันตำรวจเอก', 1), 
	 (N'ศจ. นายแพทย์', 1), 
	 (N'ศจ. นายแพทย์ พันตำรวจเอก', 1), 
	 (N'ศจ. นายแพทย์พันตำรวจเอก', 1), 
	 (N'ศจ. พ.ต.', 1), 
	 (N'ศจ. พ.ท.', 1), 
	 (N'ศจ. พ.อ.', 1), 
	 (N'ศจ. พันตรี', 1), 
	 (N'ศจ. พันโท', 1), 
	 (N'ศจ. พันเอก', 1), 
	 (N'ศจ. ร.ต.', 1), 
	 (N'ศจ. ร.ท.', 1), 
	 (N'ศจ. ร.อ.', 1), 
	 (N'ศจ. ร้อยตรี', 1), 
	 (N'ศจ. ร้อยโท', 1), 
	 (N'ศจ. ร้อยเอก', 1), 
	 (N'ศจ.คุณหญิง', 2), 
	 (N'ศจ.น.พ.', 1), 
	 (N'ศจ.น.พ.พ.ต.อ.', 1), 
	 (N'ศจ.น.พ.พันตำรวจเอก', 1), 
	 (N'ศจ.พ.ต.', 1), 
	 (N'ศจ.พ.ท.', 1), 
	 (N'ศจ.พ.อ.', 1), 
	 (N'ศจ.พันตรี', 1), 
	 (N'ศจ.พันโท', 1), 
	 (N'ศจ.พันเอก', 1), 
	 (N'ศจ.ร.ต.', 1), 
	 (N'ศจ.ร.ท.', 1), 
	 (N'ศจ.ร.อ.', 1), 
	 (N'ศจ.ร้อยตรี', 1), 
	 (N'ศจ.ร้อยโท', 1), 
	 (N'ศจ.ร้อยเอก', 1), 
	 (N'ศาสตราจารย์', 1), 
	 (N'ศาสตราจารย์ คุณหญิง', 2), 
	 (N'ศาสตราจารย์ น.พ.', 1), 
	 (N'ศาสตราจารย์ น.พ. พ.ต.อ.', 1), 
	 (N'ศาสตราจารย์ น.พ. พันตำรวจเอก', 1), 
	 (N'ศาสตราจารย์ น.พ.พ.ต.อ.', 1), 
	 (N'ศาสตราจารย์ น.พ.พันตำรวจเอก', 1), 
	 (N'ศาสตราจารย์ นายแพทย์', 1), 
	 (N'ศาสตราจารย์ นายแพทย์พันตำรวจเอก', 1), 
	 (N'ศาสตราจารย์ พ.ต.', 1), 
	 (N'ศาสตราจารย์ พ.ท.', 1), 
	 (N'ศาสตราจารย์ พ.อ.', 1), 
	 (N'ศาสตราจารย์ พันตรี', 1), 
	 (N'ศาสตราจารย์ พันโท', 1), 
	 (N'ศาสตราจารย์ พันเอก', 1), 
	 (N'ศาสตราจารย์ ร.ต.', 1), 
	 (N'ศาสตราจารย์ ร.ท.', 1), 
	 (N'ศาสตราจารย์ ร.อ.', 1), 
	 (N'ศาสตราจารย์ ร้อยตรี', 1), 
	 (N'ศาสตราจารย์ ร้อยโท', 1), 
	 (N'ศาสตราจารย์ ร้อยเอก', 1), 
	 (N'ศาสตราจารย์คุณหญิง', 2), 
	 (N'ศาสตราจารย์ดอกเตอร์', 1), 
	 (N'ศาสตราจารย์นายแพทย์', 1), 
	 (N'ศาสตราจารย์นายแพทย์พันตำรวจเอก', 1), 
	 (N'ศาสตราจารย์พันตรี', 1), 
	 (N'ศาสตราจารย์พันโท', 1), 
	 (N'ศาสตราจารย์พันเอก', 1), 
	 (N'ศาสตราจารย์ร้อยตรี', 1), 
	 (N'ศาสตราจารย์ร้อยโท', 1), 
	 (N'ศาสตราจารย์ร้อยเอก', 1), 
	 (N'ส.ณ.', 1), 
	 (N'ส.ต.', 1), 
	 (N'ส.ต. ม.ร.ว.', 1), 
	 (N'ส.ต.ต.', 1), 
	 (N'ส.ต.ต. หญิง', 2), 
	 (N'ส.ต.ต.หญิง', 2), 
	 (N'ส.ต.ท.', 1), 
	 (N'ส.ต.ท. หญิง', 2), 
	 (N'ส.ต.ท.หญิง', 2), 
	 (N'ส.ต.ม.ร.ว.', 1), 
	 (N'ส.ต.หม่อมราชวงศ์', 1), 
	 (N'ส.ต.อ.', 1), 
	 (N'ส.ต.อ. หญิง', 2), 
	 (N'ส.ต.อ.ม.ล.', 1), 
	 (N'ส.ต.อ.หญิง', 2), 
	 (N'ส.ท.', 1), 
	 (N'ส.ท. ม.ร.ว.', 1), 
	 (N'ส.ท. หม่อมราชวงศ์', 1), 
	 (N'ส.ท.ม.ร.ว.', 1), 
	 (N'ส.ท.ม.ล.', 1), 
	 (N'ส.ห.', 1), 
	 (N'ส.อ.', 1), 
	 (N'ส.อ. ม.ร.ว.', 1), 
	 (N'ส.อ.ม.ร.ว.', 1), 
	 (N'ส.อ.ม.ล.', 1), 
	 (N'ส.อ.หม่อมราชวงศ์', 1), 
	 (N'สญ.', 2), 
	 (N'สพ.', 1), 
	 (N'สมเด็จเจ้า', 1), 
	 (N'สมเด็จเจ้าฟ้า', 1), 
	 (N'สมเด็จพระ', 1), 
	 (N'สมเด็จพระเจ้าพี่นางเธอเจ้าฟ้า', 2), 
	 (N'สมเด็จพระเจ้าภคินีเธอ', 2), 
	 (N'สมเด็จพระเจ้าลูกเธอ', 1), 
	 (N'สมเด็จพระเจ้าลูกยาเธอ', 2), 
	 (N'สมเด็จพระนางเจ้า', 2), 
	 (N'สมเด็จพระมหาวีรวงศ์', 1), 
	 (N'สมเด็จพระราชชนนี', 2), 
	 (N'สมเด็จพระราชาคณะ', 1), 
	 (N'สมเด็จพระศรีนครินทราบรมราชชนนี', 2), 
	 (N'สมเด็จพระสังฆราช', 1), 
	 (N'สมเด็จพระสังฆราชเจ้า', 1), 
	 (N'สมเด็จพระอริยวงศาคตญาณ', 1), 
	 (N'สมาชิก อส.', 1), 
	 (N'สมาชิกตรี', 1), 
	 (N'สมาชิกโท', 1), 
	 (N'สมาชิกอาสารักษาดินแดน', 1), 
	 (N'สมาชิกเอก', 1), 
	 (N'สัตวแพทย์', 1), 
	 (N'สัตวแพทย์ หญิง', 2), 
	 (N'สัตวแพทย์หญิง', 2), 
	 (N'สามเณร', 1), 
	 (N'สารวัตรทหาร', 1), 
	 (N'สิบตรี', 1), 
	 (N'สิบตรี ม.ร.ว.', 1), 
	 (N'สิบตรี หม่อมราชวงศ์', 1), 
	 (N'สิบตรีหม่อมราชวงศ์', 1), 
	 (N'สิบตำรวจตรี', 1), 
	 (N'สิบตำรวจตรี หญิง', 2), 
	 (N'สิบตำรวจตรีหญิง', 2), 
	 (N'สิบตำรวจโท', 1), 
	 (N'สิบตำรวจโท หญิง', 2), 
	 (N'สิบตำรวจโทหญิง', 2), 
	 (N'สิบตำรวจเอก', 1), 
	 (N'สิบตำรวจเอก หญิง', 2), 
	 (N'สิบตำรวจเอกหญิง', 2), 
	 (N'สิบตำรวจเอกหม่อมหลวง', 1), 
	 (N'สิบโท', 1), 
	 (N'สิบโท ม.ร.ว.', 1), 
	 (N'สิบโท หม่อมราชวงศ์', 1), 
	 (N'สิบโทหม่อมราชวงศ์', 1), 
	 (N'สิบโทหม่อมหลวง', 1), 
	 (N'สิบเอก', 1), 
	 (N'สิบเอก ม.ร.ว.', 1), 
	 (N'สิบเอก หม่อมราชวงศ์', 1), 
	 (N'สิบเอกหม่อมราชวงศ์', 1), 
	 (N'สิบเอกหม่อมหลวง', 1), 
	 (N'เสด็จเจ้า', 1), 
	 (N'หม่อม', 1), 
	 (N'หม่อมเจ้า', 1), 
	 (N'หม่อมเจ้าหญิง', 2), 
	 (N'หม่อมราชวงศ์', 1), 
	 (N'หม่อมหลวง', 1), 
	 (N'หมื่น', 1), 
	 (N'หลวง', 1), 
	 (N'องสุตบทบวร', 1), 
	 (N'อส.', 1), 
	 (N'อส.ทพ.', 1), 
	 (N'อาสาสมัครทหารพราน', 1), 
	 (N'เอกอัครราชฑูต', 1),
     (N'ผศ.ดร.', 1);
GO



/*********** Script Update Date: 2022-11-20  ***********/
INSERT INTO MGender(GenderId, [Description]) VALUES(0, N'ไม่ระบุ');
INSERT INTO MGender(GenderId, [Description]) VALUES(1, N'ชาย');
INSERT INTO MGender(GenderId, [Description]) VALUES(2, N'หญิง');
GO


/*********** Script Update Date: 2022-11-20  ***********/
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(0, N'ไม่ระบุ', 0, 1);
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(1, N'ต่ำกว่าปริญญาตรี', 1, 1);
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(2, N'ปริญญาตรี', 2, 1);
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(3, N'ปริญญาโท', 3, 1);
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(4, N'ปริญญาเอก', 4, 1);
GO


/*********** Script Update Date: 2022-11-20  ***********/
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(1, N'ข้าราชการ/พนักงาน/เจ้าหน้าที่ ของรัฐ', 1, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(2, N'ข้าราชการการเมือง/นักการเมือง', 2, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(3, N'ข้าราชการส่วนท้องถิ่น', 3, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(4, N'ข้าราชการบำนาญ', 4, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(5, N'ครู/อาจารย์/นักวิชาการ', 5, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(6, N'แพทย์', 6, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(7, N'ทนายความ/นักกฎหมาย', 7, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(8, N'ธุรกิจส่วนตัว/ค้าขาย', 8, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(9, N'ผู้บริหาร/พนักงาน/ลูกจ้าง ภาคเอกชน', 9, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(10, N'รัฐวิสาหกิจ', 10, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(11, N'เกษตรกร', 11, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(12, N'รับจ้างอิสระ', 12, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(13, N'วิชาชีพ', 13, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(14, N'ที่ปรึกษา', 14, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(15, N'อื่นๆ', 15, 1);
GO


/*********** Script Update Date: 2022-11-20  ***********/
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(1, 15, 24,  N'ต่ำกว่า 25 ปี',  1, 0);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(2, 25, 30,  N'25 - 30 ปี',   2, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(3, 31, 40,  N'31 - 40 ปี',   3, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(4, 41, 50,  N'41 - 50 ปี',   4, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(5, 51, 60,  N'51 - 60 ปี',   5, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(6, 61, 70,  N'61 - 70 ปี',   6, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(7, 71, 80,  N'71 - 80 ปี',   7, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(8, 81, 150, N'มากกว่า 80 ปี', 8, 1);
GO


/*********** Script Update Date: 2022-11-20  ***********/
EXEC SaveMRegion N'01', N'ภาค 1', N'กลาง', N'กลาง';
EXEC SaveMRegion N'02', N'ภาค 2', N'ตะวันออก', N'ตะวันออก';
EXEC SaveMRegion N'03', N'ภาค 3', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนล่าง';
EXEC SaveMRegion N'04', N'ภาค 4', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนบน';
EXEC SaveMRegion N'05', N'ภาค 5', N'เหนือ', N'เหนือตอนบน';
EXEC SaveMRegion N'06', N'ภาค 6', N'เหนือ', N'เหนือตอนล่าง';
EXEC SaveMRegion N'07', N'ภาค 7', N'ตะวันตก', N'ตะวันตก';
EXEC SaveMRegion N'08', N'ภาค 8', N'ใต้', N'ใต้ตอนบน';
EXEC SaveMRegion N'09', N'ภาค 9', N'ใต้', N'ใต้ตอนล่าง';
EXEC SaveMRegion N'10', N'ภาค 10', N'กลาง', N'กรุงเทพมหานคร';
GO

