/****** Object:  StoredProcedure [dbo].[GetMPDTotalVotes]    Script Date: 12/13/2022 2:01:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDTotalVotes
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDTotalVotes]
(
  @ThaiYear int
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
)
AS
BEGIN
    SELECT SUM(VoteCount) AS TotalVotes
      FROM MPDVoteSummaryView
     WHERE ThaiYear = @ThaiYear
       AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(@ADM1Code)))
       AND PollingUnitNo = @PollingUnitNo
END

GO
