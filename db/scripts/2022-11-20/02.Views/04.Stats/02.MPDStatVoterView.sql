/****** Object:  View [dbo].[MPDStatVoterView]    Script Date: 11/26/2022 1:56:52 PM ******/
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
	  FROM MPDStatVoter A
        LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code

GO
