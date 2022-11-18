/****** Object:  StoredProcedure [dbo].[ImportPollingStation]    Script Date: 8/30/2022 12:38:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportPollingStation
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- 
-- EXEC ImportPollingStatione @data, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- =============================================
CREATe PROCEDURE [dbo].[ImportPollingStation] (
  @YearThai int
, @RegionName nvarchar(100)
, @GeoSubGroup nvarchar(100)
, @ProvinceId nvarchar(10)
, @ProvinceNameTH nvarchar(100)
, @DistrictId nvarchar(10)
, @DistrictNameTH nvarchar(100)
, @SubdistrictId nvarchar(10)
, @SubdistrictNameTH nvarchar(100)
, @PollingUnitNo int
, @PollingSubUnitNo int
, @VillageCount int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @RegionId nvarchar(10);
	BEGIN TRY
	    -- Check all required parameters should not be null
		IF (   @YearThai IS NULL 
		    OR @RegionName IS NULL
		    OR @GeoSubGroup IS NULL
		    OR @ProvinceId IS NULL
		    OR @ProvinceNameTH IS NULL
		    OR @DistrictId IS NULL
		    OR @DistrictNameTH IS NULL
		    OR @SubdistrictId IS NULL
		    OR @SubdistrictNameTH IS NULL
			OR @PollingUnitNo IS NULL
			OR @PollingSubUnitNo IS NULL
		   )
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some of required parameters is null.';
			RETURN
		END
	    
		-- Check RegionName to find RegionId
		SET @RegionId = dbo.FindRegionId(@RegionName);
		IF (@RegionId IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'Cannot Find RegionId by RegionName: ' + CONVERT(nvarchar(100), @RegionName);
			RETURN
		END

		-- Auto save master tables.
		EXEC SaveMProvince @ProvinceId, @RegionId, @ProvinceNameTH
		EXEC SaveMDistrict @DistrictId, @RegionId, @ProvinceId, @DistrictNameTH
		EXEC SaveMSubdistrict @SubdistrictId, @RegionId, @ProvinceId, @DistrictId, @SubdistrictNameTH

		-- Check INSERT OR UPDATE
		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM PollingStation
				 WHERE YearThai = @YearThai
				   AND RegionId = @RegionId
				   AND ProvinceId = @ProvinceId
				   AND DistrictId = @DistrictId
				   AND SubdistrictId = @SubdistrictId
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO PollingStation
			(
				  YearThai
				, RegionId
				, ProvinceId
				, DistrictId
				, SubdistrictId
				, PollingUnitNo
				, PollingSubUnitNo
				, VillageCount
			)
			VALUES
			(
				  @YearThai
				, @RegionId
				, @ProvinceId
				, @DistrictId
				, @SubdistrictId
				, @PollingUnitNo
				, @PollingSubUnitNo
				, @VillageCount
			);
		END
		ELSE
		BEGIN
			UPDATE PollingStation
			   SET PollingSubUnitNo = @PollingSubUnitNo
				 , VillageCount = @VillageCount
			 WHERE YearThai = @YearThai
			   AND RegionId = @RegionId
			   AND ProvinceId = @ProvinceId
			   AND DistrictId = @DistrictId
			   AND SubdistrictId = @SubdistrictId
			   AND PollingUnitNo = @PollingUnitNo;
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
