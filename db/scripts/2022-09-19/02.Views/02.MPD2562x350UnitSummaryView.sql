SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPD2562x350UnitSummaryView]
AS
	SELECT A.ProvinceName
		 , A.PollingUnitNo
		 , A.RightCount
		 , A.ExerciseCount
		 , A.InvalidCount
		 , A.NoVoteCount
		 , A.FullName
		 , A.PartyName
		 , A.VoteCount
		 , A.PollingUnitCount
	  FROM _MPD2562x350UnitSummaryView A
	 WHERE VoteCount = (
						SELECT MAX(VoteCount) AS VoteCount 
						  FROM _MPD2562x350UnitSummaryView 
						 WHERE ProvinceName = A.ProvinceName
						   AND PollingUnitNo = A.PollingUnitNo 
					   )

GO
