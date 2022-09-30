/****** Object:  StoredProcedure [dbo].[GetMPD2562VoteSummaries]    Script Date: 9/30/2022 6:59:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562VoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562VoteSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    ;WITH MPD2562VoteSum62
    AS
    -- Define the Vote Summary by Province and PollingUnit query.
    (
        SELECT ROW_NUMBER() OVER(ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC) AS RowNo
                , * 
          FROM MPD2562VoteSummary
         WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
    )
    SELECT * 
      FROM MPD2562VoteSum62 
     ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC

END

GO
