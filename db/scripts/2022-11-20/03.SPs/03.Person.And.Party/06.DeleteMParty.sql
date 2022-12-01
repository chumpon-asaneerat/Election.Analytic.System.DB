/****** Object:  StoredProcedure [dbo].[DeleteMParty]    Script Date: 11/26/2022 1:31:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeleteMParty
-- [== History ==]
-- <2022-09-12> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- 
-- EXEC DeleteMParty 4, @errNum out, @errMsg out
--  
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MParty
-- 
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMParty] (
  @PartyId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @cnt int
	BEGIN TRY
        IF (@PartyId IS NOT NULL)
        BEGIN
            SELECT @cnt = dbo.CheckPartyIdReferences(@PartyId)

            IF (@cnt > 0)
            BEGIN
		        SET @errNum = 201;
		        SET @errMsg = N'Cannot delete data that in used in another table(s).';
                RETURN
            END

            DELETE 
            FROM MParty
            WHERE PartyId = @PartyId
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
