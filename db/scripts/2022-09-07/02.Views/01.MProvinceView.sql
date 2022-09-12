/****** Object:  View [dbo].[MProvinceView]    Script Date: 9/12/2022 8:50:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MProvinceView]
AS
	SELECT A.ProvinceId
	     , A.ProvinceNameTH
	     , A.ProvinceNameEN
	     , A.ADM1Code
		 , A.AreaM2 AS ProvinceAreaM2
	     , B.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
         , A.ContentId AS ProvinceContentId
	  FROM MProvince A
	     , MRegion B
	 WHERE A.RegionId = B.RegionId


GO
