CREATE VIEW MPD2562VoteSummaryView
AS
    SELECT ROW_NUMBER() OVER
		   (
			   ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC
		   ) AS RowNo
		 , ROW_NUMBER() OVER
		   (
		       PARTITION BY ProvinceName, PollingUnitNo
			   ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC
		   ) AS RankNo
         , * 
      FROM MPD2562VoteSummary

GO
