/****** Object:  StoredProcedure [dbo].[SaveMPD2562x350UnitSummary]    Script Date: 9/30/2022 8:54:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2562x350UnitSummary
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SaveMPD2562x350UnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @RightCount int = 0
, @ExerciseCount int = 0
, @InvalidCount int = 0
, @NoVoteCount int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END
		IF (@RightCount IS NULL) SET @RightCount = 0;
		IF (@ExerciseCount IS NULL) SET @ExerciseCount = 0;
		IF (@InvalidCount IS NULL) SET @InvalidCount = 0;
		IF (@NoVoteCount IS NULL) SET @NoVoteCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562x350UnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2562x350UnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, RightCount
				, ExerciseCount 
				, InvalidCount
				, NoVoteCount
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @RightCount
				, @ExerciseCount 
				, @InvalidCount
				, @NoVoteCount
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562x350UnitSummary
			   SET RightCount = @RightCount
				 , ExerciseCount = @ExerciseCount
				 , InvalidCount = @InvalidCount
				 , NoVoteCount = @NoVoteCount
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
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
