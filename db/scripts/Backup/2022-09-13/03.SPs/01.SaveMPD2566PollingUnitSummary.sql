/****** Object:  StoredProcedure [dbo].[SaveMPD2566PollingUnitSummary]    Script Date: 9/17/2022 3:43:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2566PollingUnitSummary
-- [== History ==]
-- <2022-09-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[SaveMPD2566PollingUnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
			RETURN
		END
		IF (@PollingUnitCount IS NULL) SET @PollingUnitCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2566PollingUnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2566PollingUnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, PollingUnitCount
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @PollingUnitCount
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2566PollingUnitSummary
			   SET PollingUnitCount = @PollingUnitCount
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
