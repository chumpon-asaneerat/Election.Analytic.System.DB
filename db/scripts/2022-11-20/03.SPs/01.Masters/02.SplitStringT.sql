/****** Object:  UserDefinedFunction [dbo].[SplitStringT]    Script Date: 11/26/2022 2:01:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SplitStringT.
-- Description:	Split String into substring (Remove empty elements).
-- [== History ==]
-- <2022-08-31> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.SplitStringT(N'Test  XXX  ', N' ')
--
-- =============================================
CREATE FUNCTION [dbo].[SplitStringT] 
( 
  @string nvarchar(MAX)
, @delim nvarchar(100)
)
RETURNS
@result TABLE 
( 
  [RowId] int  NOT NULL
, [Item] nvarchar(MAX) NOT NULL
, [Index] int NOT NULL 
, [Length] int  NOT NULL
)
AS
BEGIN
DECLARE   @str nvarchar(MAX)
		, @pos int 
		, @length int
		, @max int = LEN(@string)
		, @prv int = 1
		, @rowId int = 1

	SELECT @pos = CHARINDEX(@delim, @string)
	WHILE @pos > 0
	BEGIN
		SELECT @str = SUBSTRING(@string, @prv, @pos - @prv)
		SET @length = @pos - @prv;

		IF (LEN(LTRIM(RTRIM(@str))) > 0)
		BEGIN
			INSERT INTO @result SELECT @rowId
									 , LTRIM(RTRIM(@str))
									 , @prv
									 , @length
			SET @rowId = @rowId + 1 -- SET ROW ID AFTER INSERT
		END

		SELECT @prv = @pos + LEN(@delim)
		     , @pos = CHARINDEX(@delim, @string, @pos + 1)
	END

	SET @length = @max - @prv;
	SET @str = SUBSTRING(@string, @prv, @max)
	IF (LEN(LTRIM(RTRIM(@str))) > 0)
	BEGIN
		INSERT INTO @result SELECT @rowId
								 , LTRIM(RTRIM(@str))
								 , @prv
								 , @length
	END

	RETURN
END

GO
