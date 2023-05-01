/****** Object:  StoredProcedure [dbo].[GetMPDCOfficialTopVoteSummaries]    Script Date: 12/13/2022 1:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCOfficialTopVoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCOfficialTopVoteSummaries]
(
  @ThaiYear int
, @PrevThaiYear int
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @Top int = 6
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    ;WITH Top6VoteSum66 AS
    (
        SELECT A.ThaiYear
		     , A.ProvinceId
             , A.ADM1Code
             , A.ProvinceNameTH
             , A.PollingUnitNo
             , A.FullName
             , A.PartyName
             , A.PartyId
             , A.PartyImageData
             , A.PersonId
             , A.PersonImageData
             , A.RankNo
             , A.VoteCount
             , A.SortOrder
			 , B.ADM1Code AS PrevADM1Code
			 , B.PartyId AS PrevPartyId
			 , B.PartyName AS PrevPartyName
			 , B.ProvinceNameTH AS PrevProvinceNameTH
			 , B.PollingUnitNo AS PrevPollingUnitNo
			 , B.VoteCount AS PrevVoteCount
          FROM MPDCOfficialView A LEFT OUTER JOIN MPDVoteSummaryView B 
		    ON B.PersonId = A.PersonId AND B.ThaiYear = ' + CONVERT(nvarchar, @PrevThaiYear) + '
		 WHERE A.ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + '
    )
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' *
      FROM Top6VoteSum66
     WHERE ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + '
       AND ADM1Code = N''' + @ADM1Code + '''
       AND PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
     ORDER BY VoteCount DESC, SortOrder ASC
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO
