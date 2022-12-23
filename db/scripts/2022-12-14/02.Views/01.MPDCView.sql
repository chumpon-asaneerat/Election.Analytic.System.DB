/****** Object:  View [dbo].[MPDCView]    Script Date: 12/23/2022 10:07:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MPDCView]
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
         , A.CandidateNo
         , A.PersonId
         , D.Prefix
         , D.FirstName
         , D.LastName
         , LTRIM(RTRIM(
            CASE 
				WHEN (D.Prefix IS NULL) THEN ''
			    ELSE LTRIM(RTRIM(D.Prefix))
			END + ' ' + 
            LTRIM(RTRIM(D.FirstName))+ ' ' + 
            LTRIM(RTRIM(D.LastName))
           )) AS FullName
         , D.DOB
         , D.[Remark] AS PersonRemark
         , D.[Data] AS PersonImageData
         , A.PrevPartyId
         , C.PartyName
         , C.[Data] AS PartyImageData
         , D.GenderId
         , E.[Description] AS GenderName
         , D.EducationId
         , D.OccupationId
         , G.[Description] AS OccupationName
         , F.[Description] AS EducationDescription
         , A.[Remark] AS CandidateRemark
         , A.SubGroup As CandidateSubGroup
	  FROM MPDC A
        LEFT OUTER JOIN MProvinceView B ON B.ADM1Code = A.ADM1Code
        LEFT OUTER JOIN MParty C ON C.PartyId = A.PrevPartyId
        LEFT OUTER JOIN MPerson D ON D.PersonId = A.PersonId
        LEFT OUTER JOIN MGender E ON E.GenderId = D.GenderId
        LEFT OUTER JOIN MEducation F ON F.EducationId = D.EducationId
        LEFT OUTER JOIN MOccupation G ON G.OccupationId = D.OccupationId

GO
