/****** Object:  StoredProcedure [dbo].[GetMPD2562x350UnitSummary]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562x350UnitSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562x350UnitSummary]
(
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
)
AS
BEGIN
    SELECT A.ProvinceName
         , A.PollingUnitNo 
         , A.RightCount
         , A.ExerciseCount
         , A.InvalidCount 
         , A.NoVoteCount 
         , B.PollingUnitCount
      FROM MPD2562x350UnitSummary A, MPD2562PollingUnitSummary B
     WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(B.ProvinceName)))
       AND B.PollingUnitNo = A.PollingUnitNo
       AND UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(@ProvinceName)))
       AND A.PollingUnitNo = @PollingUnitNo
END

GO
