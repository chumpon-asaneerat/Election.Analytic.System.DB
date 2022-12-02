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
, @ProvinceNameTH nvarchar(200) = NULL
, @DistrictNameTH nvarchar(200) = NULL
, @SubdistrictNameTH nvarchar(200) = NULL
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
	 WHERE UPPER(LTRIM(RTRIM(SubdistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameTH, SubdistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(DistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	 ORDER BY ProvinceNameTH

END

GO
