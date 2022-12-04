/****** Object:  View [dbo].[MPDStatVoterSummaryView]    Script Date: 12/4/2022 9:22:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDStatVoterSummaryView]
AS
	SELECT A.ThaiYear
         , A.ADM1Code
         , A.ProvinceId
         , A.ProvinceNameTH
         , A.ProvinceNameEN
         , A.RegionId
         , A.RegionName
         , A.GeoGroup
         , A.GeoSubgroup
	     , A.PollingUnitNo
         , A.RightCount
         , A.ExerciseCount
         , A.InvalidCount
         , A.NoVoteCount
		 , A.FullName
		 , A.PartyName
		 , A.VoteCount
		 , A.PollingUnitCount
	  FROM MPDStatVoterView A
		   LEFT OUTER JOIN
		   (
			 SELECT ThaiYear, ADM1Code, PollingUnitNo, MAX(VoteCount) AS VoteCount
			   FROM MPDVoteSummary
			  GROUP BY ThaiYear, ADM1Code, PollingUnitNo
		   ) B ON (
						B.ThaiYear = A.ThaiYear
					AND B.ADM1Code = A.ADM1Code
					AND B.PollingUnitNo = A.PollingUnitNo
				  )

GO
