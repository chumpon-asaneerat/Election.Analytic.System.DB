/****** Object:  View [dbo].[MPDStatVoterView]    Script Date: 12/4/2022 9:16:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDStatVoterView]
AS
	SELECT A.ThaiYear
         , A.ADM1Code
         , B.ProvinceId
         , B.ProvinceNameTH
         , B.ProvinceNameEN
         , B.RegionId
         , B.RegionName
         , B.GeoGroup
         , B.GeoSubgroup
	     , A.PollingUnitNo
         , A.RightCount
         , A.ExerciseCount
         , A.InvalidCount
         , A.NoVoteCount
		 , B.FullName
		 , B.PartyName
		 , B.VoteCount
		 , C.PollingUnitCount
	  FROM MPDStatVoter A
	  INNER JOIN PollingUnit C
		ON (   
		        C.ThaiYear = A.ThaiYear
			AND C.ADM1Code = A.ADM1Code
			AND C.PollingUnitNo = A.PollingUnitNo
		   )
	  INNER JOIN MPDVoteSummaryView B
		ON (
		        B.ThaiYear = A.ThaiYear
			AND	B.ADM1Code = A.ADM1Code
			AND B.PollingUnitNo = A.PollingUnitNo
		   )

GO
