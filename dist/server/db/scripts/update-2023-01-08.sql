/*********** Script Update Date: 2023-01-08  ***********/
/****** Object:  StoredProcedure [dbo].[ReorderMPDC]    Script Date: 1/8/2023 21:45:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ReorderMPDC
-- [== History ==]
-- <2022-10-08> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ReorderMPDC] (
  @ThaiYear int    
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @SkipCandidateNo int = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 1
DECLARE @CandidateNo int
DECLARE @PersonId int
DECLARE @PrevPartyId int
DECLARE @Remark nvarchar(max)
DECLARE @SubGroup nvarchar(max)

	-- BEGIN TRANSACTION
	BEGIN TRANSACTION

	CREATE TABLE #MPDCDATA
	(
		CandidateNo int,
		PersonId int,
		PrevPartyId int,
		[Remark] nvarchar(max),
		SubGroup nvarchar(max)
	)
	BEGIN TRY
		IF (@ThaiYear IS NULL OR
		    @ADM1Code IS NULL OR
		    @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END
		-- ADD DATA TO TEMP TABLE
		INSERT INTO #MPDCDATA 
		    SELECT CandidateNo
				 , PersonId
				 , PrevPartyId
				 , [Remark]
				 , SubGroup
			  FROM MPDC
			 WHERE ThaiYear = @ThaiYear
			   AND LTRIM(RTRIM(UPPER(ADM1Code))) = LTRIM(RTRIM(UPPER(@ADM1Code)))
			   AND PollingUnitNo = @PollingUnitNo
		  ORDER BY CandidateNo;

		DECLARE MPDC_CURSOR CURSOR LOCAL FORWARD_ONLY READ_ONLY FAST_FORWARD
		FOR  
		    SELECT CandidateNo
				 , PersonId
				 , PrevPartyId
				 , [Remark]
				 , SubGroup
			  FROM #MPDCDATA
		     ORDER BY CandidateNo

		-- REMOVE ALL EXISTS
		DELETE 
		  FROM MPDC
	     WHERE ThaiYear = @ThaiYear
		   AND LTRIM(RTRIM(UPPER(ADM1Code))) = LTRIM(RTRIM(UPPER(@ADM1Code)))
		   AND PollingUnitNo = @PollingUnitNo

		OPEN MPDC_CURSOR  
		FETCH NEXT FROM MPDC_CURSOR INTO @CandidateNo, @PersonId, @PrevPartyId, @Remark, @SubGroup
		WHILE @@FETCH_STATUS = 0  
		BEGIN
			IF (@SkipCandidateNo IS NOT NULL)
			BEGIN
				IF (@iCnt = @SkipCandidateNo)
				BEGIN
					SET @iCnt = @iCnt + 1
				END
			END
			-- INSERT NEW DATA WITH REASSIGN NEW RUNNING NO
			-- Add New Row
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
			 , @ADM1Code
			 , @PollingUnitNo
			 , @iCnt
			 , @PersonId
			 , @PrevPartyId
			 , @Remark
			 , @SubGroup
			)

			-- INCREASE RUNNING NO
			SET @iCnt = @iCnt + 1
			FETCH NEXT FROM MPDC_CURSOR INTO @CandidateNo, @PersonId, @PrevPartyId, @Remark, @SubGroup
		END

		CLOSE MPDC_CURSOR  
		DEALLOCATE MPDC_CURSOR 	

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();

		-- ROLLBACK TRANSACTION
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION; 
	END CATCH

	DROP TABLE #MPDCDATA

	-- COMMIT TRANSACTION
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION;
END

GO


/*********** Script Update Date: 2023-01-08  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPDC2]    Script Date: 1/8/2023 21:32:21 ******/
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
ALTER PROCEDURE [dbo].[SaveMPDC2] (
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
DECLARE @iMaxCandidateNo int
DECLARE @iCnt int
	BEGIN TRY
		-- CHECK PARAMETERS
		IF (   @ThaiYear IS NULL 
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

		-- CHECKS AND ASSIGNED PROPER CandidateNo
		IF (@CandidateNo <= 0) 
		BEGIN
			SELECT @iMaxCandidateNo = MAX(CandidateNo)
			  FROM MPDC 
			 WHERE ThaiYear = @ThaiYear
			   AND LTRIM(RTRIM(UPPER(ADM1Code))) = LTRIM(RTRIM(UPPER(@ADM1Code)))
			   AND PollingUnitNo = @PollingUnitNo

			IF (@iMaxCandidateNo IS NULL) 
				SET @CandidateNo = 1
			ELSE SET @CandidateNo = @iMaxCandidateNo + 1
		END

		-- HAS ORIGINAL
		IF (@ADM1CodeOri IS NOT NULL AND 
		    @PollingUnitNoOri IS NOT NULL)
		BEGIN
			-- FIRST DELETE ROW FROM ORIGINAL AREA				
			EXEC DeleteMPDC @ThaiYear, @ADM1CodeOri, @PollingUnitNoOri, @CandidateNoOri
			-- NEXT IS Reorder to make insert space.
			EXEC ReorderMPDC @ThaiYear, @ADM1Code, @PollingUnitNo, @CandidateNo
		END
		ELSE
		BEGIN
			--NO ORIGINAL DATA EXISTS SO Reorder to make insert space.
			EXEC ReorderMPDC @ThaiYear, @ADM1Code, @PollingUnitNo, @CandidateNo
		END
		-- Add New Row
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
		  , @ADM1Code
		  , @PollingUnitNo
		  , @CandidateNo
		  , @PersonId
		  , @PrevPartyId
		  , @Remark
		  , @SubGroup
		)

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


/*********** Script Update Date: 2023-01-08  ***********/
/****** Object:  StoredProcedure [dbo].[DeleteAllMPDC]    Script Date: 1/8/2023 22:39:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeleteAllMPDC
-- [== History ==]
-- <2022-10-08> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAllMPDC] (
  @ThaiYear int    
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int
	BEGIN TRY
		IF (@ThaiYear IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END

		DELETE  
		  FROM MPDC
		 WHERE ThaiYear = @ThaiYear

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

