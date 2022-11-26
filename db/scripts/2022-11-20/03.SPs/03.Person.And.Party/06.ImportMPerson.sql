/****** Object:  StoredProcedure [dbo].[ImportPerson]    Script Date: 11/26/2022 1:41:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportPerson
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportPerson] (
  @FullName nvarchar(MAX)
, @Data varbinary(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @PersonId int;
DECLARE @Prefix nvarchar(100)
DECLARE @FirstName nvarchar(200)
DECLARE @LastName nvarchar(200)
	BEGIN TRY
        -- Parse Full Name into Prefix, FirstName, LastName
        EXEC Parse_FullName @FullName, @Prefix out, @FirstName out, @LastName out

        IF (@FirstName IS NULL AND @LastName IS NULL)
        BEGIN
		    SET @errNum = 100;
		    SET @errMsg = 'Parser cannot extract firstname and lastname.';
            RETURN
        END

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPerson
			     WHERE LTRIM(RTRIM(FirstName)) = LTRIM(RTRIM(@FirstName))
                   AND LTRIM(RTRIM(LastName)) = LTRIM(RTRIM(@LastName))
			)
		   )
		BEGIN
			INSERT INTO MPerson
			(
				  Prefix
				, FirstName
				, LastName
				, [Data] 
			)
			VALUES
			(
				  @Prefix
                , @FirstName
                , @LastName
				, @Data
			);

            SET @PersonId = @@IDENTITY;
		END
		ELSE
		BEGIN
			UPDATE MPerson
			   SET [Data] = @Data
                 , Prefix = LTRIM(RTRIM(@Prefix))
			 WHERE LTRIM(RTRIM(FirstName)) = LTRIM(RTRIM(@FirstName))
               AND LTRIM(RTRIM(LastName)) = LTRIM(RTRIM(@LastName))
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
