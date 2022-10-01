/****** Object:  StoredProcedure [dbo].[GetMPD2562TotalVotes]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562TotalVotes
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562TotalVotes]
(
  @ProvinceId nvarchar(10)
, @PollingUnitNo int
, @Top int = 6
)
AS
BEGIN
    SELECT SUM(A.VoteCount) AS TotalVotes
      FROM MPD2562VoteSummary A
         , MProvince B 
     WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(B.ProvinceNameTH)))
       AND B.ProvinceId = @ProvinceId
       AND A.PollingUnitNo = @PollingUnitNo
END

GO
