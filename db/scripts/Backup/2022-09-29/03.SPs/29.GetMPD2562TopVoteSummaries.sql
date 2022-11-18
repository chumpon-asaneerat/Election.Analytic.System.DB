/****** Object:  StoredProcedure [dbo].[GetMPD2562TopVoteSummaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562TopVoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562TopVoteSummaries]
(
  @ProvinceId nvarchar(10)
, @PollingUnitNo int
, @Top int = 6
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    ;WITH PartyImg AS
    (
        SELECT P.PartyId
             , P.PartyName
             , C.Data AS LogoData
          FROM MParty P
             , MContent C
         WHERE P.ContentId = C.ContentId
    )
    , PersonImg AS
    (
        SELECT P.FullName
             , P.Data AS PersonImageData
          FROM PersonImage P
    )
    , ProvinceA AS
    (
        SELECT ProvinceId
             , ProvinceNameTH
          FROM MProvince
    )
    , Top6VoteSum62 AS
    (
        SELECT D.ProvinceId
             , D.ProvinceNameTH
             , A.PollingUnitNo
             , A.FullName
             , A.PartyName
             , B.PartyId
             , B.LogoData
             , C.PersonImageData
             , A.VoteNo
             , A.VoteCount
          FROM MPD2562VoteSummary A
             , PartyImg B
             , PersonImg C
             , ProvinceA D
         WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(D.ProvinceNameTH)))
           AND UPPER(LTRIM(RTRIM(B.PartyName))) = UPPER(LTRIM(RTRIM(A.PartyName)))
           AND (
                    C.FullName = A.FullName
                 OR UPPER(LTRIM(RTRIM(C.FullName))) LIKE ''%'' + UPPER(LTRIM(RTRIM(A.FullName)))
                 OR UPPER(LTRIM(RTRIM(A.FullName))) LIKE ''%'' + UPPER(LTRIM(RTRIM(C.FullName)))
               )
    )
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' *
            FROM Top6VoteSum62
            WHERE ProvinceId = N''' + @ProvinceId + '''
            AND PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
            ORDER BY VoteCount DESC
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO
