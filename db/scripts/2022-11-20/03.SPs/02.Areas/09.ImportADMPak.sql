/****** Object:  StoredProcedure [dbo].[ImportADMPak]    Script Date: 11/29/2022 8:11:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportADMPak
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportADMPak] (
  @RegionName nvarchar(200)
, @ProvinceId nvarchar(20)
, @ProvinceNameTH nvarchar(200)
, @DistrictId nvarchar(20)
, @DistrictNameTH nvarchar(200)
, @SubdistrictId nvarchar(20)
, @SubdistrictNameTH nvarchar(200)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @RegionId nvarchar(20)
DECLARE @ADM1Code nvarchar(20)
DECLARE @ADM2Code nvarchar(20)
DECLARE @ADM3Code nvarchar(20)
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
		    OR @DistrictNameTH IS NULL 
		    OR @SubdistrictNameTH IS NULL 
		    OR @ProvinceId IS NULL 
		    OR @DistrictId IS NULL 
		    OR @SubdistrictId IS NULL 
			OR @RegionName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @RegionId = RegionId
		  FROM MRegion
		 WHERE UPPER(LTRIM(RTRIM(RegionName))) = UPPER(LTRIM(RTRIM(@RegionName)))

		SELECT @ADM1Code = ADM1Code
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))

		SELECT @ADM2Code = ADM2Code 
		  FROM MDistrict
		 WHERE UPPER(LTRIM(RTRIM(DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))

		SELECT @ADM3Code = ADM3Code 
		  FROM MSubdistrict
		 WHERE UPPER(LTRIM(RTRIM(SubdistrictNameTH))) = UPPER(LTRIM(RTRIM(@SubdistrictNameTH)))

		IF (   @RegionId IS NULL
		    OR @ADM1Code IS NULL 
			OR @ADM2Code IS NULL
			OR @ADM3Code IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'RegionId or ADM1Code or ADM2Code or ADM3Code is null';
			RETURN
		END

		-- Province
        IF (EXISTS(
              SELECT * 
			    FROM MProvince
               WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
           ))
		BEGIN
			UPDATE MProvince
			   SET RegionId = @RegionId
			     , ProvinceId = @ProvinceId
			 WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
		END

		-- District
        IF (EXISTS(
              SELECT * 
			    FROM MDistrict
               WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(@ADM2Code)))
           ))
		BEGIN
			UPDATE MDistrict
			   SET RegionId = @RegionId
			     , ProvinceId = @ProvinceId
			     , DistrictId = @DistrictId
			 WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(@ADM2Code)))
		END

		-- Subdistrict
        IF (EXISTS(
              SELECT * 
			    FROM MSubdistrict
               WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(@ADM3Code)))
           ))
		BEGIN
			UPDATE MSubdistrict
			   SET RegionId = @RegionId
			     , ProvinceId = @ProvinceId
			     , DistrictId = @DistrictId
			     , SubdistrictId = @SubdistrictId
			 WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(@ADM3Code)))
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
