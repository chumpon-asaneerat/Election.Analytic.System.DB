/****** Object:  StoredProcedure [dbo].[ReorderMPDC]    Script Date: 1/8/2023 20:59:15 ******/
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

	CREATE TABLE #MPDCDATA
	(
		CandidateNo int
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
			  FROM MPDC
			 WHERE ThaiYear = @ThaiYear
			   AND LTRIM(RTRIM(UPPER(ADM1Code))) = LTRIM(RTRIM(UPPER(@ADM1Code)))
			   AND PollingUnitNo = @PollingUnitNo
		  ORDER BY CandidateNo;

		DECLARE MPDC_CURSOR CURSOR LOCAL FORWARD_ONLY READ_ONLY FAST_FORWARD
		FOR  
		    SELECT CandidateNo
			  FROM #MPDCDATA
		     ORDER BY CandidateNo

		OPEN MPDC_CURSOR  
		FETCH NEXT FROM MPDC_CURSOR INTO @CandidateNo
		WHILE @@FETCH_STATUS = 0  
		BEGIN
			IF (@SkipCandidateNo IS NOT NULL)
			BEGIN
				IF (@iCnt = @SkipCandidateNo)
				BEGIN
					SET @iCnt = @iCnt + 1
				END
			END
			-- UPDATE RUNNING NO
			UPDATE MPDC
			   SET CandidateNo = @iCnt
			 WHERE ThaiYear = @ThaiYear
			   AND LTRIM(RTRIM(UPPER(ADM1Code))) = LTRIM(RTRIM(UPPER(@ADM1Code)))
			   AND PollingUnitNo = @PollingUnitNo
			   AND CandidateNo = @CandidateNo

			-- INCREASE RUNNING NO
			SET @iCnt = @iCnt + 1
			FETCH NEXT FROM MPDC_CURSOR INTO @CandidateNo
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
	END CATCH

	DROP TABLE #MPDCDATA
END

GO
