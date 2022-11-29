/****** Object:  StoredProcedure [dbo].[ImportADM3]    Script Date: 11/29/2022 7:23:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportADM3
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC ImportADM3 N'TH200117', N'อากาศ', N'Akat', N'อากาศอำนวย', N'Akat Amnuai', N'สกลนคร', N'Sakon Nakhon', 6568129.19107
-- =============================================
CREATE PROCEDURE [dbo].[ImportADM3] (
  @ADM3Code nvarchar(20)
, @SubdistrictNameTH nvarchar(100)
, @SubdistrictNameEN nvarchar(100) = NULL
, @DistrictNameTH nvarchar(200)
, @DistrictNameEN nvarchar(200)
, @ProvinceNameTH nvarchar(200)
, @ProvinceNameEN nvarchar(200)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ADM1Code nvarchar(20)
DECLARE @ADM2Code nvarchar(20)
	BEGIN TRY
		IF (   @SubdistrictNameTH IS NULL 
			OR @SubdistrictNameEN IS NULL
		    OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL
		    OR @ProvinceNameTH IS NULL 
			OR @ProvinceNameEN IS NULL
			OR @ADM3Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @ADM1Code = ADM1Code 
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
		   AND UPPER(LTRIM(RTRIM(ProvinceNameEN))) = UPPER(LTRIM(RTRIM(@ProvinceNameEN)))

		SELECT @ADM2Code = ADM2Code 
		  FROM MDistrict
		 WHERE UPPER(LTRIM(RTRIM(DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))
		   AND UPPER(LTRIM(RTRIM(DistrictNameEN))) = UPPER(LTRIM(RTRIM(@DistrictNameEN)))

		IF (@ADM1Code IS NULL OR @ADM2Code IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'ADM1Code or ADM2Code is null';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM MSubdistrict
               WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(@ADM3Code)))
           ))
		BEGIN
			UPDATE MSubdistrict
			   SET SubdistrictNameEN = LTRIM(RTRIM(COALESCE(@SubdistrictNameEN, SubdistrictNameEN)))
				 , SubdistrictNameTH = LTRIM(RTRIM(COALESCE(@SubdistrictNameTH, SubdistrictNameTH)))
				 , ADM1Code = UPPER(LTRIM(RTRIM(@ADM1Code)))
				 , ADM2Code = UPPER(LTRIM(RTRIM(@ADM2Code)))
				 , AreaM2 = @AreaM2
			 WHERE UPPER(LTRIM(RTRIM(ADM3Code))) = UPPER(LTRIM(RTRIM(@ADM3Code)))
		END
        ELSE
        BEGIN
            INSERT INTO MSubdistrict
            (
                  ADM3Code
                , SubdistrictNameEN
                , SubdistrictNameTH
                , ADM1Code
                , ADM2Code
                , AreaM2
            )
            VALUES
            (
                  LTRIM(RTRIM(@ADM3Code))
                , LTRIM(RTRIM(@SubdistrictNameEN))
                , LTRIM(RTRIM(@SubdistrictNameTH))
                , LTRIM(RTRIM(@ADM1Code))
                , LTRIM(RTRIM(@ADM2Code))
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
