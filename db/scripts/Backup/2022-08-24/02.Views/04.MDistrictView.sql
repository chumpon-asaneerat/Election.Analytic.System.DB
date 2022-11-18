/****** Object:  View [dbo].[MDistrictView]    Script Date: 8/29/2022 11:38:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[MDistrictView]
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
		 , A.ADM2Code
	  FROM MDistrict A
		 , MRegion B
		 , MProvince C
	 WHERE A.RegionId = B.RegionId
	   AND C.RegionId = B.RegionId
	   AND A.ProvinceId = C.ProvinceId

GO
