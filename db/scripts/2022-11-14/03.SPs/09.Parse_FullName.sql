/****** Object:  StoredProcedure [dbo].[Parse_FullName]    Script Date: 11/14/2022 9:02:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Extract Prefix, FirstName, LastName from FullName
-- [== History ==]
-- <2022-11-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[Parse_FullName] (
  @fullName nvarchar(MAX)
, @prefix nvarchar(MAX) = NULL out
, @firstName nvarchar(MAX) = NULL out
, @lastName nvarchar(MAX) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @sFullName nvarchar(MAX);
DECLARE @deli nvarchar(20) = N' ';
DECLARE @isRemove int; -- 0: Not Removed, 1: Removed
DECLARE @el nvarchar(MAX) = NULL;
DECLARE @sTest nvarchar(MAX);
DECLARE @sRemain nvarchar(MAX); -- Remain Text
DECLARE @fullTitle nvarchar(MAX);
DECLARE @matchTitle nvarchar(MAX);
	BEGIN TRY
		SET @prefix = NULL
		SET @firstName = NULL
		SET @lastName = NULL

		-- CHECK PARAMETERS
		IF (@fullName IS NULL OR LEN(@fullName) = 0)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = N'Parameter(s) is null.';
		END

		SET @sFullName = REPLACE(@fullName, N' ', N'') -- FullName that remove all spaces

		SELECT TOP 1 
		       @fullTitle = [Description]
			 , @matchTitle = REPLACE([Description], N' ', N'')
		  FROM MTitleView
		 WHERE @sFullName LIKE REPLACE([Description], N' ', N'') + N'%'
		 ORDER BY DLen DESC

		IF (@fullTitle IS NOT NULL)
		BEGIN
			SET @prefix = @fullTitle
			SET @isRemove = 0
			SET @sTest = N''
		END

		DECLARE SPLIT_STR_CURSOR CURSOR 
		  LOCAL FORWARD_ONLY READ_ONLY FAST_FORWARD 
		FOR  
		  SELECT Item FROM dbo.SplitStringT(@fullName, @deli)

		OPEN SPLIT_STR_CURSOR  
		-- FETCH FIRST
		FETCH NEXT FROM SPLIT_STR_CURSOR INTO @el

		WHILE @@FETCH_STATUS = 0  
		BEGIN
			IF ((@matchTitle IS NOT NULL) AND (@isRemove = 0))
			BEGIN
				-- @matchTitle is Title that remove all spaces.
				-- and @sTest also remove all spaces.
				IF (@sTest IS NULL) SET @sTest = N''
				SET @sTest = LTRIM(RTRIM(@sTest + @el))

				IF (@sTest LIKE @matchTitle + N'%')
				BEGIN
					SET @sRemain = REPLACE(@sTest, @matchTitle, N'')
					IF (LEN(@sRemain) > 0) SET @firstName = @sRemain
					SET @isRemove = 1 -- MARK AS REMOVED
				END
			END
			ELSE
			BEGIN
				-- PREFIX NOT FOUND -> FIND FIRST NAME
				IF (@firstName IS NULL)
				BEGIN
					-- FIRST NAME NOT FOUND SO USER CURRENT TEST VARIABLE
					SET @firstName = @el
				END
				ELSE
				BEGIN
					-- FIRST NAME FOUND THE REMAIN TEXT IS LAST NAME
					IF (@lastName IS NULL) SET @lastName = N''
					SET @lastName = LTRIM(RTRIM(@lastName + ' ' + @el))
				END
			END
			-- FETCH NEXT
			FETCH NEXT FROM SPLIT_STR_CURSOR INTO @el
		END

		CLOSE SPLIT_STR_CURSOR  
		DEALLOCATE SPLIT_STR_CURSOR 	

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
