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

CREATE UNIQUE INDEX IX_MDistrict_DistrictNameTH ON MDistrict(DistrictNameTH ASC)
GO

CREATE UNIQUE INDEX IX_MDistrict_DistrictNameEN ON MDistrict(DistrictNameEN ASC)
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

CREATE UNIQUE INDEX IX_MSubdistrict_SubdistrictNameTH ON MSubdistrict(SubdistrictNameTH ASC)
GO

CREATE UNIQUE INDEX IX_MSubdistrict_SubdistrictNameEN ON MSubdistrict(SubdistrictNameEN ASC)
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
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
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
	 (N'เอกอัครราชฑูต', 1);
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

