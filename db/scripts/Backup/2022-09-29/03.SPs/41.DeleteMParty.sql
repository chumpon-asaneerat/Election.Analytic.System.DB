--
/****** Object:  StoredProcedure [dbo].[DeleteMParty]    Script Date: 10/1/2022 10:20:10 AM ******/
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
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMParty] (
  @partyName nvarchar(100)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @PartyId int
DECLARE @ContentId uniqueidentifier
	BEGIN TRY
        IF (@partyName IS NULL)
        BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
        END

        SELECT @PartyId = PartyId 
             , @ContentId = ContentId 
          FROM MParty
         WHERE UPPER(LTRIM(RTRIM(PartyName))) = UPPER(LTRIM(RTRIM(@partyName)))

        IF (@PartyId IS NOT NULL)
        BEGIN
            DELETE 
              FROM MParty
             WHERE PartyId = @PartyId
        END

        IF (@ContentId IS NOT NULL)
        BEGIN
            DELETE 
              FROM MContent
             WHERE ContentId = @ContentId
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
