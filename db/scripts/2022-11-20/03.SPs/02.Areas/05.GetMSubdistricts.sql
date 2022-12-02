/****** Object:  StoredProcedure [dbo].[GetMSubdistricts]    Script Date: 11/26/2022 3:11:53 PM ******/
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
CREATE PROCEDURE [dbo].[GetMSubdistricts]
(
  @ADM3Code nvarchar(20) = NULL
, @SubdistrictNameTH nvarchar(200) = NULL
, @ADM2Code nvarchar(20) = NULL
, @DistrictNameTH nvarchar(200) = NULL
, @ADM1Code nvarchar(20) = NULL
, @ProvinceNameTH nvarchar(200) = NULL
, @RegionId nvarchar(20) = NULL
, @RegionName nvarchar(200) = NULL
, @GeoGroup nvarchar(200) = NULL
, @GeoSubGroup nvarchar(200) = NULL
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
	  FROM MSubdistrictView
	 WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM3Code, ADM3Code))))
	   AND UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM2Code, ADM2Code))))
	   AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	   AND (   UPPER(LTRIM(RTRIM(SubdistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameTH, SubdistrictNameTH)))) + '%'
            OR (SubdistrictNameTH IS NULL AND @SubdistrictNameTH IS NULL)
           )
	   AND (   UPPER(LTRIM(RTRIM(DistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameTH, ProvinceNameTH)))) + '%'
            OR (DistrictNameTH IS NULL AND @DistrictNameTH IS NULL)
           )
	   AND (   UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
            OR (ProvinceNameTH IS NULL AND @ProvinceNameTH IS NULL)
           )
	   AND (   UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
            OR (RegionId IS NULL AND @RegionId IS NULL)
           )
	   AND (   UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
            OR (RegionName IS NULL AND @RegionName IS NULL)
           )
	   AND (   UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
            OR (GeoGroup IS NULL AND @GeoGroup IS NULL)
           )
	   AND (   UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
            OR (GeoSubGroup IS NULL AND @GeoSubGroup IS NULL)
           )
	 ORDER BY ProvinceNameTH

END

GO
