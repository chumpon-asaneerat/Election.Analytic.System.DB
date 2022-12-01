/****** Object:  UserDefinedFunction [dbo].[CheckPartyIdReferences]    Script Date: 11/26/2022 2:02:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: CheckPartyIdReferences.
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.CheckPartyIdReferences(6) AS Count;
-- =============================================
CREATE FUNCTION [dbo].[CheckPartyIdReferences](@PartyId int)
RETURNS int
AS
BEGIN
DECLARE @result int;
DECLARE @cntMPD int
DECLARE @cntMPDC int
    SET @result = 0
    IF (@PartyId IS NOT NULL)
    BEGIN
            SELECT @cntMPD = COUNT(*) FROM MPDVoteSummary WHERE PartyId = @PartyId
            SELECT @cntMPDC = COUNT(*) FROM MPDC WHERE PrevPartyId = @PartyId

            SET @result = @cntMPD + @cntMPDC
    END

    RETURN @result;
END

GO
