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
-- SaveMDistrictADM2 N'สกลนคร', N'Sakon Nakhon', N'อากาศอำนวย', N'Akat Amnuai', N'TH4711', 661338974.564
-- =============================================
CREATE PROCEDURE [dbo].[SaveMDistrictADM2] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100)
, @ADM2Code nvarchar(20)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ProvinceId nvarchar(10)
DECLARE @DistrictId nvarchar(10)
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
		    OR @ProvinceNameEN IS NULL 
			OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL
			OR @ADM2Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter DistrictNameTH or ProvinceId is null';
			RETURN
		END

		SELECT @ProvinceId = ProvinceId
		     , @DistrictId = DistrictId
		  FROM MDistrictView
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
		   AND UPPER(LTRIM(RTRIM(DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))

		IF ((@ProvinceId IS NOT NULL)
			AND
			(@DistrictId IS NOT NULL)
			AND 
			(@DistrictNameEN IS NOT NULL)
		    AND 
			(@ADM2Code IS NOT NULL)
		   )
		BEGIN
			UPDATE MDistrict
			   SET DistrictNameEN = UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameEN, DistrictNameEN))))
				 , ADM2Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM2Code, ADM2Code))))
				 , AreaM2 = @AreaM2
			 WHERE ProvinceId = @ProvinceId
			   AND DistrictId = @DistrictId
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
