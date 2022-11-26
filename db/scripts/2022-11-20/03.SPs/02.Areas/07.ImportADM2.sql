/****** Object:  StoredProcedure [dbo].[ImportADM2]    Script Date: 11/26/2022 3:33:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportADM2
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- ImportADM2 N'TH4711', N'อากาศอำนวย', N'Akat Amnuai', N'TH47', 661338974.564
-- =============================================
CREATE PROCEDURE [dbo].[ImportADM2] (
  @ADM2Code nvarchar(20)
, @DistrictNameTH nvarchar(200)
, @DistrictNameEN nvarchar(200)
, @ADM1Code nvarchar(20)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (   @ADM2Code IS NULL 
		    OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL 
			OR @ADM1Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM MDistrict
               WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(@ADM2Code)))
           ))
		BEGIN
			UPDATE MDistrict
			   SET DistrictNameEN = LTRIM(RTRIM(COALESCE(@DistrictNameEN, DistrictNameEN)))
				 , DistrictNameTH = LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH)))
				 , ADM1Code = UPPER(LTRIM(RTRIM(@ADM1Code)))
				 , AreaM2 = @AreaM2
			  FROM MDistrict
			 WHERE UPPER(LTRIM(RTRIM(ADM2Code))) = UPPER(LTRIM(RTRIM(@ADM2Code)))
		END
        ELSE
        BEGIN
            INSERT INTO MDistrict
            (
                  ADM2Code
                , DistrictNameEN
                , DistrictNameTH
                , ADM1Code
                , AreaM2
            )
            VALUES
            (
                  LTRIM(RTRIM(@ADM2Code))
                , LTRIM(RTRIM(@DistrictNameEN))
                , LTRIM(RTRIM(@DistrictNameTH))
                , LTRIM(RTRIM(@ADM1Code))
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
