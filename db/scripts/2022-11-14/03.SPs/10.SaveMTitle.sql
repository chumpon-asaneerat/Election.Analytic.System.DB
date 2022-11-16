/****** Object:  StoredProcedure [dbo].[SaveMTitle]    Script Date: 11/16/2022 2:20:20 PM ******/
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
--exec SaveMTitle N'นางสาว1', 2;
-- =============================================
ALTER PROCEDURE [dbo].[SaveMTitle] (
  @Description nvarchar(100)
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
			INSERT INTO MTitle
			(
				  [Description]
				, GenderId
			)
			VALUES
			(
				  @Description
				, @GenderId
			);
		    -- Get New ID.
            SELECT @TitleId = @@IDENTITY
		END
		ELSE
		BEGIN
			UPDATE MTitle
			   SET [Description] = @Description
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
