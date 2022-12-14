/****** Object:  StoredProcedure [dbo].[GetMPD2562VoteSummaries]    Script Date: 10/26/2022 12:33:22 PM ******/
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
-- <2022-10-09> :
--	- Add PartyNamne parameter.
--	- Add FullNamne parameter.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[GetMPD2562VoteSummaries]
(
  @ProvinceName nvarchar(100) = NULL
, @PartyName nvarchar(100) = NULL
, @FullName nvarchar(200) = NULL
)
AS
BEGIN
    ;WITH MPD2562VoteSum62
    AS
    -- Define the Vote Summary by Province and PollingUnit query.
    (
        SELECT * 
          FROM MPD2562VoteSummaryView
         WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
		   AND UPPER(LTRIM(RTRIM(PartyName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@PartyName, PartyName)))) + '%'
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
    )
    SELECT * 
      FROM MPD2562VoteSum62 
     ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC

END

GO
