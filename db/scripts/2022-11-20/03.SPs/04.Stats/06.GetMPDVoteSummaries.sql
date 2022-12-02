/****** Object:  StoredProcedure [dbo].[GetMPDVoteSummaries]    Script Date: 12/2/2022 5:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDVoteSummaries
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
CREATE PROCEDURE [dbo].[GetMPDVoteSummaries]
(
  @ThaiYear int
, @RegionId nvarchar(20) = NULL
, @RegionName nvarchar(200) = NULL
, @ProvinceNameTH nvarchar(20) = NULL
, @PartyName nvarchar(200) = NULL
, @FullName nvarchar(MAX) = NULL
)
AS
BEGIN
    ;WITH MPDVoteSum
    AS
    -- Define the Vote Summary by Province and PollingUnit query.
    (
        SELECT * 
          FROM MPDVoteSummaryView
         WHERE ThaiYear = @ThaiYear
		   AND UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
		   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
		   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
		   AND UPPER(LTRIM(RTRIM(PartyName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@PartyName, PartyName)))) + '%'
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
    )
    SELECT * 
      FROM MPDVoteSum 
     ORDER BY ProvinceNameTH, PollingUnitNo, VoteCount DESC

END

GO
