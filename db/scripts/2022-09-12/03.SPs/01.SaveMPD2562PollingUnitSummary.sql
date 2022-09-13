/****** Object:  StoredProcedure [dbo].[SaveMPD2562PollingUnitSummary]    Script Date: 9/13/2022 2:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2562PollingUnitSummary
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-12> :
--	- Add parameter AreaRemark.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SaveMPD2562PollingUnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @AreaRemark nvarchar(1000) = NULL
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
		IF (dbo.IsNullOrEmpty(@AreaRemark)  = 1) SET @AreaRemark = NULL;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562PollingUnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2562PollingUnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, PollingUnitCount
				, AreaRemark
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @PollingUnitCount
				, @AreaRemark
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562PollingUnitSummary
			   SET PollingUnitCount = @PollingUnitCount
			     , AreaRemark = @AreaRemark
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
