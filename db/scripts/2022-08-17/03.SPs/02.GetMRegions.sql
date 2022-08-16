SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMRegions
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMRegions NULL, NULL, NULL, NULL      -- Gets all
-- EXEC GetMRegions NULL, N'1', NULL, NULL      -- Search all that RegionName contains '1'
-- EXEC GetMRegions NULL, NULL, N'เหนือ', NULL   -- Search all that GeoGroup contains 'เหนือ'
-- EXEC GetMRegions NULL, NULL, NULL, N'ตอนบน'  -- Search all that GeoSubGroup contains 'ตอนบน'
-- =============================================
CREATE PROCEDURE GetMRegions
(
  @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
	  FROM MRegion
	 WHERE UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY RegionId
END

GO
