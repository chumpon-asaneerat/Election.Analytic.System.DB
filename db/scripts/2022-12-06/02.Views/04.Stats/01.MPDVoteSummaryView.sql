/****** Object:  View [dbo].[MPDVoteSummaryView]    Script Date: 11/26/2022 1:56:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[MPD2562VoteSummaryView]    Script Date: 12/2/2022 6:00:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********** Script Update Date: 2022-10-09  ***********/
ALTER VIEW [dbo].[MPDVoteSummaryView]
AS
    SELECT ROW_NUMBER() OVER
		   (
			   ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo, VoteCount DESC
		   ) AS RowNo
		 , ROW_NUMBER() OVER
		   (
		       PARTITION BY ThaiYear, ProvinceNameTH, PollingUnitNo
			   ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo, VoteCount DESC
		   ) AS RankNo
         , A.ThaiYear
         , A.ADM1Code
         , B.ProvinceId
         , B.ProvinceNameTH
         , B.ProvinceNameEN
         , B.RegionId
         , B.RegionName
         , B.GeoGroup
         , B.GeoSubgroup
	     , A.PollingUnitNo
	     , A.CandidateNo
	     , A.RevoteNo
	     , A.PartyId
         , C.PartyName
         , C.[Data] AS PartyImageData
	     , A.PersonId
         , D.Prefix
         , D.FirstName
         , D.LastName
         , LTRIM(RTRIM(
            LTRIM(RTRIM(D.Prefix)) + ' ' + 
            LTRIM(RTRIM(D.FirstName))+ ' ' + 
            LTRIM(RTRIM(D.LastName))
           )) AS FullName
         , D.DOB
         , D.GenderId
         , E.[Description] AS GenderName
         , D.EducationId
         , F.[Description] AS EducationName
         , D.OccupationId
         , G.[Description] AS OccupationName
         , D.[Remark] AS PersonRemark
         , D.[Data] AS PersonImageData
	     , A.VoteCount
	  FROM MPDVoteSummary A 
        LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code
        LEFT OUTER JOIN MParty C ON C.PartyId = A.PartyId
        LEFT OUTER JOIN MPerson D ON D.PersonId = A.PersonId
        LEFT OUTER JOIN MGender E ON E.GenderId = D.GenderId
        LEFT OUTER JOIN MEducation F ON F.EducationId = D.EducationId
        LEFT OUTER JOIN MOccupation G ON G.OccupationId = D.OccupationId

GO
