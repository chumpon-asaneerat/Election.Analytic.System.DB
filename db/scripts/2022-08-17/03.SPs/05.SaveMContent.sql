/****** Object:  StoredProcedure [dbo].[SaveMContent]    Script Date: 8/20/2022 8:41:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMContent
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @contentId uniqueidentifier
-- 
-- DECLARE @jsonData NVARCHAR(MAX) = N'{"age":1,"name":"sample"}'
-- DECLARE @data VARBINARY(MAX) = CONVERT(VARBINARY(MAX), @jsonData)
-- 
-- EXEC SaveMContent @data, NULL, NULL, @contentId out, @errNum out, @errMsg out
-- 
-- SELECT @contentId AS ContentId, @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT ContentId
--      , Data
--      , CONVERT(NVARCHAR(MAX), Data) AS JsonData
--   FROM MContent
-- 
-- -- CHANGE DATA
-- SET @jsonData = N'{"age":100,"name":"sample 222"}'
-- SET @data = CONVERT(VARBINARY(MAX), @jsonData)
-- EXEC SaveMContent @data, NULL, NULL, @contentId out, @errNum out, @errMsg out
-- 
-- SELECT @contentId AS ContentId, @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT ContentId
--      , Data
--      , CONVERT(NVARCHAR(MAX), Data) AS JsonData
--   FROM MContent
-- =============================================
CREATE PROCEDURE [dbo].[SaveMContent] (
  @data varbinary(MAX)
, @fileTypeId int = NULL
, @fileSubTypeId int = NULL
, @contentId uniqueidentifier out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF ((@contentId IS NULL)
			OR 
			NOT EXISTS 
			(
				SELECT * 
				  FROM MContent
				 WHERE ContentId = @contentId 
			)
		   )
		BEGIN
			SET @contentId = NEWID();
			INSERT INTO MContent
			(
				  ContentId
				, Data 
				, FileTypeId
				, FileSubTypeId
			)
			VALUES
			(
				  @contentId
				, @data
				, @fileTypeId
				, @fileSubTypeId
			);
		END
		ELSE
		BEGIN
			UPDATE MContent
			   SET Data = @data
				 , FileTypeId = @fileTypeId
				 , FileSubTypeId = @fileSubTypeId
			 WHERE @contentId = @contentId
		END
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
