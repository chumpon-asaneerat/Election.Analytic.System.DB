SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMProvinceADM1
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC SaveMProvinceADM1 N'กรุงเทพมหานคร', N'Bangkok', N'TH10'
-- =============================================
CREATE PROCEDURE [dbo].[SaveMProvinceADM1] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @ADM1Code nvarchar(20)
, @AreaKm2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceNameTH IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter ProvinceNameTH is null';
			RETURN
		END

		IF ((@ProvinceNameTH IS NOT NULL) 
		    AND
		    (@ProvinceNameEN IS NOT NULL)
		    AND
		    (@ADM1Code IS NOT NULL)
            AND
            EXISTS 
			(
				SELECT * 
				  FROM MProvince
				 WHERE ProvinceNameTH = @ProvinceNameTH
			)
		   )
		BEGIN
			UPDATE MProvince
			   SET ProvinceNameEN = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameEN, ProvinceNameEN))))
				 , ADM1Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
				 , AreaKm2 = @AreaKm2
			 WHERE ProvinceNameTH = @ProvinceNameTH
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
