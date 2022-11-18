/****** Object:  StoredProcedure [dbo].[SaveMProvince]    Script Date: 8/29/2022 10:10:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMProvince
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC SaveMProvince N'10', N'10', N'กรุงเทพมหานคร', NULL, NULL
-- =============================================
CREATE PROCEDURE [dbo].[SaveMProvince] (
  @ProvinceId nvarchar(10)
, @RegionId nvarchar(10)
, @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100) = NULL
, @ADM1Code nvarchar(20) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@RegionId IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId is null';
			RETURN
		END

		IF ((@ProvinceId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MProvince
				 WHERE RegionId = @RegionId
				   AND ProvinceId = @ProvinceId
			)
		   )
		BEGIN
			INSERT INTO MProvince
			(
				  RegionId
				, ProvinceId 
				, ProvinceNameEN
				, ProvinceNameTH
				, ADM1Code
			)
			VALUES
			(
				  @RegionId
				, @ProvinceId
				, @ProvinceNameEN
				, @ProvinceNameTH
				, @ADM1Code
			);
		END
		ELSE
		BEGIN
			UPDATE MProvince
			   SET ProvinceNameEN = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameEN, ProvinceNameEN))))
				 , ProvinceNameTH = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
				 , ADM1Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
			 WHERE RegionId = @RegionId
			   AND ProvinceId = @ProvinceId
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

