/****** Object:  View [dbo].[MDistrictView]    Script Date: 11/29/2022 7:38:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MDistrictView]
AS
	SELECT A.ADM2Code
		 , A.AreaM2 AS DistrictAreaM2
         , A.DistrictId
		 , A.DistrictNameTH
		 , A.DistrictNameEN
		 , A.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ADM1Code
		 , A.ProvinceId
		 , C.ProvinceNameTH
		 , C.ProvinceNameEN
		 , C.AreaM2 AS ProvinceAreaM2
	  FROM MDistrict A
		 , MProvince C LEFT OUTER JOIN MRegion B ON B.RegionId = C.RegionId
	 WHERE A.ADM1Code = C.ADM1Code

GO
