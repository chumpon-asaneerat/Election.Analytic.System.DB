/****** Object:  StoredProcedure [dbo].[GetMPDC2566FullSummaries]    Script Date: 10/26/2022 1:48:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566FullSummaries
-- [== History ==]
-- <2022-10-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[GetMPDC2566FullSummaries]
(
  @ProvinceName nvarchar(100) = NULL
, @FullName nvarchar(200) = NULL
)
AS
BEGIN
    SELECT * 
      FROM MPDC2566
     WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
       AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
     ORDER BY ProvinceName, PollingUnitNo, CandidateNo
END

GO
