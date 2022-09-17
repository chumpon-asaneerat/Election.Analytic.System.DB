SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDPollingUnitSummary]
AS
	SELECT ThaiYear = 2562, A.* 
	  FROM MPD2562PollingUnitSummary A
	UNION
	SELECT ThaiYear = 2566, B.* 
	  FROM MPD2566PollingUnitSummary B
	 WHERE NOT EXISTS (
					  SELECT C.* 
						FROM MPD2562PollingUnitSummary C 
					   WHERE C.ProvinceName = B.ProvinceName
						 AND C.PollingUnitNo = B.PollingUnitNo
					 )

GO
