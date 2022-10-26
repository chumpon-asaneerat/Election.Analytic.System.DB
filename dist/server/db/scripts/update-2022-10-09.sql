/*********** Script Update Date: 2022-10-09  ***********/
CREATE VIEW MPD2562VoteSummaryView
AS
    SELECT ROW_NUMBER() OVER
		   (
			   ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC
		   ) AS RowNo
		 , ROW_NUMBER() OVER
		   (
		       PARTITION BY ProvinceName, PollingUnitNo
			   ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC
		   ) AS RankNo
         , * 
      FROM MPD2562VoteSummary

GO


/*********** Script Update Date: 2022-10-09  ***********/
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


/*********** Script Update Date: 2022-10-09  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SearchPersonImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[SearchPersonImage]
(
  @FullName nvarchar(200)
)
AS
BEGIN
	SELECT *
	  FROM PersonImage
	 WHERE FullName = @FullName
	    OR UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(@FullName)))
		OR UPPER(LTRIM(RTRIM(@FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(FullName)))

END

GO


/*********** Script Update Date: 2022-10-09  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562VoteSummaries]    Script Date: 10/26/2022 12:33:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562VoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
-- <2022-10-09> :
--	- Add PartyNamne parameter.
--	- Add FullNamne parameter.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[GetMPD2562VoteSummaries]
(
  @ProvinceName nvarchar(100) = NULL
, @PartyName nvarchar(100) = NULL
, @FullName nvarchar(200) = NULL
)
AS
BEGIN
    ;WITH MPD2562VoteSum62
    AS
    -- Define the Vote Summary by Province and PollingUnit query.
    (
        SELECT * 
          FROM MPD2562VoteSummaryView
         WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
		   AND UPPER(LTRIM(RTRIM(PartyName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@PartyName, PartyName)))) + '%'
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
    )
    SELECT * 
      FROM MPD2562VoteSum62 
     ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC

END

GO


/*********** Script Update Date: 2022-10-09  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDC2566s]    Script Date: 10/26/2022 1:44:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566s
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
-- <2022-10-07> :
--	- Supports Paging.
-- <2022-10-09> :
--	- Add FullNamne parameter.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[GetMPDC2566s]
(
  @ProvinceName nvarchar(100) = NULL
, @FullName nvarchar(200) = NULL
, @pageNum as int = 1 out
, @pollingUnitPerPage as int = 4 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iTotalUnits int;
DECLARE @sFullName nvarchar(200)
	BEGIN TRY
		-- calculate total polling units and max pages
		SELECT @iTotalUnits = COUNT(*) 
		  FROM MPDPollingUnitSummary
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))

		SELECT @maxPage = 
			CASE WHEN (@iTotalUnits % @pollingUnitPerPage > 0) THEN 
				(@iTotalUnits / @pollingUnitPerPage) + 1
			ELSE 
				(@iTotalUnits / @pollingUnitPerPage)
			END;

		;WITH PollUnits AS
		(
			SELECT DISTINCT 
			       ProvinceName
			     , PollingUnitNo 
			  FROM MPDC2566
		), SQLPaging AS
		(
			SELECT TOP(@pollingUnitPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY A.ProvinceName, A.PollingUnitNo) AS RowNo
			     , A.ProvinceName
				 , A.PollingUnitNo
			  FROM PollUnits A 
			 WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, A.ProvinceName))))
		)

		SELECT A.ProvinceName
			 , A.PollingUnitNo
			 , A.CandidateNo
			 , A.FullName
			 , A.PrevPartyName
			 , A.EducationLevel
			 , A.Remark
			 , A.SubGroup
			 , IMG.FullName AS ImageFullName
			 , IMG.Data
             , A.ProvinceName AS ProvinceNameOri
             , A.PollingUnitNo AS PollingUnitNoOri
             , A.CandidateNo AS CandidateNoOri
             , A.FullName AS FullNameOri
		  FROM SQLPaging M WITH (NOLOCK)
		     , MPDC2566 A 
			   LEFT OUTER JOIN PersonImage IMG
               ON 
               (   
                   (IMG.FullName = A.FullName)
                OR (IMG.FullName LIKE '%' + A.FullName + '%')
                OR (A.FullName LIKE '%' + IMG.FullName + '%')
               )
		 WHERE RowNo > ((@pageNum - 1) * @pollingUnitPerPage)
		   AND A.ProvinceName = M.ProvinceName
		   AND A.PollingUnitNo = M.PollingUnitNo

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-10-09  ***********/
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

