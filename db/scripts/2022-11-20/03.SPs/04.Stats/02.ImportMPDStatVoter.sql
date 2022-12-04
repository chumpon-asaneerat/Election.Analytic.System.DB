/****** Object:  StoredProcedure [dbo].[ImportMPDStatVoter]    Script Date: 11/26/2022 3:17:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPDStatVoter
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(max)
-- DECLARE @ProvinceName nvarchar(200)
-- DECLARE @PollingUnitNo int
-- DECLARE @RightCount int
-- DECLARE @ExerciseCount int
-- DECLARE @InvalidCount int
-- DECLARE @NoVoteCount int
-- 
-- SET @ProvinceName = N'เชียงใหม่'
-- SET @PollingUnitNo = 1
-- SET @RightCount = 20
-- SET @ExerciseCount = 10
-- SET @InvalidCount = 6
-- SET @NoVoteCount = 4
-- 
-- EXEC ImportMPDStatVoter 2562
--                       , @ProvinceName, @PollingUnitNo
-- 						 , @RightCount, @ExerciseCount, @InvalidCount, @NoVoteCount
-- 						 , @errNum out, @errMsg out
-- SELECT @errNum as ErrNum, @errMsg as ErrMsg
-- 
-- -- =============================================
CREATE PROCEDURE [dbo].[ImportMPDStatVoter] (
  @ThaiYear int    
, @ProvinceNameTH nvarchar(200)
, @PollingUnitNo int
, @RightCount int = 0
, @ExerciseCount int = 0
, @InvalidCount int = 0
, @NoVoteCount int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @ADM1Code nvarchar(20)
DECLARE @Prefix nvarchar(MAX) = null
DECLARE @FirstName nvarchar(MAX) = null
DECLARE @LastName nvarchar(MAX) = null
	BEGIN TRY
		IF (   @ThaiYear IS NULL 
            OR @ProvinceNameTH IS NULL 
            OR @PollingUnitNo IS NULL
           )
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
			    FROM MPDStatVoter
			   WHERE ThaiYear = @ThaiYear
                 AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
                 AND PollingUnitNo = @PollingUnitNo
           ))
		BEGIN
            UPDATE MPDStatVoter
               SET RightCount = COALESCE(@RightCount, RightCount)
                 , ExerciseCount = COALESCE(@ExerciseCount, ExerciseCount)
                 , InvalidCount = COALESCE(@InvalidCount, InvalidCount)
                 , NoVoteCount = COALESCE(@NoVoteCount, NoVoteCount)
             WHERE ThaiYear = @ThaiYear
               AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
               AND PollingUnitNo = @PollingUnitNo
		END
        ELSE
        BEGIN
            INSERT INTO MPDStatVoter
            (
                  ThaiYear
                , ADM1Code
                , PollingUnitNo
                , RightCount
                , ExerciseCount
                , InvalidCount
                , NoVoteCount
            )
            VALUES
            (
                  @ThaiYear
                , LTRIM(RTRIM(@ADM1Code))
                , @PollingUnitNo
                , @RightCount
                , @ExerciseCount
                , @InvalidCount
                , @NoVoteCount
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
