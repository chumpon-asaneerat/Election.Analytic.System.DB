/****** Object:  StoredProcedure [dbo].[GetMDistricts]    Script Date: 11/26/2022 3:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMDistricts
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMDistricts NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL	-- Gets all
-- EXEC GetMDistricts NULL, NULL, NULL, NULL, NULL, N'1', NULL, NULL	-- Search all that RegionName contains '1'
-- EXEC GetMDistricts NULL, NULL, NULL, N'ก', NULL, NULL, N'กลาง', NULL	-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
CREATE PROCEDURE [dbo].[GetMDistricts]
(
  @ADM2Code nvarchar(20) = NULL
, @ADM1Code nvarchar(20) = NULL
, @RegionId nvarchar(20) = NULL
)
AS
BEGIN
	SELECT DistrictId
	     , DistrictNameTH
	     , DistrictNameEN
	     , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , ADM2Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , DistrictAreaM2
	  FROM MDistrictView
	 WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM2Code, ADM2Code))))
	   AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	   AND (   UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
            OR (RegionId IS NULL AND @RegionId IS NULL)
           )
	 ORDER BY ProvinceNameTH

END

GO
