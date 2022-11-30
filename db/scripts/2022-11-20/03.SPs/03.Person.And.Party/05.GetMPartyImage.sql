/****** Object:  StoredProcedure [dbo].[GetMPartyImage]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPartyImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @PartyId int
--
-- SET @PartyId = 3
-- 
-- EXEC GetMPartyImage @PartyId, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMPartyImage] (
  @PartyId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
        SELECT PartyId
             , PartyName
             , [Data]
          FROM MParty
         WHERE PartyId = @PartyId
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
