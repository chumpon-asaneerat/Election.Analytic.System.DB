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
ALTER PROCEDURE [dbo].[GetPollingUnits]
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


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetPollingUnit]    Script Date: 11/26/2022 3:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPollingUnit
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPollingUnit]
(
  @ThaiYear int = NULL
, @ADM1Code nvarchar(20) = NULL
, @PollingUnitNo int = NULL
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
       AND UPPER(LTRIM(RTRIM(PollingUnitNo))) = UPPER(LTRIM(RTRIM(COALESCE(@PollingUnitNo, PollingUnitNo))))
	 ORDER BY ThaiYear, RegionId, RegionName, ProvinceNameTH

END

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
         , D.OccupationId
         , G.[Description] AS OccupationName
         , F.[Description] AS EducationDescription
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
ALTER PROCEDURE [dbo].[GetMPersons]
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
		 WHERE (
                    UPPER(RTRIM(LTRIM(Prefix))) LIKE '%' + COALESCE(@Prefix, N'') + '%'
                 OR Prefix IS NULL
               )
           AND UPPER(RTRIM(LTRIM(FirstName))) LIKE '%' + COALESCE(@FirstName, N'') + '%'
           AND UPPER(RTRIM(LTRIM(LastName))) LIKE '%' + COALESCE(@LastName, N'') + '%'

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
		     WHERE (    UPPER(RTRIM(LTRIM(Prefix))) LIKE '%' + COALESCE(@Prefix, N'') + '%'
                     OR Prefix IS NULL
                   )
               AND UPPER(RTRIM(LTRIM(FirstName))) LIKE '%' + COALESCE(@FirstName, N'') + '%'
               AND UPPER(RTRIM(LTRIM(LastName))) LIKE '%' + COALESCE(@LastName, N'') + '%'
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


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPDC2]    Script Date: 12/2/2022 7:20:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPDC2
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
CREATE PROCEDURE [dbo].[SaveMPDC2] (
  @ThaiYear int    
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @CandidateNo int
, @PersonId int
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
DECLARE @SkipNo int
DECLARE @iCnt int
DECLARE @iMaxCandidateNo int
	BEGIN TRY
		IF (@ThaiYear IS NULL 
		 OR @ADM1Code IS NULL 
		 OR @PollingUnitNo IS NULL 
		 OR @PollingUnitNo < 1 
		 OR @CandidateNo IS NULL
		 OR @PersonId IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
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
, @EducationLevel nvarchar(max) = null
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
DECLARE @EducationId int = null;
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

        IF (@EducationLevel IS NOT NULL)
        BEGIN
            SELECT @EducationId = EducationId 
              FROM MEducation
             WHERE UPPER(LTRIM(RTRIM([Description]))) = UPPER(LTRIM(RTRIM(@EducationLevel)))
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


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDCs]    Script Date: 12/13/2022 8:35:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCs
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
-- <2022-10-07> :
--	- Supports Paging.
-- <2022-10-09> :
--	- Add FullNamne parameter.
-- <2022-10-30> :
--	- Change logic.
--	- Remove Paging.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCs]
(
  @ThaiYear int
, @ProvinceNameTH nvarchar(200) = NULL
, @PollingUnitNo as int = NULL
, @FullName nvarchar(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @sFullName nvarchar(MAX)
	BEGIN TRY
	    IF (@FullName IS NULL)
		BEGIN
			SET @sFullName = N'';
		END
		ELSE 
		BEGIN
			SET @sFullName = @FullName;
		END

		SELECT ThaiYear
             , ProvinceNameTH
			 , ADM1Code
			 , PollingUnitNo
			 , CandidateNo
             , PersonId
			 , FullName
             , PrevPartyId
			 , PartyName AS PrevPartyName
			 , EducationDescription AS EducationName
			 , CandidateRemark
			 , CandidateSubGroup
			 , PersonImageData AS [Data]
             , ADM1Code AS ADM1CodeOri
             , PollingUnitNo AS PollingUnitNoOri
             , CandidateNo AS CandidateNoOri
             , FullName AS FullNameOri
		  FROM MPDCView 
		 WHERE ThaiYear = @ThaiYear
           AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
		   AND PollingUnitNo = COALESCE(@PollingUnitNo, PollingUnitNo)
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(@sFullName))) + '%'

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
/****** Object:  StoredProcedure [dbo].[GetMPDCPullingUnitsPaging]    Script Date: 12/14/2022 10:19:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCPullingUnitsPaging
-- [== History ==]
-- <2022-10-20> :
--	- Stored Procedure created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCPullingUnitsPaging]
(
  @ThaiYear int
, @ProvinceName nvarchar(200) = NULL
, @FullName nvarchar(MAX) = NULL
, @pageNum as int = 1 out
, @rowsPerPage as int = 4 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iTotalUnits int;
	BEGIN TRY
		-- calculate total polling units and max pages
		IF (@ProvinceName IS NULL AND @FullName IS NULL)
		BEGIN 
		    -- ALL MODE
			SELECT @iTotalUnits = COUNT(*) 
			  FROM PollingUnitView
			 WHERE ThaiYear = @ThaiYear
			   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))

			SELECT @maxPage = 
				   CASE WHEN (@iTotalUnits % @rowsPerPage > 0) THEN 
						(@iTotalUnits / @rowsPerPage) + 1
				   ELSE 
						(@iTotalUnits / @rowsPerPage)
			END;

			;WITH PollUnits AS
			(
				SELECT DISTINCT ThaiYear
				     , ProvinceNameTH
					 , PollingUnitNo 
				  FROM PollingUnitView
				 WHERE ThaiYear = @ThaiYear
				   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
			), SQLPaging AS
			(
				SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo) AS RowNo
					 , ThaiYear
					 , ProvinceNameTH
					 , PollingUnitNo
				  FROM PollUnits 
			)
			-- SELECT OUTPUT QUERY
			SELECT M.ThaiYear
			     , M.ProvinceNameTH
				 , M.PollingUnitNo
				 , COUNT(A.CandidateNo) AS TotalCandidates
				 , @FullName AS FullNameFilter
			  FROM SQLPaging M WITH (NOLOCK)
				   LEFT OUTER JOIN MPDCView A ON 
				   (
				         A.ThaiYear = @ThaiYear
				     AND A.ProvinceNameTH = M.ProvinceNameTH
					 AND A.PollingUnitNo = M.PollingUnitNo
				   )
			 WHERE RowNo > ((@pageNum - 1) * @rowsPerPage)
			 GROUP BY M.ThaiYear, M.ProvinceNameTH, M.PollingUnitNo
		END
		ELSE
		BEGIN
		    -- FILTER MODE
			IF (@FullName IS NULL)
			BEGIN
				-- NEED TO CHECK HAS CANDIDATE ON SPECIFICED PROVINCE
				;WITH MPDCUnits AS
				(
					SELECT ProvinceNameTH, PollingUnitNo, COUNT(PollingUnitNo) CandidateCount
					  FROM MPDCView
					 WHERE ThaiYear = @ThaiYear
					   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
					 GROUP BY ProvinceNameTH, PollingUnitNo
				)
				-- COUNT TOTAL POLLING UNITS
				SELECT @iTotalUnits = COUNT(*) 
				  FROM MPDCUnits

				SELECT @maxPage = 
					   CASE WHEN (@iTotalUnits % @rowsPerPage > 0) THEN 
							(@iTotalUnits / @rowsPerPage) + 1
					   ELSE 
							(@iTotalUnits / @rowsPerPage)
				END;

				;WITH PollUnits AS
				(
					SELECT DISTINCT ThaiYear
						 , ProvinceNameTH
						 , PollingUnitNo 
					  FROM MPDCView
				     WHERE ThaiYear = @ThaiYear
					   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
				), SQLPaging AS
				(
					SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo) AS RowNo
						 , ThaiYear
						 , ProvinceNameTH
						 , PollingUnitNo
					  FROM PollUnits
				)
				-- SELECT OUTPUT QUERY
				SELECT M.ThaiYear
					 , M.ProvinceNameTH
					 , M.PollingUnitNo
					 , COUNT(A.CandidateNo) AS TotalCandidates
					 , @FullName AS FullNameFilter
				  FROM SQLPaging M WITH (NOLOCK)
					   LEFT OUTER JOIN MPDCView A ON 
					   (
							 A.ThaiYear = @ThaiYear
				         AND A.ProvinceNameTH = M.ProvinceNameTH
						 AND A.PollingUnitNo = M.PollingUnitNo
					   )
				 WHERE RowNo > ((@pageNum - 1) * @rowsPerPage)
				 GROUP BY M.ThaiYear, M.ProvinceNameTH, M.PollingUnitNo
			END
			ELSE
			BEGIN
				SELECT @iTotalUnits = COUNT(*) 
				  FROM MPDCView
				 WHERE ThaiYear = @ThaiYear
				   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
				   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM((@FullName)))) + '%'

				SELECT @maxPage = 
					   CASE WHEN (@iTotalUnits % @rowsPerPage > 0) THEN 
							(@iTotalUnits / @rowsPerPage) + 1
					   ELSE 
							(@iTotalUnits / @rowsPerPage)
				END;

				;WITH PollUnits AS
				(
					SELECT DISTINCT ThaiYear
						 , ProvinceNameTH
						 , PollingUnitNo 
					  FROM MPDCView
				     WHERE ThaiYear = @ThaiYear
					   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
					   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(@FullName))) + '%'
				), SQLPaging AS
				(
					SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo) AS RowNo
						 , ThaiYear
						 , ProvinceNameTH
						 , PollingUnitNo
					  FROM PollUnits
				)
				-- SELECT OUTPUT QUERY
				SELECT M.ThaiYear
					 , M.ProvinceNameTH
					 , M.PollingUnitNo
					 , COUNT(A.CandidateNo) AS TotalCandidates
					 , @FullName AS FullNameFilter
				  FROM SQLPaging M WITH (NOLOCK)
					   LEFT OUTER JOIN MPDCView A ON 
					   (
							 A.ThaiYear = @ThaiYear
				         AND A.ProvinceNameTH = M.ProvinceNameTH
						 AND A.PollingUnitNo = M.PollingUnitNo
					   )
				 WHERE RowNo > ((@pageNum - 1) * @rowsPerPage)
				 GROUP BY M.ThaiYear, M.ProvinceNameTH, M.PollingUnitNo
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


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDCExports]    Script Date: 12/13/2022 8:35:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCExports
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
-- <2022-10-07> :
--	- Supports Paging.
-- <2022-10-09> :
--	- Add FullNamne parameter.
-- <2022-10-30> :
--	- Change logic.
--	- Remove Paging.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCExports]
(
  @ThaiYear int
, @ProvinceNameTH nvarchar(200) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
	BEGIN TRY
		SELECT ThaiYear
             , ProvinceNameTH
			 , ADM1Code
			 , PollingUnitNo
			 , CandidateNo
             , PersonId
			 , FullName
             , PrevPartyId
			 , PartyName AS PrevPartyName
			 , EducationName
			 , CandidateRemark
			 , CandidateSubGroup
		  FROM MPDCView 
		 WHERE ThaiYear = @ThaiYear
           AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
         ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo, CandidateNo

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
/****** Object:  StoredProcedure [dbo].[GetMPDTopVoteSummaries]    Script Date: 12/13/2022 1:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDTopVoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDTopVoteSummaries]
(
  @ThaiYear int
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @Top int = 6
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    ;WITH Top6VoteSum62 AS
    (
        SELECT ThaiYear
		     , ProvinceId
             , ADM1Code
             , ProvinceNameTH
             , PollingUnitNo
             , FullName
             , PartyName
             , PartyId
             , PartyImageData
             , PersonImageData
             , RankNo
             , VoteCount
          FROM MPDVoteSummaryView
		 WHERE ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + '
    )
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' *
      FROM Top6VoteSum62
     WHERE ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + '
       AND ADM1Code = N''' + @ADM1Code + '''
       AND PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
     ORDER BY VoteCount DESC
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDTotalVotes]    Script Date: 12/13/2022 2:01:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDTotalVotes
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDTotalVotes]
(
  @ThaiYear int
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
)
AS
BEGIN
    SELECT SUM(VoteCount) AS TotalVotes
      FROM MPDVoteSummaryView
     WHERE ThaiYear = @ThaiYear
       AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
       AND PollingUnitNo = @PollingUnitNo
END

GO


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDCSummaries]    Script Date: 12/14/2022 8:08:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCSummaries]
(
  @ThaiYear int
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @Top int = 4
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' 
           ThaiYear
         , ADM1Code
         , ProvinceNameTH AS ProvinceName
         , PollingUnitNo
         , FullName
         , PersonImageData AS PersonImageData
         , PrevPartyId AS PartyId
         , PartyName
         , PartyImageData
         , CandidateNo
         , DOB
         , EducationDescription AS EducationLevel
         , CandidateSubGroup AS SubGroup
         , CandidateRemark AS [Remark]
      FROM MPDCView
    WHERE ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + ' 
	  AND ADM1Code = N''' + @ADM1Code + '''
      AND PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
    ORDER BY CandidateNo
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO


/*********** Script Update Date: 2022-12-06  ***********/
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
ALTER PROCEDURE [dbo].[GetMPDStatVoterSummaries]
(
  @ThaiYear int
, @ProvinceNameTH nvarchar(200) = NULL
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
     WHERE ThaiYear = COALESCE(@ThaiYear, ThaiYear)
       AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
     ORDER BY ProvinceNameTH, PollingUnitNo
END

GO


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDStatVoterSummary]    Script Date: 12/4/2022 7:46:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDStatVoterSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDStatVoterSummary]
(
  @ThaiYear int
, @ADM1Code nvarchar(20) = NULL
, @PollingUnitNo int = NULL
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
     WHERE ThaiYear = COALESCE(@ThaiYear, ThaiYear)
       AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
       AND PollingUnitNo = COALESCE(@PollingUnitNo, PollingUnitNo)
     ORDER BY ProvinceNameTH, PollingUnitNo
END

GO


/*********** Script Update Date: 2022-12-06  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDVoteSummaryByFullName]    Script Date: 12/14/2022 11:54:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDVoteSummaryByFullName
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDVoteSummaryByFullName]
(
  @ThaiYear int
, @FullName nvarchar(200) = NULL
)
AS
BEGIN
    ;WITH MPDVoteSum_A
    AS
    (
        SELECT ThaiYear, ProvinceNameTH, PollingUnitNo 
          FROM MPDVoteSummaryView 
         WHERE ThaiYear = @ThaiYear
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ),
    MPDVoteSum_B
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
				, A.CandidateNo
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
				, A.GenderName
				, A.EducationId
				, A.EducationName
				, A.OccupationId
				, A.OccupationName
            FROM MPDVoteSummaryView A JOIN MPDVoteSum_A B
            ON (
                    A.ThaiYear = B.ThaiYear
		        AND UPPER(LTRIM(RTRIM(A.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(B.ProvinceNameTH)))
                AND A.PollingUnitNo = B.PollingUnitNo
                )
    )
    SELECT * FROM MPDVoteSum_B
        WHERE ThaiYear = @ThaiYear
		  AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ORDER BY ProvinceNameTH, PollingUnitNo, VoteCount DESC

END

GO


/*********** Script Update Date: 2022-12-06  ***********/
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
CREATE PROCEDURE [dbo].[GetPollingUnitMenuItems]
(
  @RegionId nvarchar(20) = NULL
, @ADM1Code nvarchar(20) = NULL
)
AS
BEGIN
	SELECT MIN(ThaiYear) AS ThaiYear
	     , RegionId
		 , RegionName
		 , ADM1Code
		 , ProvinceNameTH
		 , PollingUnitNo
	  FROM PollingUnitView 
     WHERE UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
       AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	 GROUP BY RegionId, RegionName, ADM1Code, ProvinceNameTH, PollingUnitNo
END

GO

