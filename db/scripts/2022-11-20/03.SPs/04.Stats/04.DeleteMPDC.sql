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
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int
	BEGIN TRY
		IF (@ThaiYear IS NULL
         OR @ADM1Code IS NULL 
		 OR @PollingUnitNo IS NULL
		 OR @CandidateNo IS NULL)
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

		UPDATE MPDC
		  SET CandidateNo = CandidateNo - 1
		 WHERE ThaiYear = @ThaiYear
           AND ADM1Code = @ADM1Code
		   AND PollingUnitNo = @PollingUnitNo
		   AND CandidateNo >= @CandidateNo

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
