/****** Object:  StoredProcedure [dbo].[GetMPDTopVoteSummaries]    Script Date: 12/13/2022 1:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDTopVoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDTopVoteSummaries]
(
  @ThaiYear int
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @Top int = 6
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    ;WITH Top6VoteSum62 AS
    (
        SELECT ThaiYear
		     , ProvinceId
             , ADM1Code
             , ProvinceNameTH
             , PollingUnitNo
             , FullName
             , PartyName
             , PartyId
             , PartyImageData
             , PersonImageData
             , RankNo
             , VoteCount
          FROM MPDVoteSummaryView
		 WHERE ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + '
    )
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' *
      FROM Top6VoteSum62
     WHERE ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + '
       AND ADM1Code = N''' + @ADM1Code + '''
       AND PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
     ORDER BY VoteCount DESC
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO
