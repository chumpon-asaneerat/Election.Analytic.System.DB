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
/*
CREATE PROCEDURE [dbo].[GetPollingUnitMenuItems]
(
  @RegionId nvarchar(10)
, @ProvinceId nvarchar(10)
)
AS
BEGIN
    SELECT *
      FROM MPDPollingUnitSummary
     WHERE RegionId = @RegionId
       AND ProvinceId = @ProvinceId
END

GO
*/