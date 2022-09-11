SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMDistrictADM2
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- SaveMDistrictADM2 N'อากาศอำนวย', N'Akat Amnuai', N'TH4711', 661338974.564
-- =============================================
CREATE PROCEDURE [dbo].[SaveMDistrictADM2] (
  @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100)
, @ADM2Code nvarchar(20)
, @AreaKm2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@DistrictNameTH IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter DistrictNameTH or ProvinceId is null';
			RETURN
		END

		IF ((@DistrictNameTH IS NOT NULL)
		    AND 
			(@DistrictNameEN IS NOT NULL)
		    AND 
			(@ADM2Code IS NOT NULL)
            AND
            EXISTS 
			(
				SELECT * 
				  FROM MDistrict
				 WHERE DistrictNameTH = @DistrictNameTH
			)
		   )
		BEGIN
			UPDATE MDistrict
			   SET DistrictNameEN = UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameEN, DistrictNameEN))))
				 , ADM2Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM2Code, ADM2Code))))
				 , AreaKm2 = @AreaKm2
			 WHERE DistrictNameTH = @DistrictNameTH
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
