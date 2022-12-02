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
		-- FIND PersonId
		SELECT @PersonId = PersonId
		  FROM MPerson
		 WHERE UPPER(LTRIM(RTRIM(FirstName))) = UPPER(LTRIM(RTRIM(@FirstName)))
		   AND UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@LastName)))
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
			-- NO PREVIOUS DATA
			IF (NOT EXISTS 
				(
					SELECT * 
					  FROM MPDC
					 WHERE ThaiYear = @ThaiYear
                       AND LTRIM(RTRIM(ADM1Code)) = LTRIM(RTRIM(@ADM1Code))
					   AND PollingUnitNo = @PollingUnitNo
					   AND PersonId = @PersonId
				)
			   )
			BEGIN
                -- NO PREVIOUS DATA AND PersonId not exists in Province, PollingUnitNo
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

                SELECT @iCnt = COUNT(CandidateNo) 
                  FROM MPDC
                 WHERE ThaiYear = @ThaiYear
                   AND LTRIM(RTRIM(ADM1Code)) = LTRIM(RTRIM(@ADM1Code))
                   AND PollingUnitNo = @PollingUnitNo

				IF (@iCnt > @CandidateNo)
			    BEGIN
                    -- REORDER PREVIOUS PROVINCE + POLLING UNIT
					SET @SkipNo = NULL
                    EXEC ReorderMPDC @ThaiYear, @ADM1CodeOri, @PollingUnitNoOri, @SkipNo
                    -- REORDER NEW PROVINCE + POLLING UNIT WITH ALLOCATE SLOT FOR NEW CANDIDATE NO
					SET @SkipNo = 0
                    EXEC ReorderMPDC @ThaiYear, @ADM1Code, @PollingUnitNo, @SkipNo
				END
			END
			ELSE
			BEGIN
			    -- NO PREVIOUS DATA BUT PersonId is already exists in Province, PollingUnitNo
				UPDATE MPDC
				   SET PrevPartyId = COALESCE(@PrevPartyId, PrevPartyId)
					 , SubGroup = COALESCE(@SubGroup, SubGroup)
					 , [Remark] = COALESCE(@Remark, [Remark])
					 , EducationId = COALESCE(@EducationId, EducationId)
				 WHERE ThaiYear = @ThaiYear
                   AND ADM1Code = @ADM1Code
				   AND PollingUnitNo = @PollingUnitNo
				   AND CandidateNo = @CandidateNo
				   AND PersonId = @PersonId
			END
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
				SET @SkipNo = NULL
				EXEC ReorderMPDC @ThaiYear, @ADM1CodeOri, @PollingUnitNoOri, @SkipNo
				-- REORDER NEW PROVINCE + POLLING UNIT WITH ALLOCATE SLOT FOR NEW CANDIDATE NO
				SET @SkipNo = NULL
				EXEC ReorderMPDC @ThaiYear, @ADM1Code, @PollingUnitNo, @CandidateNo, @SkipNo

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
				SET @errNum = 200;
				SET @errMsg = 'Some previous parameter(s) is null.';
				RETURN
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
