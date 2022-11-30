/****** Object:  StoredProcedure [dbo].[ImportMPersonImage]    Script Date: 11/26/2022 1:41:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPersonImage
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPersonImage] (
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
DECLARE @GenderId int;
	BEGIN TRY
        -- Parse Full Name into Prefix, FirstName, LastName
        EXEC Parse_FullName @FullName, @Prefix out, @FirstName out, @LastName out

        IF (@FirstName IS NULL AND @LastName IS NULL)
        BEGIN
		    SET @errNum = 100;
		    SET @errMsg = 'Parser cannot extract firstname and lastname.';
            RETURN
        END

        SELECT @GenderId = GenderId 
          FROM MTitle 
         WHERE UPPER(LTRIM(RTRIM([Description]))) = UPPER(LTRIM(RTRIM(@Prefix)))
        
        IF (@GenderId IS NULL) SET @GenderId = 0

        -- Call Save to get PartyId
        EXEC SaveMPerson @Prefix, @FirstName, @LastName
                       , NULL -- DOB
                       , @GenderId -- GenderId
                       , NULL -- EducationId
                       , NULL -- OccupationId
                       , NULL -- Remark
                       , @PersonId out -- PersonId
                       , @errNum out, @errMsg out

        IF (@errNum <> 0)
        BEGIN
            RETURN
        END

		IF (@PersonId IS NOT NULL)
		BEGIN
			UPDATE MPerson
			   SET [Data] = @Data
             WHERE PersonId = @PersonId;
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
