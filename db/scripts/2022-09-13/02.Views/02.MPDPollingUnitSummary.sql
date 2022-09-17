/****** Object:  View [dbo].[MPDPollingUnitSummary]    Script Date: 9/17/2022 7:16:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDPollingUnitSummary]
AS
	SELECT   A.ThaiYear
	       , A.ProvinceName
	       , A.PollingUnitNo
		   , A.PollingUnitCount
		   , A.AreaRemark
		   , B.ProvinceNameTH
		   , B.ProvinceId
		   , B.RegionId
		   , B.RegionName
	  FROM _MPDPollingUnitSummary A 
	       LEFT OUTER JOIN MProvinceView B 
		        ON UPPER(LTRIM(RTRIM(B.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(A.ProvinceName)))

GO
