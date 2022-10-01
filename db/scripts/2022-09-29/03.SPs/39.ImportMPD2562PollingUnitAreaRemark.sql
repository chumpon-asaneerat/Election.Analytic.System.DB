/****** Object:  StoredProcedure [dbo].[ImportMPD2562PollingUnitAreaRemark]    Script Date: 10/1/2022 10:20:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPD2562PollingUnitAreaRemark
-- [== History ==]
-- <2022-09-12> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[ImportMPD2562PollingUnitAreaRemark] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @AreaRemark nvarchar(4000) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter(s)  is null';
			RETURN
		END
		IF (dbo.IsNullOrEmpty(@AreaRemark) = 1) SET @AreaRemark = NULL;

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
				, AreaRemark
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @AreaRemark
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562PollingUnitSummary
			   SET AreaRemark = @AreaRemark
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
