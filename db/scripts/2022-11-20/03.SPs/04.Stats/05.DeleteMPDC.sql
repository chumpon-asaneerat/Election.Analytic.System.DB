/****** Object:  StoredProcedure [dbo].[DeleteMPDC]    Script Date: 12/2/2022 6:53:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeleteMPDC
-- [== History ==]
-- <2022-10-08> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMPDC] (
  @ThaiYear int    
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @CandidateNo int
, @PersonId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int
	BEGIN TRY
		IF (@ThaiYear IS NULL
         OR @ADM1Code IS NULL 
		 OR @PollingUnitNo IS NULL
		 OR @CandidateNo IS NULL
		 OR @PersonId IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END

		DELETE  
		  FROM MPDC
		 WHERE ThaiYear = @ThaiYear
           AND ADM1Code = @ADM1Code
		   AND PollingUnitNo = @PollingUnitNo
		   AND CandidateNo = @CandidateNo
		   AND PersonId = @PersonId

        -- CHECKS AFTER DELETE
        SELECT @iCnt = COUNT(CandidateNo) 
          FROM MPDC
         WHERE ThaiYear = @ThaiYear
           AND ADM1Code = @ADM1Code
           AND PollingUnitNo = @PollingUnitNo

		   	-- REORDER IF STILL HAS DATA NEED TO REORDER ONCE
			IF (@iCnt > 0)
			BEGIN
				-- REORDER NEW PROVINCE + POLLING UNIT WITH ALLOCATE SLOT 
                -- FOR NEW CANDIDATE NO (CandidateNo = 0)
				EXEC ReorderMPDC @ThaiYear, @ADM1Code, @PollingUnitNo, 0
			END

        -- REORDER ALL (SORT ALL WITHOUT EXCEPTION)
		EXEC ReorderMPDC @ThaiYear, @ADM1Code, @PollingUnitNo, NULL

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
