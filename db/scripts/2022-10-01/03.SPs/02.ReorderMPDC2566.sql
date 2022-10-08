/****** Object:  StoredProcedure [dbo].[ReorderMPDC2566]    Script Date: 10/8/2022 5:53:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ReorderMPDC2566
-- [== History ==]
-- <2022-10-08> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ReorderMPDC2566] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @SkipCandidateNo int = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	CREATE TABLE #MPDC2566DATA
	(
		CandidateNo int,
		FullName nvarchar(200)
	)

	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END
		-- ADD DATA TO TEMP TABLE
		INSERT INTO #MPDC2566DATA 
		    SELECT CandidateNo
			     , FullName
			  FROM MPDC2566
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		  ORDER BY CandidateNo;

		DECLARE @iCnt int = 1
		DECLARE @CandidateNo int
		DECLARE @FullName nvarchar(200)
		DECLARE MPDC2566_CURSOR CURSOR 
			LOCAL
			FORWARD_ONLY 
			READ_ONLY 
			FAST_FORWARD
		FOR  
			SELECT CandidateNo
			     , FullName
			  FROM #MPDC2566DATA
		  ORDER BY CandidateNo;

		OPEN MPDC2566_CURSOR  
		FETCH NEXT FROM MPDC2566_CURSOR INTO @CandidateNo, @FullName
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
			UPDATE MPDC2566
			   SET CandidateNo = @iCnt
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
			   AND CandidateNo = @CandidateNo
			   AND FullName = @FullName
			-- INCREASE RUNNING NO
			SET @iCnt = @iCnt + 1
			FETCH NEXT FROM MPDC2566_CURSOR INTO @CandidateNo, @FullName
		END

		CLOSE MPDC2566_CURSOR  
		DEALLOCATE MPDC2566_CURSOR 	

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH

	DROP TABLE #MPDC2566DATA
END

GO
