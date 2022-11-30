/****** Object:  View [dbo].[MSubdistrictView]    Script Date: 11/27/2022 10:18:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MSubdistrictView]
AS
	SELECT A.ADM3Code
		 , A.SubdistrictNameTH
		 , A.SubdistrictNameEN
		 , A.AreaM2 AS SubdistrictAreaM2
		 , C.ADM1Code
		 , D.ADM2Code
		 , A.RegionId
		 , A.ProvinceId
         , A.DistrictId
		 , A.SubdistrictId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ProvinceNameTH
		 , C.ProvinceNameEN
		 , D.DistrictNameTH
		 , D.DistrictNameEN
		 , C.AreaM2 AS ProvinceAreaM2
		 , D.AreaM2 AS DistrictAreaM2
	  FROM MSubdistrict A
		 , MDistrict D 
		 , MProvince C LEFT OUTER JOIN MRegion B ON B.RegionId = C.RegionId
	 WHERE A.ADM1Code = C.ADM1Code
	   AND A.ADM2Code = D.ADM2Code

GO
