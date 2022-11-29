/****** Object:  StoredProcedure [dbo].[GetProvinceMenuItems]    Script Date: 11/30/2022 2:13:28 AM ******/
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
    ;WITH PU_2562
    AS
    (
        SELECT RegionId, ADM1Code, ProvinceNameTH
             , COUNT(PollingUnitNo) AS UnitCount
         FROM PollingUnitView
        WHERE RegionId IS NOT NULL
          AND RegionId = @RegionId
          AND ThaiYear = 2562
        GROUP BY RegionId, ADM1Code, ProvinceNameTH
        --ORDER BY RegionId, ProvinceNameTH
    ), PU_2566
    AS
    (
        SELECT RegionId, ADM1Code, ProvinceNameTH
             , COUNT(PollingUnitNo) AS UnitCount
         FROM PollingUnitView
        WHERE RegionId IS NOT NULL
          AND RegionId = @RegionId
          AND ThaiYear = 2566
        GROUP BY RegionId, ADM1Code, ProvinceNameTH
        --ORDER BY RegionId, ProvinceNameTH
    ), PU
    AS
    (
        SELECT * FROM PU_2562
        UNION
        (
            SELECT * FROM PU_2566 
            EXCEPT
            SELECT * FROM PU_2562
        )
        
    )
    SELECT RegionId, ADM1Code, ProvinceNameTH
         , MIN(UnitCount) AS MinUnitCount
         , MAX(UnitCount) AS MaxUnitCount
     FROM PU
    GROUP BY RegionId, ADM1Code, ProvinceNameTH
    ORDER BY RegionId, ProvinceNameTH
END

GO
