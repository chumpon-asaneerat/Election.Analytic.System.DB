/****** Object:  StoredProcedure [dbo].[ImportADM1]    Script Date: 11/26/2022 3:17:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportADM1
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC ImportADM1 N'TH10', N'กรุงเทพมหานคร', N'Bangkok'
-- =============================================
CREATE PROCEDURE [dbo].[ImportADM1] (
  @ADM1Code nvarchar(20)
, @ProvinceNameTH nvarchar(200)
, @ProvinceNameEN nvarchar(200)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ADM1Code IS NULL OR @ProvinceNameTH IS NULL OR @ProvinceNameEN IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM MProvince
               WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
           ))
		BEGIN
			UPDATE MProvince
			   SET ProvinceNameEN = LTRIM(RTRIM(COALESCE(@ProvinceNameEN, ProvinceNameEN)))
				 , ProvinceNameTH = LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))
				 , AreaM2 = @AreaM2
			 WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
		END
        ELSE
        BEGIN
            INSERT INTO MProvince
            (
                  ADM1Code
                , ProvinceNameEN
                , ProvinceNameTH
                , AreaM2
            )
            VALUES
            (
                  LTRIM(RTRIM(@ADM1Code))
                , LTRIM(RTRIM(@ProvinceNameEN))
                , LTRIM(RTRIM(@ProvinceNameTH))
                , LTRIM(RTRIM(@AreaM2))
            )
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
