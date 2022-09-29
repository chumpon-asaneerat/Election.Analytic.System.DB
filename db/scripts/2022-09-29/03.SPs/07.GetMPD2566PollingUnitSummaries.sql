/****** Object:  StoredProcedure [dbo].[GetMPD2566PollingUnitSummaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2566PollingUnitSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2566PollingUnitSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
	  FROM MPD2566PollingUnitSummary
	 WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
	 ORDER BY ProvinceName, PollingUnitNo
END

GO
