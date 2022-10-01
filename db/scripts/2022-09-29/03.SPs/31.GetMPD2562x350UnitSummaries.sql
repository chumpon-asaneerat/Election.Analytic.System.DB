/****** Object:  StoredProcedure [dbo].[GetMPD2562x350UnitSummaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562x350UnitSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562x350UnitSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
      FROM MPD2562x350UnitSummary
     WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
     ORDER BY ProvinceName, PollingUnitNo
END

GO
