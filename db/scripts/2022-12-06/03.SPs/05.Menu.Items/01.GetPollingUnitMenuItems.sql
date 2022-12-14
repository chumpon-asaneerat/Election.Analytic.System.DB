/****** Object:  StoredProcedure [dbo].[GetPollingUnitMenuItems]    Script Date: 11/30/2022 2:13:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPollingUnitMenuItems
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPollingUnitMenuItems]
(
  @RegionId nvarchar(20) = NULL
, @ADM1Code nvarchar(20) = NULL
)
AS
BEGIN
	SELECT MIN(ThaiYear) AS ThaiYear
	     , RegionId
		 , RegionName
		 , ADM1Code
		 , ProvinceNameTH
		 , PollingUnitNo
	  FROM PollingUnitView 
     WHERE UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
       AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	 GROUP BY RegionId, RegionName, ADM1Code, ProvinceNameTH, PollingUnitNo
END

GO
