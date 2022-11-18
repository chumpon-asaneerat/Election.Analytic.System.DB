/****** Object:  View [dbo].[MSubdistrictView]    Script Date: 9/12/2022 8:50:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MSubdistrictView]
AS
	SELECT A.RegionId
		 , A.ProvinceId
		 , A.DistrictId
		 , A.SubdistrictId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ProvinceNameTH
		 , D.DistrictNameTH
		 , A.SubdistrictNameTH
		 , C.ProvinceNameEN
		 , D.DistrictNameEN
		 , A.SubdistrictNameEN
		 , C.AreaM2 AS ProvinceAreaM2
		 , D.AreaM2 AS DistrictAreaM2
		 , A.AreaM2 AS SubdistrictAreaM2
		 , C.ContentId AS ProvinceContentId
		 , D.ContentId AS DistrictContentId
		 , A.ContentId AS SubdistrictContentId
		 , C.ADM1Code
		 , D.ADM2Code
		 , A.ADM3Code
	  FROM MSubdistrict A
		 , MRegion B
		 , MProvince C
		 , MDistrict D
	 WHERE A.RegionId = B.RegionId
	   AND C.RegionId = B.RegionId
	   AND D.RegionId = B.RegionId
	   AND A.ProvinceId = C.ProvinceId
	   AND D.ProvinceId = C.ProvinceId
	   AND A.DistrictId = D.DistrictId


GO
