/****** Object:  View [dbo].[PollingStationView]    Script Date: 8/29/2022 9:33:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PollingStationView]
AS
	SELECT A.YearThai
	     , A.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
	     , A.ProvinceId
		 , C.ProvinceNameTH
		 , C.ProvinceNameEN
		 , C.ADM1Code
		 , A.DistrictId
		 , D.DistrictNameTH
		 , D.DistrictNameEN
		 , D.ADM2Code
		 , A.SubdistrictId
		 , E.SubdistrictNameTH
		 , E.SubdistrictNameEN
		 , E.ADM3Code
		 , A.PollingUnitNo
		 , A.PollingSubUnitNo
		 , A.VillageCount
	  FROM PollingStation A
	     , MRegion B
	     , MProvince C
	     , MDistrict D
	     , MSubdistrict E
	 WHERE A.RegionId = B.RegionId
	   AND A.ProvinceId = C.ProvinceId
	   AND A.DistrictId = D.DistrictId
	   AND A.SubdistrictId = E.SubdistrictId

GO
