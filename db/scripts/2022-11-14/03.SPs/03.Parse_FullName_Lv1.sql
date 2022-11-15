/****** Object:  StoredProcedure [dbo].[Parse_FullName_Lv1]    Script Date: 11/14/2022 9:02:01 AM ******/
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
ALTER PROCEDURE [dbo].[Parse_FullName_Lv1] (
  @fullName nvarchar(MAX)
, @el nvarchar(MAX)
, @prefix nvarchar(MAX) = NULL out
, @firstName nvarchar(MAX) = NULL out
, @lastName nvarchar(MAX) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @fullTitle nvarchar(MAX);
DECLARE @shotTitle nvarchar(MAX);
DECLARE @title nvarchar(MAX);
DECLARE @matchTitle nvarchar(MAX);
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

		SELECT TOP 1 
		       @fullTitle = [Description]
		     , @shotTitle = ShortName
		  FROM MTitleView
		 WHERE @el LIKE [Description] + '%' 
		 ORDER BY DLen DESC

		IF (@fullTitle IS NOT NULL)
		BEGIN
			-- MATCH TITLE
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
			SET @firstName = LTRIM(RTRIM(SUBSTRING(@el, 1 + LEN(@matchTitle), LEN(@fullName) - LEN(@matchTitle))))
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
