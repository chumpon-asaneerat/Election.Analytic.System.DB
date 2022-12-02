/****** Object:  StoredProcedure [dbo].[GetMADMPaks]    Script Date: 12/2/2022 1:47:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMADMPaks
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMADMPaks]
(
  @RegionId nvarchar(20) = NULL
, @ADM1Code nvarchar(20) = NULL
, @ADM2Code nvarchar(20) = NULL
, @ADM3Code nvarchar(20) = NULL
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
	   AND (   UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
            OR (RegionId IS NULL AND @RegionId IS NULL)
           )
	 ORDER BY ProvinceNameTH

END

GO
