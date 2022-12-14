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
