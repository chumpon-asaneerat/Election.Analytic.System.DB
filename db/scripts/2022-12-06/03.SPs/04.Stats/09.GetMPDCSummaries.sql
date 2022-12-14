/****** Object:  StoredProcedure [dbo].[GetMPDCSummaries]    Script Date: 12/14/2022 8:08:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCSummaries]
(
  @ThaiYear int
, @ADM1Code nvarchar(20)
, @PollingUnitNo int
, @Top int = 4
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' 
           ThaiYear
         , ADM1Code
         , ProvinceNameTH AS ProvinceName
         , PollingUnitNo
         , FullName
         , PersonImageData AS PersonImageData
         , PrevPartyId AS PartyId
         , PartyName
         , PartyImageData
         , CandidateNo
         , DOB
         , EducationDescription AS EducationLevel
         , CandidateSubGroup AS SubGroup
         , CandidateRemark AS [Remark]
      FROM MPDCView
    WHERE ThaiYear = ' + CONVERT(nvarchar, @ThaiYear) + ' 
	  AND ADM1Code = N''' + @ADM1Code + '''
      AND PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
    ORDER BY CandidateNo
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO
