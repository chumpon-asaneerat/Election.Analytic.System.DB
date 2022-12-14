SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[_MPD2562x350UnitSummaryView]
AS
	SELECT A.ProvinceName
		 , A.PollingUnitNo
		 , A.RightCount
		 , A.ExerciseCount
		 , A.InvalidCount
		 , A.NoVoteCount
		 , B.FullName
		 , B.PartyName
		 , B.VoteCount
		 , C.PollingUnitCount
	  FROM MPD2562x350UnitSummary A 
	  JOIN MPD2562VoteSummary B
		ON (
				B.ProvinceName = A.ProvinceName
			AND B.PollingUnitNo = A.PollingUnitNo
		   )
	  JOIN MPD2562PollingUnitSummary C
		ON (
				C.ProvinceName = A.ProvinceName
			AND C.PollingUnitNo = A.PollingUnitNo
		   )

GO
