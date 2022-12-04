/****** Object:  View [dbo].[MPDStatVoterSummaryView]    Script Date: 12/4/2022 9:22:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[__MPDStatVoterSummaryView]
AS
	SELECT POL.ThaiYear
		 , POL.ADM1Code
		 , POL.PollingUnitNo
		 , STA.RightCount
		 , STA.ExerciseCount
		 , STA.InvalidCount
		 , STA.NoVoteCount
		 , MVS.PartyId
		 , MVS.PartyName
		 , MVS.PersonId
		 , MVS.FullName
		 , MVS.VoteCount
	  FROM PollingUnit POL
	  JOIN 
		   MPDStatVoter STA ON (    STA.ThaiYear = POL.ThaiYear 
								AND STA.ADM1Code = POL.ADM1Code 
								AND STA.PollingUnitNo = POL.PollingUnitNo)
	  LEFT OUTER JOIN
		   (
			SELECT VSO.ThaiYear
				 , VSO.ADM1Code
				 , VSO.PollingUnitNo
				 , VSO.CandidateNo
				 , VSO.PartyId
				 , VSO.PartyName
				 , VSO.PersonId
				 , VSO.FullName
				 , VSO.VoteCount
			  FROM MPDVoteSummaryView VSO
			 WHERE VSO.VoteCount = 
				   (
					SELECT MAX(VS.VoteCount) AS VoteCount
					  FROM MPDVoteSummary VS
					 WHERE VS.ThaiYear = VSO.ThaiYear
					   AND VS.ADM1Code = VSO.ADM1Code
					   AND VS.PollingUnitNo = VSO.PollingUnitNo
					 GROUP BY VS.ThaiYear, VS.ADM1Code, VS.PollingUnitNo
				   )
		   ) MVS ON (    MVS.ThaiYear = POL.ThaiYear 
					 AND MVS.ADM1Code = POL.ADM1Code 
					 AND MVS.PollingUnitNo = POL.PollingUnitNo)

GO
