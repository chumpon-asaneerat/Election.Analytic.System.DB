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
-- =============================================
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

		SELECT @PartyId = PartyId 
		  FROM MParty
		 WHERE UPPER(LTRIM(RTRIM(PartyName))) = UPPER(LTRIM(RTRIM(@PartyName)))

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

		SELECT @PersonId = PersonId 
		  FROM MPerson
		 WHERE UPPER(LTRIM(RTRIM(FirstName))) = UPPER(LTRIM(RTRIM(@FirstName)))
           AND UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@LastName)))

		IF (@PersonId IS NULL)
		BEGIN
			SET @errNum = 103;
			SET @errMsg = 'Cannot PersonId.';
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
