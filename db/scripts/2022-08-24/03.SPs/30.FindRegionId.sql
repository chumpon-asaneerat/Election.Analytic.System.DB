/****** Object:  UserDefinedFunction [dbo].[FindRegionId]    Script Date: 8/29/2022 8:52:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: Chumpon Asaneerat
-- Name: indRegionId.
-- Description:	IsNullOrEmpty is function to check is string is in null or empty
--              returns 1 if string is null or empty string otherwise return 0.
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.FindRegionId(N'ภาค 10') AS RegionId;
-- =============================================
CREATE FUNCTION [dbo].[FindRegionId]
(
  @RegionName nvarchar(100)
)
RETURNS nvarchar(10)
AS
BEGIN
DECLARE @diff int;
DECLARE @RegionId nvarchar(10);
	SET @RegionId = NULL;

	SELECT @RegionId = RegionId
	  FROM MRegion
	 WHERE UPPER(LTRIM(RTRIM(RegionName))) = UPPER(LTRIM(RTRIM(@RegionName)))

	RETURN @RegionId;
END

GO


