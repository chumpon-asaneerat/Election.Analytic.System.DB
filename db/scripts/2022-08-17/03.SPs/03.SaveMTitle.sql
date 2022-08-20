/****** Object:  StoredProcedure [dbo].[SaveMTitle]    Script Date: 8/20/2022 8:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMTitle
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveMTitle N'นางสาว1', N'น.ส.1', 2;
-- =============================================
CREATE PROCEDURE [dbo].[SaveMTitle] (
  @Description nvarchar(100)
, @ShortName nvarchar(50)
, @GenderId int = 0
, @TitleId int out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF ((@TitleId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MTitle
				 WHERE TitleId = @TitleId
			)
		   )
		BEGIN
		    -- Get New ID.
		    SELECT @TitleId = (MAX(TitleId) + 1)
			  FROM MTitle;
			-- NEW ID should over than 9000
			IF (@TitleId < 9000) SET @TitleId = 9000

			INSERT INTO MTitle
			(
				  TitleId
				, [Description]
				, ShortName
				, GenderId
			)
			VALUES
			(
				  @TitleId
				, @Description
				, @ShortName
				, @GenderId
			);
		END
		ELSE
		BEGIN
			UPDATE MTitle
			   SET [Description] = @Description
				 , ShortName = @ShortName
				 , GenderId = @GenderId
			 WHERE TitleId = @TitleId
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
