/****** Object:  StoredProcedure [dbo].[GetMProvinces]    Script Date: 12/2/2022 6:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMProvinces
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMProvinces NULL, NULL, NULL, NULL, NULL, NULL		-- Gets all
-- EXEC GetMProvinces NULL, NULL, NULL, N'1', NULL, NULL		-- Search all that RegionName contains '1'
-- EXEC GetMProvinces NULL, N'ก', NULL, NULL, N'กลาง', NULL		-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
CREATE PROCEDURE [dbo].[GetMProvinces]
(
  @ADM1Code nvarchar(20) = NULL
, @ProvinceNameTH nvarchar(200) = NULL
, @RegionId nvarchar(20) = NULL
, @RegionName nvarchar(200) = NULL
, @GeoGroup nvarchar(200) = NULL
, @GeoSubGroup nvarchar(200) = NULL
)
AS
BEGIN
	SELECT ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , ProvinceAreaM2
	  FROM MProvinceView
	 WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
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
