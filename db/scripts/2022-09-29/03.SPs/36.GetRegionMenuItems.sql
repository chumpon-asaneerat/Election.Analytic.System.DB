/****** Object:  StoredProcedure [dbo].[GetRegionMenuItems]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetRegionMenuItems
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetRegionMenuItems]
AS
BEGIN
    SELECT RegionId, RegionName
      FROM MRegion 
     ORDER BY RegionId
END

GO
