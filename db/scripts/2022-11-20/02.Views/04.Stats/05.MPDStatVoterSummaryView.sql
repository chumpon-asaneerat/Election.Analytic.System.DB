/****** Object:  View [dbo].[MPDStatVoterSummaryView]    Script Date: 12/4/2022 9:22:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDStatVoterSummaryView]
AS
	SELECT A.ThaiYear
		 , A.ADM1Code
		 , B.ProvinceId
		 , B.ProvinceNameTH
		 , B.ProvinceNameEN
		 , A.PollingUnitNo
		 , D.PollingUnitCount
		 , A.RightCount
		 , A.ExerciseCount
		 , A.InvalidCount
		 , A.NoVoteCount
		 , A.PartyId
		 , A.PartyName
		 , A.PersonId
		 , C.Prefix
		 , C.FirstName
		 , C.LastName
		 , A.FullName
		 , A.VoteCount
      FROM __MPDStatVoterSummaryView A
	  LEFT OUTER JOIN MProvince B ON (A.ADM1Code = B.ADM1Code)
	  LEFT OUTER JOIN MPerson C ON (A.PersonId = C.PersonId)
	  LEFT OUTER JOIN PollingUnit D ON (A.ThaiYear = D.ThaiYear and A.ADM1Code = D.ADM1Code AND A.PollingUnitNo = D.PollingUnitNo)

GO
