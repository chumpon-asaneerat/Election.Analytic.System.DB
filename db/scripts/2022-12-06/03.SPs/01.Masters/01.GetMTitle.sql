/****** Object:  UserDefinedFunction [dbo].[GetGenderFromTitle]    Script Date: 11/26/2022 2:02:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetGenderFromTitle.
-- Description:	Find Gender Id from Title Description
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[GetGenderFromTitle](@Prefix nvarchar(MAX))
RETURNS int
AS
BEGIN
DECLARE @result int;
    IF (@Prefix IS NULL)
    BEGIN
        SET @result = NULL
    END
    ELSE
    BEGIN
        SELECT @result = GenderId 
          FROM MTitle
         WHERE UPPER(LTRIM(RTRIM([Description]))) = UPPER(LTRIM(RTRIM(@Prefix)))
    END

    RETURN @result;
END

GO
