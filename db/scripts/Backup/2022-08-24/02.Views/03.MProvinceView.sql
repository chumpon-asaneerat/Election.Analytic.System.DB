/****** Object:  View [dbo].[MProvinceView]    Script Date: 8/30/2022 12:04:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MProvinceView]
AS
	SELECT A.ProvinceId
	     , A.ProvinceNameTH
	     , A.ProvinceNameEN
	     , A.ADM1Code
	     , B.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
	  FROM MProvince A
	     , MRegion B
	 WHERE A.RegionId = B.RegionId

GO
