/****** Object:  UserDefinedFunction [dbo].[IsNullOrEmpty]    Script Date: 11/26/2022 2:02:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsNullOrEmpty.
-- Description:	IsNullOrEmpty is function to check is string is in null or empty
--              returns 1 if string is null or empty string otherwise return 0.
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.IsNullOrEmpty(null) AS RET;     -- NULL Returns 1
--SELECT dbo.IsNullOrEmpty('') AS RET;       -- Empty Returns 1
--SELECT dbo.IsNullOrEmpty(' ') AS RET;      -- Whitespace Returns 1
--SELECT dbo.IsNullOrEmpty('Test') AS RET;   -- Has data Returns 0
-- =============================================
CREATE FUNCTION [dbo].[IsNullOrEmpty](@str nvarchar)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    IF @str IS NULL OR RTRIM(LTRIM(@str)) = N''
		SET @result = 1
	ELSE SET @result = 0

    RETURN @result;
END

GO
