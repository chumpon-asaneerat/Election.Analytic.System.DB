SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMRegion
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveMRegion N'01', N'ภาค 1', N'กลาง', N'กลาง';
--exec SaveMRegion N'02', N'ภาค 2', N'ตะวันออก', N'ตะวันออก';
--exec SaveMRegion N'03', N'ภาค 3', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนล่าง';
--exec SaveMRegion N'04', N'ภาค 4', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนบน';
--exec SaveMRegion N'05', N'ภาค 5', N'เหนือ', N'เหนือตอนบน';
--exec SaveMRegion N'06', N'ภาค 6', N'เหนือ', N'เหนือตอนล่าง';
--exec SaveMRegion N'07', N'ภาค 7', N'ตะวันตก', N'ตะวันตก';
--exec SaveMRegion N'08', N'ภาค 8', N'ใต้', N'ใต้ตอนบน';
--exec SaveMRegion N'09', N'ภาค 9', N'ใต้', N'ใต้ตอนล่าง';
--exec SaveMRegion N'10', N'ภาค 10', N'กลาง', N'กรุงเทพมหานคร';
-- =============================================
CREATE PROCEDURE SaveMRegion (
  @RegionId nvarchar(10)
, @RegionName nvarchar(100)
, @GeoGroup nvarchar(100)
, @GeoSubGroup nvarchar(100)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
BEGIN TRY
	IF NOT EXISTS 
	(
		SELECT * 
		  FROM MRegion
		 WHERE RegionId = @RegionId
	)
	BEGIN
		INSERT INTO MRegion
		(
			  RegionId
			, RegionName 
			, GeoGroup
			, GeoSubGroup
		)
		VALUES
		(
			  @RegionId
			, @RegionName
			, @GeoGroup
			, @GeoSubGroup
		);
	END
	ELSE
	BEGIN
		UPDATE MRegion
		   SET RegionName = @RegionName
		     , GeoGroup = @GeoGroup
		     , GeoSubGroup = @GeoSubGroup
		 WHERE RegionId = @RegionId
	END

		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
