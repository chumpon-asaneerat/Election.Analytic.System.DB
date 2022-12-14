/****** Object:  StoredProcedure [dbo].[GetMPDStatVoters]    Script Date: 12/4/2022 7:46:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDStatVoters
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDStatVoters]
(
  @ThaiYear int
, @ProvinceNameTH nvarchar(100) = NULL
)
AS
BEGIN
	SELECT ThaiYear
         , ADM1Code
         , ProvinceId
         , ProvinceNameTH
         , ProvinceNameEN
         , RegionId
         , RegionName
         , GeoGroup
         , GeoSubgroup
	     , PollingUnitNo
         , RightCount
         , ExerciseCount
         , InvalidCount
         , NoVoteCount
		 , FullName
		 , PartyName
		 , VoteCount
		 , PollingUnitCount
      FROM MPDStatVoterView
     WHERE @ThaiYear = COALESCE(@ThaiYear, ThaiYear)
       AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
     ORDER BY ProvinceNameTH, PollingUnitNo
END

GO
