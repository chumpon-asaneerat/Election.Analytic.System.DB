/****** Object:  StoredProcedure [dbo].[GetMPD2566PollingUnitSummary]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2566PollingUnitSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2566PollingUnitSummary]
(
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
)
AS
BEGIN
    SELECT * 
	  FROM MPD2566PollingUnitSummary
	 WHERE ProvinceName = @ProvinceName
	   AND PollingUnitNo = @PollingUnitNo
END

GO
