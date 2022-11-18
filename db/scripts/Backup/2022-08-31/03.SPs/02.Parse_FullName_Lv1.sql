/****** Object:  StoredProcedure [dbo].[Parse_FullName_Lv1]    Script Date: 9/1/2022 9:12:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Parse FullName level 1
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[Parse_FullName_Lv1] (
  @fullName nvarchar(4000)
, @el nvarchar(100)
, @prefix nvarchar(100) = NULL out
, @firstName nvarchar(100) = NULL out
, @lastName nvarchar(100) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @fullTitle nvarchar(100);
DECLARE @shotTitle nvarchar(100);
DECLARE @title nvarchar(100);
DECLARE @matchTitle nvarchar(100);
	-- EXTRACT Prefix/FirstName from element
	BEGIN TRY
		-- CHECK PARAMETERS
		IF (    (@fullName IS NULL OR LEN(@fullName) = 0)
		     OR (@el IS NULL OR LEN(@el) = 0)
		   )
		BEGIN
			SET @errNum = 100;
			SET @errMsg = N'Parameter(s) is null.';
		END

		-- Find Match Description.
		SELECT TOP 1 @fullTitle = [Description]
		  FROM MTitleView
		 WHERE @el LIKE [Description] + '%' 
		 ORDER BY DLen DESC

		IF (@fullTitle IS NULL)
		BEGIN
			-- No Match Description so try with Short Name.
			SELECT TOP 1 @fullTitle = [Description], @shotTitle = ShortName
			  FROM MTitleView
			 WHERE @el LIKE ShortName + '%'
			 ORDER BY SLen DESC
			IF (@shotTitle IS NOT NULL)
			BEGIN
				-- MATCH SHORT TITLE
				SET @title = @fullTitle
				-- Keep it to used later for substring function
				SET @matchTitle = @shotTitle
			END
		END
		ELSE
		BEGIN
			-- Match Description
			SET @title = @fullTitle
			-- Keep it to used later for substring function
			SET @matchTitle = @fullTitle
		END

		IF (@title IS NULL)
		BEGIN
			-- NO TITLE MATCH SO IT SEEM TO BE ONLY FIRSTNAME + LASTNAME WITHOUT SEPERATE SPACE
			SET @firstName = @el
		END
		ELSE
		BEGIN
			-- TITLE MATCH SO IT SPLIT PREFIX, FIRSTNAME + LASTNAME WITHOUT SEPERATE SPACE
			SET @prefix = @title
			SET @firstName = SUBSTRING(@el, 1 + LEN(@matchTitle), LEN(@fullName) - LEN(@matchTitle))
		END

		IF (@firstName IS NOT NULL AND LEN(@firstName) = 0) 
			SET @firstName = NULL;

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
