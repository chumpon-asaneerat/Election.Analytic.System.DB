/*********** Script Update Date: 2022-12-06  ***********/
DELETE FROM MTitle WHERE [Description] = N'คุณ';
GO


/*********** Script Update Date: 2022-12-06  ***********/
DROP PROCEDURE GetMParty
GO
DROP PROCEDURE GetMPerson
GO


/*********** Script Update Date: 2022-12-06  ***********/
INSERT INTO MTitle([Description], GenderId) VALUES(N'ดาบตำรวจ', 1);
INSERT INTO MTitle([Description], GenderId) VALUES(N'พันเอกหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'พันโทหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'พันตรีหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'ร้อยเอกหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'ร้อยโทหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'ร้อยตรีหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'นาวาอากาศเอกหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'นาวาอากาศโทหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'นาวาอากาศตรีหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'นาวาเอกหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'นาวาโทหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'นาวาตรีหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'พลตรีหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'พลโทหญิง', 2);
INSERT INTO MTitle([Description], GenderId) VALUES(N'พลเอกหญิง', 2);
GO


/*********** Script Update Date: 2022-12-06  ***********/
-- EducationId can be use from MPerson table.
ALTER TABLE MPDC DROP COLUMN EducationId
GO


/*********** Script Update Date: 2022-12-06  ***********/
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
ALTER VIEW [dbo].[MPDVoteSummaryView]
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
         , E.[Description] AS GenderName
         , D.EducationId
         , F.[Description] AS EducationName
         , D.OccupationId
         , G.[Description] AS OccupationName
         , D.[Remark] AS PersonRemark
         , D.[Data] AS PersonImageData
	     , A.VoteCount
	  FROM MPDVoteSummary A 
        LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code
        LEFT OUTER JOIN MParty C ON C.PartyId = A.PartyId
        LEFT OUTER JOIN MPerson D ON D.PersonId = A.PersonId
        LEFT OUTER JOIN MGender E ON E.GenderId = D.GenderId
        LEFT OUTER JOIN MEducation F ON F.EducationId = D.EducationId
        LEFT OUTER JOIN MOccupation G ON G.OccupationId = D.OccupationId

GO


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  View [dbo].[MPDCView]    Script Date: 11/26/2022 1:56:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MPDCView]
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
         , D.[Remark] AS PersonRemark
         , D.[Data] AS PersonImageData
         , A.PrevPartyId
         , C.PartyName
         , C.[Data] AS PartyImageData
         , D.GenderId
         , E.[Description] AS GenderName
         , D.EducationId
         , F.[Description] AS EducationName
         , D.OccupationId
         , G.[Description] AS OccupationName
         , E.[Description] AS EducationDescription
         , A.[Remark] AS CandidateRemark
         , A.SubGroup As CandidateSubGroup
	  FROM MPDC A
        LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code
        LEFT OUTER JOIN MParty C ON C.PartyId = A.PrevPartyId
        LEFT OUTER JOIN MPerson D ON D.PersonId = A.PersonId
        LEFT OUTER JOIN MGender E ON E.GenderId = D.GenderId
        LEFT OUTER JOIN MEducation F ON F.EducationId = D.EducationId
        LEFT OUTER JOIN MOccupation G ON G.OccupationId = D.OccupationId

GO


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  UserDefinedFunction [dbo].[GetGenderFromTitle]    Script Date: 11/26/2022 2:02:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetGenderFromTitle.
-- Description:	Find Gender Id from Title Description
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[GetGenderFromTitle](@Prefix nvarchar(MAX))
RETURNS int
AS
BEGIN
DECLARE @result int;
    IF (@Prefix IS NULL)
    BEGIN
        SET @result = NULL
    END
    ELSE
    BEGIN
        SELECT @result = GenderId 
          FROM MTitle
         WHERE UPPER(LTRIM(RTRIM([Description]))) = UPPER(LTRIM(RTRIM(@Prefix)))
    END

    RETURN @result;
END

GO


/*********** Script Update Date: 2022-12-06  ***********/
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
ALTER PROCEDURE [dbo].[SaveMPerson] (
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
DECLARE @matchPersonId int
DECLARE @matchGenderId int
	BEGIN TRY
        -- FIND ID
        IF (@PersonId IS NULL OR @PersonId <= 0)
        BEGIN
            SELECT @matchPersonId = PersonId 
                 , @matchGenderId = GenderId
              FROM MPerson 
             WHERE UPPER(LTRIM(RTRIM(FirstName))) = UPPER(LTRIM(RTRIM(@FirstName)))
               AND UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@LastName)))
            -- REPLACE ID IN CASE Person Full Name is EXISTS but not specificed Id when call this SP
            SET @PersonId = @matchPersonId
        END

        SELECT @matchGenderId = GenderId
          FROM MPerson 
         WHERE PersonId = @PersonId

        IF (@GenderId IS NULL OR @GenderId = 0) -- NULL OR NOT SPECIFICED GENDER
        BEGIN
            -- REPLACE ID IN CASE No GenderId but the EXISTS person already assign GenderId
            -- so need to preserve last GenderId
            SET @GenderId = @matchGenderId
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


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPartyById]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPartyById
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMPartyById] (
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


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPersonById]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPersonById
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMPersonById] (
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
             , A.[Data]
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


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPartyByName]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPartyByName
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMPartyByName] (
  @PartyName nvarchar(200)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
        SELECT PartyId
             , PartyName
             , [Data]
          FROM MParty
         WHERE UPPER(LTRIM(RTRIM(PartyName))) = UPPER(LTRIM(RTRIM(@PartyName)))

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


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPersonByName]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPersonByName
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMPersonByName] (
  @FirstName nvarchar(200)
, @LastName nvarchar(200)
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
             , A.[Data]
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
         WHERE UPPER(LTRIM(RTRIM(FirstName))) = UPPER(LTRIM(RTRIM(@FirstName)))
           AND UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@LastName)))

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


/*********** Script Update Date: 2022-12-06  ***********/
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
ALTER PROCEDURE [dbo].[ImportMPDVoteSummary] (
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


/*********** Script Update Date: 2022-12-06  ***********/
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
ALTER PROCEDURE [dbo].[ImportMPDC] (
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

        IF (@Prefix IS NOT NULL)
        BEGIN
            SELECT @GenderId = dbo.GetGenderFromTitle(@Prefix)
        END

        -- Call Save to get PersonId
        EXEC SaveMPerson @Prefix, @FirstName, @LastName
                       , NULL -- DOB
                       , @GenderId -- GenderId
                       , @EducationId -- EducationId
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


/*********** Script Update Date: 2022-12-06  ***********/
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
ALTER PROCEDURE [dbo].[SaveMPDC] (
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

