/****** Object:  StoredProcedure [dbo].[GetMSubdistricts]    Script Date: 9/11/2022 9:24:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMSubdistricts
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL		-- Gets all
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'1', NULL, NULL		-- Search all that RegionName contains '1'
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL, NULL, N'ก', NULL, NULL, N'กลาง', NULL	-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
ALTER PROCEDURE [dbo].[GetMSubdistricts]
(
  @SubdistrictId nvarchar(10) = NULL
, @SubdistrictNameTH nvarchar(100) = NULL
, @DistrictId nvarchar(10) = NULL
, @DistrictNameTH nvarchar(100) = NULL
, @ProvinceId nvarchar(10) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
, @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT SubdistrictId
	     , SubdistrictNameTH
	     , SubdistrictNameEN
	     , DistrictId
	     , DistrictNameTH
	     , DistrictNameEN
	     , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , ADM2Code
	     , ADM3Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , SubdistrictAreaM2
		 , SubdistrictContentId
	  FROM MSubdistrictView
	 WHERE UPPER(LTRIM(RTRIM(SubdistrictId))) = UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictId, SubdistrictId))))
	   AND UPPER(LTRIM(RTRIM(SubdistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameTH, SubdistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(DistrictId))) = UPPER(LTRIM(RTRIM(COALESCE(@DistrictId, DistrictId))))
	   AND UPPER(LTRIM(RTRIM(DistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(ProvinceId))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceId, ProvinceId))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY ProvinceNameTH

END

GO
