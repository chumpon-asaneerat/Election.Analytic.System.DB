/****** Object:  StoredProcedure [dbo].[SaveMDistrict]    Script Date: 8/29/2022 10:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMDistrict
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- SaveMDistrict N'01', N'10', N'10', N'พระนคร', NULL, NULL
-- =============================================
CREATE PROCEDURE [dbo].[SaveMDistrict] (
  @DistrictId nvarchar(10)
, @RegionId nvarchar(10)
, @ProvinceId nvarchar(10)
, @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100) = NULL
, @ADM2Code nvarchar(20) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@RegionId IS NULL OR @ProvinceId IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
			RETURN
		END

		IF ((@DistrictId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MDistrict
				 WHERE DistrictId = @DistrictId
				   AND RegionId = @RegionId
				   AND ProvinceId = @ProvinceId
			)
		   )
		BEGIN
			INSERT INTO MDistrict
			(
				  DistrictId
				, RegionId
				, ProvinceId 
				, DistrictNameEN
				, DistrictNameTH
				, ADM2Code
			)
			VALUES
			(
				  @DistrictId
				, @RegionId
				, @ProvinceId
				, @DistrictNameEN
				, @DistrictNameTH
				, @ADM2Code
			);
		END
		ELSE
		BEGIN
			UPDATE MDistrict
			   SET DistrictNameEN = UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameEN, DistrictNameEN))))
				 , DistrictNameTH = UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH))))
				 , ADM2Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM2Code, ADM2Code))))
			 WHERE DistrictId = @DistrictId
			   AND RegionId = @RegionId
			   AND ProvinceId = @ProvinceId
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
