/****** Object:  StoredProcedure [dbo].[Parse_FullName_Lv2]    Script Date: 11/14/2022 9:02:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Parse FullName level 2
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[Parse_FullName_Lv2] (
  @fullName nvarchar(MAX)
, @el1 nvarchar(MAX)
, @el2 nvarchar(MAX)
, @prefix nvarchar(MAX) = NULL out
, @firstName nvarchar(MAX) = NULL out
, @lastName nvarchar(MAX) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		-- EXTRACT Prefix/FirstName from element
		EXEC Parse_FullName_Lv1 @fullName, @el1
							  , @prefix out, @firstName out, @lastName out
							  , @errNum out, @errMsg out
		
		IF (@errNum <> 0) RETURN; -- EXECUTE ERROR

		-- in this case we not need to consider prefix 
		-- because the el2 must be only first or last name
		IF (@firstName IS NULL)
		BEGIN
			-- Not found first name in previous level so need to check next element (el2)
			IF (@el2 IS NOT NULL)
			BEGIN
				SET @firstName = @el2
			END
		END
		ELSE
		BEGIN
			-- Found first name in previous level so next element (el2) must be Last Name
			IF (@el2 IS NOT NULL)
			BEGIN
				SET @lastName = @el2
			END
		END

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
