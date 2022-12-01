/****** Object:  StoredProcedure [dbo].[DeleteMPerson]    Script Date: 11/26/2022 1:31:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeleteMPerson
-- [== History ==]
-- <2022-09-12> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- 
-- EXEC DeleteMPerson 4, @errNum out, @errMsg out
--  
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MPerson
-- 
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMPerson] (
  @PersonId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @cnt int
	BEGIN TRY
        IF (@PersonId IS NOT NULL)
        BEGIN
            SELECT @cnt = dbo.CheckPersonIdReferences(@PersonId)

            IF (@cnt > 0)
            BEGIN
		        SET @errNum = 201;
		        SET @errMsg = N'Cannot delete data that in used in another table(s).';
                RETURN
            END

            DELETE 
              FROM MPerson
             WHERE PersonId = @PersonId
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
