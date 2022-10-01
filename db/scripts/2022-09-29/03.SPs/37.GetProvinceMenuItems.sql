/****** Object:  StoredProcedure [dbo].[GetProvinceMenuItems]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetProvinceMenuItems
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetProvinceMenuItems]
(
  @RegionId nvarchar(10)
)
AS
BEGIN
    SELECT A.RegionId
         , A.ProvinceId
         , A.ProvinceNameTH
         , COUNT(A.PollingUnitNo) AS UnitCount
      FROM MPDPollingUnitSummary A 
     WHERE A.RegionId = @RegionId
       AND A.RegionId IS NOT NULL
     GROUP BY A.RegionId
            , A.ProvinceId
            , A.ProvinceNameTH
     ORDER BY A.RegionId
            , A.ProvinceNameTH
END

GO
