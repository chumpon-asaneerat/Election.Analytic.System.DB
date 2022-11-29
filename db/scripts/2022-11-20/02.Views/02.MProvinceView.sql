/****** Object:  View [dbo].[MProvinceView]    Script Date: 11/26/2022 2:48:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MProvinceView]
AS
	SELECT A.ADM1Code
	     , A.ProvinceNameTH
	     , A.ProvinceNameEN
	     , A.AreaM2 AS ProvinceAreaM2
		 , A.ProvinceId
	     , B.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
	  FROM MProvince A LEFT OUTER JOIN MRegion B ON B.RegionId = A.RegionId

GO
