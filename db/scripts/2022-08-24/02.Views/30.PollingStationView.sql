/****** Object:  View [dbo].[PollingStationView]    Script Date: 8/30/2022 12:48:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PollingStationView]
AS
	SELECT A.YearThai
	     , A.RegionId
		 , E.RegionName
		 , E.GeoGroup
		 , E.GeoSubGroup
	     , A.ProvinceId
		 , E.ProvinceNameTH
		 , E.ProvinceNameEN
		 , E.ADM1Code
		 , A.DistrictId
		 , E.DistrictNameTH
		 , E.DistrictNameEN
		 , E.ADM2Code
		 , A.SubdistrictId
		 , E.SubdistrictNameTH
		 , E.SubdistrictNameEN
		 , E.ADM3Code
		 , A.PollingUnitNo
		 , A.PollingSubUnitNo
		 , A.VillageCount
	  FROM PollingStation A
	     , MSubdistrictView E
	 WHERE A.RegionId = E.RegionId
	   AND A.ProvinceId = E.ProvinceId
	   AND A.DistrictId = E.DistrictId
	   AND A.SubdistrictId = E.SubdistrictId

GO
