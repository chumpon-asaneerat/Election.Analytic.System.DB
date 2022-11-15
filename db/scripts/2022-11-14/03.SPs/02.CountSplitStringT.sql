/****** Object:  UserDefinedFunction [dbo].[CountSplitStringT]    Script Date: 11/15/2022 1:01:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SplitStringT.
-- Description:	Count Split String into substring (Remove empty elements).
-- [== History ==]
-- <2022-11-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.CountSplitStringT(N'Test  XXX  ', N' ')
--
-- =============================================
CREATE FUNCTION [dbo].[CountSplitStringT] 
( 
  @string nvarchar(MAX)
, @delim nvarchar(100)
)
RETURNS int
AS
BEGIN
DECLARE @result int;
	SELECT @result = COUNT(*) FROM SplitStringT(@string, @delim)
	RETURN @result
END

GO

