/****** Object:  StoredProcedure [dbo].[SaveMParty]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMParty
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @partyId int
-- DECLARE @partyName nvarchar(200)
-- 
-- SET @partyName = N'พลังประชารัฐ 2';
-- EXEC SaveMParty @partyName, @partyId out, @errNum out, @errMsg out
-- 
-- SELECT @partyId AS PartyId
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MParty
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SaveMParty] (
  @partyName nvarchar(200)
, @PartyId int = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @matchId int
	BEGIN TRY
        -- FIND ID
        IF (@PartyId IS NULL OR @PartyId <= 0)
        BEGIN
            SELECT @matchId = PartyId 
              FROM MParty 
             WHERE UPPER(LTRIM(RTRIM(PartyName))) = UPPER(LTRIM(RTRIM(@PartyName)))
            -- REPLACE ID IN CASE PartyName is EXISTS but not specificed Id when call this SP
            SET @PartyId = @matchId
        END

		IF (@PartyId IS NULL)
		BEGIN
			INSERT INTO MParty
			(
				  PartyName 
			)
			VALUES
			(
				  LTRIM(RTRIM(@PartyName))
			);

			SET @PartyId = @@IDENTITY;
		END
        ELSE
        BEGIN
            UPDATE MParty
               SET PartyName = LTRIM(RTRIM(@PartyName))
             WHERE PartyId = @PartyId;
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
