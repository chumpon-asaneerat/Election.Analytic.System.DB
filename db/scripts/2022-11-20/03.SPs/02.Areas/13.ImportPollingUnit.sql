/****** Object:  StoredProcedure [dbo].[ImportPollingUnit]    Script Date: 11/26/2022 3:17:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportPollingUnit
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportPollingUnit] (
  @ThaiYear int    
, @ProvinceNameTH nvarchar(200)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @AreaRemark nvarchar(MAX) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ADM1Code nvarchar(20)
	BEGIN TRY
		IF (   @ThaiYear IS NULL 
            OR @ProvinceNameTH IS NULL 
            OR @PollingUnitNo IS NULL 
            OR @PollingUnitCount IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		SELECT @ADM1Code = ADM1Code 
		  FROM MProvince
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))

		IF (@ADM1Code IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'ADM1Code is null';
			RETURN
		END

        IF (EXISTS(
              SELECT * 
			    FROM PollingUnit
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
           ))
		BEGIN
			UPDATE PollingUnit
			   SET PollingUnitCount = COALESCE(@PollingUnitCount, PollingUnitCount)
				 , AreaRemark = LTRIM(RTRIM(COALESCE(@AreaRemark, AreaRemark)))
			 WHERE ThaiYear = @ThaiYear
               AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
               AND PollingUnitNo = @PollingUnitNo
		END
        ELSE
        BEGIN
            INSERT INTO PollingUnit
            (
                  ThaiYear
                , ADM1Code
                , PollingUnitNo
                , PollingUnitCount
                , AreaRemark
            )
            VALUES
            (
                  @ThaiYear
                , LTRIM(RTRIM(@ADM1Code))
                , @PollingUnitNo
                , @PollingUnitCount
                , LTRIM(RTRIM(@AreaRemark))
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
