/****** Object:  StoredProcedure [dbo].[SaveMSubdistrict]    Script Date: 8/29/2022 10:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMSubdistrict
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC SaveMDistrict N'02', N'10', N'10', N'01', N'วังบูรพาภิรมย์', NULL, NULL
-- =============================================
CREATE PROCEDURE [dbo].[SaveMSubdistrict] (
  @SubdistrictId nvarchar(10)
, @RegionId nvarchar(10)
, @ProvinceId nvarchar(10)
, @DistrictId nvarchar(10)
, @SubdistrictNameTH nvarchar(100)
, @SubdistrictNameEN nvarchar(100) = NULL
, @ADM3Code nvarchar(20) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@RegionId IS NULL OR @ProvinceId IS NULL OR @DistrictId IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
			RETURN
		END

		IF ((@SubdistrictId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MSubdistrict
				 WHERE SubdistrictId = @SubdistrictId
				   AND RegionId = @RegionId
				   AND ProvinceId = @ProvinceId
				   AND DistrictId = @DistrictId
			)
		   )
		BEGIN
			INSERT INTO MSubdistrict
			(
				  SubdistrictId
				, DistrictId
				, RegionId
				, ProvinceId 
				, SubdistrictNameEN
				, SubdistrictNameTH
				, ADM3Code
			)
			VALUES
			(
				  @SubdistrictId
				, @DistrictId
				, @RegionId
				, @ProvinceId
				, @SubdistrictNameEN
				, @SubdistrictNameTH
				, @ADM3Code
			);
		END
		ELSE
		BEGIN
			UPDATE MSubdistrict
			   SET @SubdistrictNameEN = UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameEN, SubdistrictNameEN))))
				 , @SubdistrictNameTH = UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameTH, SubdistrictNameTH))))
				 , ADM3Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM3Code, ADM3Code))))
			 WHERE SubdistrictId = @SubdistrictId
			   AND DistrictId = @DistrictId
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
