/****** Object:  StoredProcedure [dbo].[GetMPDC2566PullingUnitsPaging]    Script Date: 10/29/2022 11:24:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566PullingUnitsPaging
-- [== History ==]
-- <2022-10-20> :
--	- Stored Procedure created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDC2566PullingUnitsPaging]
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
	BEGIN TRY
		-- calculate total polling units and max pages
		IF (@ProvinceName IS NULL AND @FullName IS NULL)
		BEGIN 
		    -- ALL MODE
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
				SELECT DISTINCT ProvinceName
					 , PollingUnitNo 
				  FROM MPDPollingUnitSummary A
				 WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, A.ProvinceName))))
			), SQLPaging AS
			(
				SELECT TOP(@pollingUnitPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY A.ProvinceName, A.PollingUnitNo) AS RowNo
					 , A.ProvinceName
					 , A.PollingUnitNo
				  FROM PollUnits A 
			)
			-- SELECT OUTPUT QUERY
			SELECT M.ProvinceName
				 , M.PollingUnitNo
				 , COUNT(A.CandidateNo) AS TotalCandidates
				 , @FullName AS FullNameFilter
			  FROM SQLPaging M WITH (NOLOCK)
				   LEFT OUTER JOIN MPDC2566 A ON 
				   (
						 A.ProvinceName = M.ProvinceName
					 AND A.PollingUnitNo = M.PollingUnitNo
				   )
			 WHERE RowNo > ((@pageNum - 1) * @pollingUnitPerPage)
			 GROUP BY M.ProvinceName, M.PollingUnitNo
		END
		ELSE
		BEGIN
		    -- FILTER MODE
			IF (@FullName IS NULL)
			BEGIN
				SELECT @iTotalUnits = COUNT(*) 
				  FROM MPDC2566 A
				 WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, A.ProvinceName))))

				SELECT @maxPage = 
					   CASE WHEN (@iTotalUnits % @pollingUnitPerPage > 0) THEN 
							(@iTotalUnits / @pollingUnitPerPage) + 1
					   ELSE 
							(@iTotalUnits / @pollingUnitPerPage)
				END;

				;WITH PollUnits AS
				(
					SELECT DISTINCT ProvinceName
						 , PollingUnitNo 
					  FROM MPDC2566 A
				     WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, A.ProvinceName))))
				), SQLPaging AS
				(
					SELECT TOP(@pollingUnitPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY A.ProvinceName, A.PollingUnitNo) AS RowNo
						 , A.ProvinceName
						 , A.PollingUnitNo
					  FROM PollUnits A 
				)
				-- SELECT OUTPUT QUERY
				SELECT M.ProvinceName
					 , M.PollingUnitNo
					 , COUNT(A.CandidateNo) AS TotalCandidates
					 , @FullName AS FullNameFilter
				  FROM SQLPaging M WITH (NOLOCK)
					   LEFT OUTER JOIN MPDC2566 A ON 
					   (
							 A.ProvinceName = M.ProvinceName
						 AND A.PollingUnitNo = M.PollingUnitNo
					   )
				 WHERE RowNo > ((@pageNum - 1) * @pollingUnitPerPage)
				 GROUP BY M.ProvinceName, M.PollingUnitNo
			END
			ELSE
			BEGIN
				SELECT @iTotalUnits = COUNT(*) 
				  FROM MPDC2566 A
				 WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, A.ProvinceName))))
				   AND A.FullName LIKE '%' + @FullName + '%'

				SELECT @maxPage = 
					   CASE WHEN (@iTotalUnits % @pollingUnitPerPage > 0) THEN 
							(@iTotalUnits / @pollingUnitPerPage) + 1
					   ELSE 
							(@iTotalUnits / @pollingUnitPerPage)
				END;

				;WITH PollUnits AS
				(
					SELECT DISTINCT ProvinceName
						 , PollingUnitNo 
					  FROM MPDC2566 A
					 WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, A.ProvinceName))))
					   AND A.FullName LIKE '%' + @FullName + '%'
				), SQLPaging AS
				(
					SELECT TOP(@pollingUnitPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY A.ProvinceName, A.PollingUnitNo) AS RowNo
						 , A.ProvinceName
						 , A.PollingUnitNo
					  FROM PollUnits A 
				)
				-- SELECT OUTPUT QUERY
				SELECT M.ProvinceName
					 , M.PollingUnitNo
					 , COUNT(A.CandidateNo) AS TotalCandidates
					 , @FullName AS FullNameFilter
				  FROM SQLPaging M WITH (NOLOCK)
					   LEFT OUTER JOIN MPDC2566 A ON 
					   (
							 A.ProvinceName = M.ProvinceName
						 AND A.PollingUnitNo = M.PollingUnitNo
					   )
				 WHERE RowNo > ((@pageNum - 1) * @pollingUnitPerPage)
				 GROUP BY M.ProvinceName, M.PollingUnitNo
			END
		END

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
