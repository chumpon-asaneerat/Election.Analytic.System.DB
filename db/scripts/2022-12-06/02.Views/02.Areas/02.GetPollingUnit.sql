/****** Object:  StoredProcedure [dbo].[GetPollingUnit]    Script Date: 11/26/2022 3:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPollingUnit
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPollingUnit]
(
  @ThaiYear int = NULL
, @ADM1Code nvarchar(20) = NULL
, @PollingUnitNo int = NULL
)
AS
BEGIN
	SELECT ThaiYear
         , ADM1Code
	     , PollingUnitNo
	     , PollingUnitCount
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
         , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
         , AreaRemark
	  FROM PollingUnitView
	 WHERE ThaiYear = COALESCE(@ThaiYear, ThaiYear)
       AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
       AND UPPER(LTRIM(RTRIM(PollingUnitNo))) = UPPER(LTRIM(RTRIM(COALESCE(@PollingUnitNo, PollingUnitNo))))
	 ORDER BY ThaiYear, RegionId, RegionName, ProvinceNameTH

END

GO
