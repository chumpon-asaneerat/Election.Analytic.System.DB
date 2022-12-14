/****** Object:  StoredProcedure [dbo].[GetMPDVoteSummaryByFullName]    Script Date: 12/14/2022 11:54:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDVoteSummaryByFullName
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDVoteSummaryByFullName]
(
  @ThaiYear int
, @FullName nvarchar(200) = NULL
)
AS
BEGIN
    ;WITH MPDVoteSum_A
    AS
    (
        SELECT ThaiYear, ProvinceNameTH, PollingUnitNo 
          FROM MPDVoteSummaryView 
         WHERE ThaiYear = @ThaiYear
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ),
    MPDVoteSum_B
    AS
    -- Find the Vote Summary by Province and PollingUnit query.
    (
        SELECT ROW_NUMBER() OVER(ORDER BY A.VoteCount DESC) AS RowNo
				, A.ThaiYear
				, A.RegionId
				, A.RegionName
				, A.GeoGroup
				, A.GeoSubGroup
                , A.ADM1Code
                , A.ProvinceNameTH
                , A.ProvinceNameEN
                , A.ProvinceId
				, A.PollingUnitNo
				, A.CandidateNo
				, A.RevoteNo
				, A.RankNo 
				, A.VoteCount
				, A.PartyId
				, A.PartyName
				, A.PartyImageData
				, A.PersonId
				, A.Prefix
				, A.FirstName
				, A.LastName
				, A.FullName
				, A.PersonImageData
				, A.PersonRemark
				, A.DOB
				, A.GenderId
				, A.GenderName
				, A.EducationId
				, A.EducationName
				, A.OccupationId
				, A.OccupationName
            FROM MPDVoteSummaryView A JOIN MPDVoteSum_A B
            ON (
                    A.ThaiYear = B.ThaiYear
		        AND UPPER(LTRIM(RTRIM(A.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(B.ProvinceNameTH)))
                AND A.PollingUnitNo = B.PollingUnitNo
                )
    )
    SELECT * FROM MPDVoteSum_B
        WHERE ThaiYear = @ThaiYear
		  AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ORDER BY ProvinceNameTH, PollingUnitNo, VoteCount DESC

END

GO
