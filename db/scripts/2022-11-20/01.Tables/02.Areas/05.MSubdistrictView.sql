/****** Object:  View [dbo].[MSubdistrictView]    Script Date: 11/26/2022 2:56:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MSubdistrictView]
AS
	SELECT A.ADM3Code
		 , A.SubdistrictNameEN
		 , A.SubdistrictNameTH
		 , A.AreaM2 AS SubdistrictAreaM2
		 , A.SubdistrictId
         , A.RegionId
		 , A.ProvinceId
		 , A.DistrictId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ADM1Code
		 , C.ProvinceNameTH
		 , C.ProvinceNameEN
		 , C.AreaM2 AS ProvinceAreaM2
		 , D.ADM2Code
		 , D.DistrictNameTH
		 , D.DistrictNameEN
		 , D.AreaM2 AS DistrictAreaM2
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
