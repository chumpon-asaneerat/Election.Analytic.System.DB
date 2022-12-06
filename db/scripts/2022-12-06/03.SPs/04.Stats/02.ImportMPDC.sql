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
            SELECT @GenderId = GenderId FROM dbo.GetGenderFromTitle(@Prefix)
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
