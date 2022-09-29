/****** Object:  StoredProcedure [dbo].[GetMPD2562PollingUnitSummaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562PollingUnitSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562PollingUnitSummary]
(
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
)
AS
BEGIN
    SELECT * 
	  FROM MPD2562PollingUnitSummary
	 WHERE ProvinceName = @ProvinceName
	   AND PollingUnitNo = @PollingUnitNo
END

GO
