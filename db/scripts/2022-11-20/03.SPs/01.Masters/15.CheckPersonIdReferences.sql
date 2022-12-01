/****** Object:  UserDefinedFunction [dbo].[CheckPersonIdReferences]    Script Date: 11/26/2022 2:02:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: CheckPersonIdReferences.
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.CheckPersonIdReferences(6) AS Count;
-- =============================================
CREATE FUNCTION [dbo].[CheckPersonIdReferences](@PersonId int)
RETURNS int
AS
BEGIN
DECLARE @result int;
DECLARE @cntMPD int
DECLARE @cntMPDC int
    SET @result = 0
    IF (@PersonId IS NOT NULL)
    BEGIN
            SELECT @cntMPD = COUNT(*) FROM MPDVoteSummary WHERE PersonId = @PersonId
            SELECT @cntMPDC = COUNT(*) FROM MPDC WHERE PersonId = @PersonId

            SET @result = @cntMPD + @cntMPDC
    END

    RETURN @result;
END

GO
