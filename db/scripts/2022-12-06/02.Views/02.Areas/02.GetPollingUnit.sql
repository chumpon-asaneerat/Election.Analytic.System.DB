/****** Object:  StoredProcedure [dbo].[GetPollingUnit]    Script Date: 11/26/2022 3:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPollingUnit
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPollingUnit]
(
  @ThaiYear int = NULL
, @ADM1Code nvarchar(20) = NULL
, @ProvinceNameTH nvarchar(200) = NULL
, @PollingUnitNo int = NULL
, @RegionId nvarchar(20) = NULL
, @RegionName nvarchar(200) = NULL
, @GeoGroup nvarchar(200) = NULL
, @GeoSubGroup nvarchar(200) = NULL
)
AS
BEGIN
	SELECT ThaiYear
         , ADM1Code
	     , PollingUnitNo
	     , PollingUnitCount
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
         , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
         , AreaRemark
	  FROM PollingUnitView
	 WHERE ThaiYear = COALESCE(@ThaiYear, ThaiYear)
       AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
       AND UPPER(LTRIM(RTRIM(PollingUnitNo))) = UPPER(LTRIM(RTRIM(COALESCE(@PollingUnitNo, PollingUnitNo))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY ThaiYear, RegionId, RegionName, ProvinceNameTH

END

GO
