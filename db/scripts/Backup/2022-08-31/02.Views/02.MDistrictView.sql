/****** Object:  View [dbo].[MDistrictView]    Script Date: 9/11/2022 6:01:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MDistrictView]
AS
	SELECT A.RegionId
		 , A.ProvinceId
		 , A.DistrictId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ProvinceNameTH
		 , A.DistrictNameTH
		 , C.ProvinceNameEN
		 , A.DistrictNameEN
		 , C.ADM1Code
		 , C.AreaM2 AS ProvinceAreaM2
         , C.ContentId AS ProvinceContentId
		 , A.ADM2Code
		 , A.AreaM2 AS DistrictAreaM2
         , A.ContentId AS DistrictContentId
	  FROM MDistrict A
		 , MRegion B
		 , MProvince C
	 WHERE A.RegionId = B.RegionId
	   AND C.RegionId = B.RegionId
	   AND A.ProvinceId = C.ProvinceId

GO
