/****** Object:  View [dbo].[MSubdistrictView]    Script Date: 8/29/2022 11:04:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MSubdistrictView]
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
		 , C.ADM1Code
		 , D.ADM2Code
		 , A.ADM3Code
	  FROM MSubdistrict A
		 , MRegion B
		 , MProvince C
		 , MDistrict D
	 WHERE A.RegionId = B.RegionId
	   AND A.ProvinceId = C.ProvinceId
	   AND A.DistrictId = D.DistrictId

GO
