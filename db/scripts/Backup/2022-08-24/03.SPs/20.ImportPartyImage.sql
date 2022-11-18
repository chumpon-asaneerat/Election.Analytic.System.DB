/****** Object:  StoredProcedure [dbo].[ImportPartyImage]    Script Date: 8/29/2022 1:57:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportPartyImage
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
-- EXEC ImportPartyImage @partyName, @data, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MParty
-- 
-- SELECT A.PartyId
--      , A.PartyName
--      , B.Data
--      , CONVERT(NVARCHAR(MAX), B.Data) AS JsonData
--   FROM MParty A, MContent B
-- =============================================
CREATE PROCEDURE [dbo].[ImportPartyImage] (
  @partyName nvarchar(100)
, @Data varbinary(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @LastUpdate datetime;
DECLARE @FileTypeId int = 1;    -- 1: Images
DECLARE @FileSubTypeId int = 2; -- 1: Person, 2: Logo
DECLARE @PartyId int;
DECLARE @ContentId uniqueidentifier;
DECLARE @IsNewContentId bit;
	BEGIN TRY
        -- SET LAST UPDATE DATETIME
	    SET @LastUpdate = GETDATE();
		SELECT @PartyId = PartyId
		     , @ContentId = ContentId
		  FROM MParty
		 WHERE UPPER(LTRIM(RTRIM(PartyName))) = UPPER(LTRIM(RTRIM(@PartyName)))

		IF (@PartyId IS NULL)
		BEGIN
			INSERT INTO MParty
			(
				  PartyName 
			)
			VALUES
			(
				  @PartyName
			);

			SET @PartyId = @@IDENTITY;
		END

		IF (@ContentId IS NULL)  
		BEGIN
			SET @IsNewContentId = 1
		END

		-- SAVE IMAGE
		EXEC SaveMContent @Data, @FileTypeId, @FileSubTypeId, @ContentId out, @errNum out, @errMsg out

		IF (@errNum = 0)
		BEGIN
		    -- SAVE IMAGE WITH NO ERROR
			IF (@IsNewContentId = 1)
			BEGIN
				-- Update Content Id back to MParty Table
				UPDATE MParty
				   SET ContentId = @ContentId
				 WHERE PartyId = @PartyId
			END
			-- Update Error Status/Message
			SET @errNum = 0;
			SET @errMsg = 'Success';
		END
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
