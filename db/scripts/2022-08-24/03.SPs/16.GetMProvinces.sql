/****** Object:  StoredProcedure [dbo].[GetMProvinces]    Script Date: 8/29/2022 11:42:04 PM ******/
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
--
-- [== Example ==]
--
-- EXEC GetMProvinces NULL, NULL, NULL, NULL, NULL, NULL		-- Gets all
-- EXEC GetMProvinces NULL, NULL, NULL, N'1', NULL, NULL		-- Search all that RegionName contains '1'
-- EXEC GetMProvinces NULL, N'ก', NULL, NULL, N'กลาง', NULL		-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
CREATE PROCEDURE [dbo].[GetMProvinces]
(
  @ProvinceId nvarchar(10) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
, @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT A.ProvinceId
	     , A.ProvinceNameTH
	     , A.ProvinceNameEN
	     , A.ADM1Code
	     , B.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
	  FROM MProvince A
	     , MRegion B
	 WHERE A.RegionId = B.RegionId
	   AND UPPER(LTRIM(RTRIM(A.ProvinceId))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceId, A.ProvinceId))))
	   AND UPPER(LTRIM(RTRIM(A.ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, A.ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(B.RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, B.RegionId))))
	   AND UPPER(LTRIM(RTRIM(B.RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, B.RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(B.GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, B.GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(B.GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, B.GeoSubGroup)))) + '%'
	 ORDER BY RegionId

END

GO
