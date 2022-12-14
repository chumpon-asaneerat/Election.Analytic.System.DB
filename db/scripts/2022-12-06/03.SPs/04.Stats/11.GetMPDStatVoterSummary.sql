/****** Object:  StoredProcedure [dbo].[GetMPDStatVoterSummary]    Script Date: 12/4/2022 7:46:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDStatVoterSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDStatVoterSummary]
(
  @ThaiYear int
, @ADM1Code nvarchar(20) = NULL
, @PollingUnitNo int = NULL
)
AS
BEGIN
	SELECT ThaiYear
         , ADM1Code
         , ProvinceId
         , ProvinceNameTH
         , ProvinceNameEN
         , RegionId
         , RegionName
         , GeoGroup
         , GeoSubgroup
	     , PollingUnitNo
         , RightCount
         , ExerciseCount
         , InvalidCount
         , NoVoteCount
		 , FullName
		 , PartyName
		 , VoteCount
		 , PollingUnitCount
      FROM MPDStatVoterSummaryView
     WHERE ThaiYear = COALESCE(@ThaiYear, ThaiYear)
       AND UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
       AND PollingUnitNo = COALESCE(@PollingUnitNo, PollingUnitNo)
     ORDER BY ProvinceNameTH, PollingUnitNo
END

GO
