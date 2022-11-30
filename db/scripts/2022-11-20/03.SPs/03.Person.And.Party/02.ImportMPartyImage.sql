/****** Object:  StoredProcedure [dbo].[ImportMPartyImage]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPartyImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @partyName nvarchar(100)
-- 
-- DECLARE @jsonData NVARCHAR(MAX) = N'{"age":1,"name":"sample"}'
-- DECLARE @data VARBINARY(MAX) = CONVERT(VARBINARY(MAX), @jsonData)
-- 
-- SET @partyName = N'พลังประชารัฐ';
-- EXEC ImportMPartyImage @partyName, @data, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MParty
-- 
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPartyImage] (
  @partyName nvarchar(200)
, @Data varbinary(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @PartyId int;
	BEGIN TRY
        -- CHECKS PartyId
		SELECT @PartyId = PartyId
		  FROM MParty
		 WHERE UPPER(LTRIM(RTRIM(PartyName))) = UPPER(LTRIM(RTRIM(@PartyName)))

		IF (@PartyId IS NULL)
		BEGIN
			INSERT INTO MParty
			(
				  PartyName 
                , [Data]
			)
			VALUES
			(
				  @PartyName
                , @Data
			);

			SET @PartyId = @@IDENTITY;
		END
        ELSE
        BEGIN
            UPDATE MParty
               SET [Data] = @Data
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
