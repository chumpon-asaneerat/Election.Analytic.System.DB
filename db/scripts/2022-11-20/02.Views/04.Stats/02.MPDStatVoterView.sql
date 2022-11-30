/****** Object:  View [dbo].[MPDStatVoterView]    Script Date: 11/26/2022 1:56:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDStatVoterView]
AS
	SELECT A.ThaiYear
         , A.ADM1Code
	     , A.PollingUnitNo
	  FROM MPDStatVoter A
        LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code

GO
