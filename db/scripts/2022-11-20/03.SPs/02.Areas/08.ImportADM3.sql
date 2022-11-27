/****** Object:  StoredProcedure [dbo].[ImportADM3]    Script Date: 11/26/2022 3:41:49 PM ******/
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
-- EXEC ImportADM3 N'TH200117', N'อ่างศิลา', N'Ang Sila', N'TH20', N'TH2001', 6568129.19107
-- =============================================
CREATE PROCEDURE [dbo].[ImportADM3] (
  @ADM3Code nvarchar(20)
, @SubdistrictNameTH nvarchar(100)
, @SubdistrictNameEN nvarchar(100) = NULL
, @ADM1Code nvarchar(20) = NULL
, @ADM2Code nvarchar(20) = NULL
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (   @ADM3Code IS NULL 
		    OR @SubdistrictNameTH IS NULL 
			OR @SubdistrictNameEN IS NULL 
            OR @ADM1Code IS NULL
			OR @ADM2Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
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
		     FROM MSubdistrict
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