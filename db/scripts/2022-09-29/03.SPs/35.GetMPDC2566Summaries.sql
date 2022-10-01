/****** Object:  StoredProcedure [dbo].[GetMPDC2566Summaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566Summaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDC2566Summaries]
(
  @ProvinceId nvarchar(10)
, @PollingUnitNo int
, @Top int = 4
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' 
           B.ProvinceId
         , B.ProvinceNameTH AS ProvinceName
         , A.PollingUnitNo
         , A.FullName
         , IMG.Data AS PersonImageData
         , C.PartyId
         , A.PrevPartyName
         , C.Data AS LogoData
         , A.CandidateNo
         , A.EducationLevel
         , A.SubGroup
         , A.Remark
      FROM MPDC2566 A
           LEFT OUTER JOIN (SELECT P.PartyId
                                  , P.PartyName  
                                  , CT.Data
                              FROM MParty P LEFT OUTER JOIN MContent CT 
                                ON P.ContentId = CT.ContentId) C 
                        ON 
                        (
                            UPPER(LTRIM(RTRIM(A.PrevPartyName))) = UPPER(LTRIM(RTRIM(C.PartyName)))
                        )
            LEFT OUTER JOIN PersonImage IMG 
                        ON 
                        (   
                               (IMG.FullName = A.FullName)
                            OR (IMG.FullName LIKE ''%'' + A.FullName + ''%'')
                            OR (A.FullName LIKE ''%'' + IMG.FullName + ''%'')
                        )
          , MProvince B 
    WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(B.ProvinceNameTH)))
      AND B.ProvinceId = N''' + @ProvinceId + '''
      AND A.PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
    ORDER BY A.CandidateNo
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO
