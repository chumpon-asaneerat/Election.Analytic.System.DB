/****** Object:  StoredProcedure [dbo].[GetMPDC2566FullSummaries]    Script Date: 10/26/2022 10:57:56 AM ******/
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
CREATE PROCEDURE [dbo].[GetMPDC2566FullSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
      FROM MPDC2566
     WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
     ORDER BY ProvinceName, PollingUnitNo, CandidateNo
END

GO
