SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMSubdistrictADM3
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC SaveMSubdistrictADM3 N'ชลบุรี', N'Chon Buri', N'เมืองชลบุรี', N'Mueang Chon Buri', N'อ่างศิลา', N'Ang Sila', N'TH200117', 6568129.19107
-- =============================================
CREATE PROCEDURE [dbo].[SaveMSubdistrictADM3] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100)
, @SubdistrictNameTH nvarchar(100)
, @SubdistrictNameEN nvarchar(100) = NULL
, @ADM3Code nvarchar(20) = NULL
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ProvinceId nvarchar(10)
DECLARE @DistrictId nvarchar(10)
DECLARE @SubdistrictId nvarchar(10)
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
		    OR @ProvinceNameEN IS NULL 
			OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL
			OR @SubdistrictNameTH IS NULL 
			OR @SubdistrictNameEN IS NULL
			OR @ADM3Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter some parameter(s) is null';
			RETURN
		END

		SELECT @ProvinceId = ProvinceId
		     , @DistrictId = DistrictId
			 , @SubdistrictId = SubdistrictId
		  FROM MSubdistrictView
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
		   AND UPPER(LTRIM(RTRIM(DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))
		   AND UPPER(LTRIM(RTRIM(SubdistrictNameTH))) = UPPER(LTRIM(RTRIM(@SubdistrictNameTH)))

		IF ((@ProvinceId IS NOT NULL)
            AND
			(@DistrictId IS NOT NULL)
			AND
			(@SubdistrictId IS NOT NULL)
			AND
			(@SubdistrictNameEN IS NOT NULL)
			AND
			(@ADM3Code IS NOT NULL)
		   )
		BEGIN
			UPDATE MSubdistrict
			   SET SubdistrictNameEN = UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameEN, SubdistrictNameEN))))
				 , ADM3Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM3Code, ADM3Code))))
				 , AreaM2 = @AreaM2
			 WHERE ProvinceId = @ProvinceId
			   AND DistrictId = @DistrictId
			   AND SubdistrictId = @SubdistrictId
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
