/****** Object:  StoredProcedure [dbo].[GetMPD2562VoteSummaryByFullName]    Script Date: 9/30/2022 6:59:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562VoteSummaryByFullName
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562VoteSummaryByFullName]
(
  @FullName nvarchar(200) = NULL
)
AS
BEGIN
    ;WITH MPD2562VoteSum62_A
    AS
    (
        SELECT ProvinceName, PollingUnitNo 
          FROM MPD2562VoteSummary 
         WHERE UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ),
    MPD2562VoteSum62_B
    AS
    -- Find the Vote Summary by Province and PollingUnit query.
    (
        SELECT ROW_NUMBER() OVER(ORDER BY A.VoteCount DESC) AS RowNo
                , A.* 
            FROM MPD2562VoteSummary A JOIN MPD2562VoteSum62_A B
            ON (
                    UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(B.ProvinceName)))
                AND A.PollingUnitNo = B.PollingUnitNo
                )
    )
    SELECT * FROM MPD2562VoteSum62_B
        WHERE UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC

END

GO
