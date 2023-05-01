/*********** Script Update Date: 2023-05-01  ***********/
/****** MPDCOfficial ******/ 
CREATE TABLE MPDCOfficial (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	RevoteNo int NOT NULL,
	PartyId int NOT NULL,
	PersonId int NOT NULL,
    SortOrder int NOT NULL,
	VoteCount int NOT NULL,
    CONSTRAINT PK_MPDCOfficial PRIMARY KEY 
    (
        ThaiYear ASC
      , ADM1Code ASC
      , PollingUnitNo ASC
      , RevoteNo ASC
      , PartyId ASC
    )
)
GO

CREATE INDEX IX_MMPDCOfficial_ThaiYear ON MPDCOfficial(ThaiYear ASC)
GO

CREATE INDEX IX_MPDCOfficial_ADM1Code ON MPDCOfficial(ADM1Code ASC)
GO

CREATE INDEX IX_MPDCOfficial_PollingUnitNo ON MPDCOfficial(PollingUnitNo ASC)
GO

CREATE INDEX IX_MPDCOfficial_RevoteNo ON MPDCOfficial(RevoteNo ASC)
GO

CREATE INDEX IX_MPDCOfficial_PartyId ON MPDCOfficial(PartyId ASC)
GO

CREATE INDEX IX_MPDCOfficial_PersonId ON MPDCOfficial(PersonId ASC)
GO

CREATE INDEX IX_MPDCOfficial_SortOrder ON MPDCOfficial(SortOrder ASC)
GO

ALTER TABLE MPDCOfficial ADD  CONSTRAINT DF_MPDCOfficial_SortOrder  DEFAULT 0 FOR SortOrder
GO

ALTER TABLE MPDCOfficial ADD  CONSTRAINT DF_MPDCOfficial_RevoteNo  DEFAULT 0 FOR RevoteNo
GO

ALTER TABLE MPDCOfficial ADD  CONSTRAINT DF_MPDCOfficial_VoteCount  DEFAULT 0 FOR VoteCount
GO


/*********** Script Update Date: 2023-05-01  ***********/
/****** Object:  View [dbo].[MPDCOfficialView]    Script Date: 11/26/2022 1:56:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********** Script Update Date: 2022-10-09  ***********/
CREATE VIEW [dbo].[MPDCOfficialView]
AS
    SELECT ROW_NUMBER() OVER
		   (
			   ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo, VoteCount DESC, SortOrder ASC
		   ) AS RowNo
		 , ROW_NUMBER() OVER
		   (
		       PARTITION BY ThaiYear, ProvinceNameTH, PollingUnitNo
			   ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo, VoteCount DESC, SortOrder ASC
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
	     , A.RevoteNo
	     , A.SortOrder
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
	  FROM MPDCOfficial A 
        LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code
        LEFT OUTER JOIN MParty C ON C.PartyId = A.PartyId
        LEFT OUTER JOIN MPerson D ON D.PersonId = A.PersonId

GO


/*********** Script Update Date: 2023-05-01  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPDCOfficial]    Script Date: 11/26/2022 3:17:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPDCOfficial
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
-- DECLARE @PartyName nvarchar(200)
-- DECLARE @FullName nvarchar(max)
-- DECLARE @SortOrder int
-- DECLARE @VoteCount int
-- DECLARE @RevoteNo int
-- 
-- SET @ProvinceName = N'เชียงใหม่'
-- SET @PollingUnitNo = 1
-- SET @PartyName = N'เพื่อไทย'
-- SET @FullName = N'นางสาว ทัศนีย์ บูรณุปกรณ์'
-- SET @SortOrder = 1
-- SET @VoteCount = 0
-- SET @RevoteNo = 0
-- 
-- EXEC ImportMPDCOfficial 2566
--                         , @ProvinceName, @PollingUnitNo
-- 						   , @PartyName, @FullName
--                         , @SortOrder
-- 						   , @VoteCount
-- 						   , @RevoteNo
-- 						   , @errNum out, @errMsg out
-- SELECT @errNum as ErrNum, @errMsg as ErrMsg
-- 
-- -- =============================================
CREATE PROCEDURE [dbo].[ImportMPDCOfficial] (
  @ThaiYear int    
, @ProvinceNameTH nvarchar(200)
, @PollingUnitNo int
, @PartyName nvarchar(200)
, @FullName nvarchar(MAX)
, @SortOrder int
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

        IF (@Prefix IS NOT NULL)
        BEGIN
            SELECT @GenderId = dbo.GetGenderFromTitle(@Prefix)
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
			    FROM MPDCOfficial
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
                 AND RevoteNo = @RevoteNo
                 AND PartyId = @PartyId
           ))
		BEGIN
			  UPDATE MPDCOfficial
			     SET  PersonId = @PersonId
                    , SortOrder = @SortOrder
                    , VoteCount = COALESCE(@VoteCount, VoteCount)
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
                 AND RevoteNo = @RevoteNo
                 AND PartyId = @PartyId
		END
        ELSE
        BEGIN
            INSERT INTO MPDCOfficial
            (
                  ThaiYear
                , ADM1Code
                , PollingUnitNo
                , PartyId
                , PersonId
                , SortOrder
                , RevoteNo
                , VoteCount
            )
            VALUES
            (
                  @ThaiYear
                , LTRIM(RTRIM(@ADM1Code))
                , @PollingUnitNo
                , @PartyId
                , @PersonId
                , @SortOrder
                , @RevoteNo
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


/*********** Script Update Date: 2023-05-01  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDCOfficials]    Script Date: 12/2/2022 5:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCOfficials
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
CREATE PROCEDURE [dbo].[GetMPDCOfficials]
(
  @ThaiYear int
, @RegionId nvarchar(20) = NULL
, @RegionName nvarchar(200) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
, @PartyName nvarchar(200) = NULL
, @FullName nvarchar(MAX) = NULL
)
AS
BEGIN
    ;WITH MPDCOFF
    AS
    -- Define the Vote Summary by Province and PollingUnit query.
    (
        SELECT RowNo
		     , RankNo
			 , ThaiYear
			 , ADM1Code 
			 , PollingUnitNo
			 , SortOrder
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
          FROM MPDCOfficialView
         WHERE ThaiYear = @ThaiYear
		   AND UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
		   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
		   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
		   AND UPPER(LTRIM(RTRIM(PartyName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@PartyName, PartyName)))) + '%'
		   AND (
                    FullName IS NULL
                 OR UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
               )
    )
    SELECT * 
      FROM MPDCOFF 
     ORDER BY ProvinceNameTH, PollingUnitNo, VoteCount DESC, SortOrder

END

GO


/*********** Script Update Date: 2023-05-01  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDCOfficialByFullName]    Script Date: 12/14/2022 11:54:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCOfficialByFullName
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCOfficialByFullName]
(
  @ThaiYear int
, @FullName nvarchar(200) = NULL
)
AS
BEGIN
    ;WITH MPDCOFF_A
    AS
    (
        SELECT ThaiYear, ProvinceNameTH, PollingUnitNo 
          FROM MPDCOfficialView 
         WHERE ThaiYear = @ThaiYear
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ),
    MPDCOFF_B
    AS
    -- Find the Vote Summary by Province and PollingUnit query.
    (
        SELECT ROW_NUMBER() OVER(ORDER BY A.VoteCount DESC) AS RowNo
				, A.ThaiYear
				, A.RegionId
				, A.RegionName
				, A.GeoGroup
				, A.GeoSubGroup
                , A.ADM1Code
                , A.ProvinceNameTH
                , A.ProvinceNameEN
                , A.ProvinceId
				, A.PollingUnitNo
				, A.SortOrder
				, A.RevoteNo
				, A.RankNo 
				, A.VoteCount
				, A.PartyId
				, A.PartyName
				, A.PartyImageData
				, A.PersonId
				, A.Prefix
				, A.FirstName
				, A.LastName
				, A.FullName
				, A.PersonImageData
				, A.PersonRemark
				, A.DOB
				, A.GenderId
				--, A.GenderName
				, A.EducationId
				--, A.EducationName
				, A.OccupationId
				--, A.OccupationName
            FROM MPDCOfficialView A JOIN MPDCOFF_A B
            ON (
                    A.ThaiYear = B.ThaiYear
		        AND UPPER(LTRIM(RTRIM(A.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(B.ProvinceNameTH)))
                AND A.PollingUnitNo = B.PollingUnitNo
                )
    )
    SELECT * FROM MPDCOFF_B
        WHERE ThaiYear = @ThaiYear
		  AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ORDER BY ProvinceNameTH, PollingUnitNo, VoteCount DESC

END

GO


/*********** Script Update Date: 2023-05-01  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDCOfficialTopVoteSummaries]    Script Date: 12/13/2022 1:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCOfficialTopVoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCOfficialTopVoteSummaries]
(
  @ThaiYear int
, @PrevThaiYear int
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @Top int = 6
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    ;WITH Top6VoteSum66 AS
    (
        SELECT A.ThaiYear
		     , A.ProvinceId
             , A.ADM1Code
             , A.ProvinceNameTH
             , A.PollingUnitNo
             , A.FullName
             , A.PartyName
             , A.PartyId
             , A.PartyImageData
             , A.PersonId
             , A.PersonImageData
             , A.RankNo
             , A.VoteCount
             , A.SortOrder
			 , B.ADM1Code AS PrevADM1Code
			 , B.ProvinceNameTH AS PrevProvinceNameTH
			 , B.PollingUnitNo AS PrevPollingUnitNo
			 , B.PartyId AS PrevPartyId
			 , B.PartyName AS PrevPartyName
			 , B.VoteCount AS PrevVoteCount
			 , B.RankNo AS PrevRankNo
          FROM MPDCOfficialView A LEFT OUTER JOIN MPDVoteSummaryView B 
		    ON B.PersonId = A.PersonId AND B.ThaiYear = ' + CONVERT(nvarchar, @PrevThaiYear) + '
		 WHERE A.ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + '
    )
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' *
      FROM Top6VoteSum66
     WHERE ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + '
       AND ADM1Code = N''' + @ADM1Code + '''
       AND PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
     ORDER BY VoteCount DESC, SortOrder ASC
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO


/*********** Script Update Date: 2023-05-01  ***********/
-- RE INSERT
IF NOT EXISTS (SELECT * FROM MTitle WHERE [Description] = N'คุณ')
BEGIN
    INSERT INTO MTitle ([Description], GenderId) VALUES (N'คุณ', 0)
END

GO

