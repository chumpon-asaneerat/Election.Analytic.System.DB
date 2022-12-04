/****** Object:  View [dbo].[PollingUnitView]    Script Date: 11/30/2022 12:35:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW PollingUnitView
AS
	SELECT A.ThaiYear
         , A.ADM1Code
	     , A.PollingUnitNo
	     , A.PollingUnitCount
	     , A.AreaRemark
		 , B.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , B.ProvinceId
		 , B.ProvinceNameEN
		 , B.ProvinceNameTH
	  FROM PollingUnit A LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code

GO
