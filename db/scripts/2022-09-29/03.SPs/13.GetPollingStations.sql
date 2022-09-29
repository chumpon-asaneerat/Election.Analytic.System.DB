/****** Object:  StoredProcedure [dbo].[GetPollingStations]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPollingStations
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPollingStations]
(
  @RegionName nvarchar(100) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
        FROM PollingStationView 
        WHERE UPPER(LTRIM(RTRIM(RegionName))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName))))
        AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
        ORDER BY RegionId 
            , ProvinceNameTH 
            , DistrictNameTH 
            , SubdistrictNameTH 
END

GO
