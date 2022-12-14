/****** Object:  StoredProcedure [dbo].[GetMPDCPullingUnitsPaging]    Script Date: 12/14/2022 10:19:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCPullingUnitsPaging
-- [== History ==]
-- <2022-10-20> :
--	- Stored Procedure created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCPullingUnitsPaging]
(
  @ThaiYear int
, @ProvinceName nvarchar(200) = NULL
, @FullName nvarchar(MAX) = NULL
, @pageNum as int = 1 out
, @rowsPerPage as int = 4 out
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
			  FROM PollingUnitView
			 WHERE ThaiYear = @ThaiYear
			   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))

			SELECT @maxPage = 
				   CASE WHEN (@iTotalUnits % @rowsPerPage > 0) THEN 
						(@iTotalUnits / @rowsPerPage) + 1
				   ELSE 
						(@iTotalUnits / @rowsPerPage)
			END;

			;WITH PollUnits AS
			(
				SELECT DISTINCT ThaiYear
				     , ProvinceNameTH
					 , PollingUnitNo 
				  FROM PollingUnitView
				 WHERE ThaiYear = @ThaiYear
				   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
			), SQLPaging AS
			(
				SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo) AS RowNo
					 , ThaiYear
					 , ProvinceNameTH
					 , PollingUnitNo
				  FROM PollUnits 
			)
			-- SELECT OUTPUT QUERY
			SELECT M.ThaiYear
			     , M.ProvinceNameTH
				 , M.PollingUnitNo
				 , COUNT(A.CandidateNo) AS TotalCandidates
				 , @FullName AS FullNameFilter
			  FROM SQLPaging M WITH (NOLOCK)
				   LEFT OUTER JOIN MPDCView A ON 
				   (
				         A.ThaiYear = @ThaiYear
				     AND A.ProvinceNameTH = M.ProvinceNameTH
					 AND A.PollingUnitNo = M.PollingUnitNo
				   )
			 WHERE RowNo > ((@pageNum - 1) * @rowsPerPage)
			 GROUP BY M.ThaiYear, M.ProvinceNameTH, M.PollingUnitNo
		END
		ELSE
		BEGIN
		    -- FILTER MODE
			IF (@FullName IS NULL)
			BEGIN
				-- NEED TO CHECK HAS CANDIDATE ON SPECIFICED PROVINCE
				;WITH MPDCUnits AS
				(
					SELECT ProvinceNameTH, PollingUnitNo, COUNT(PollingUnitNo) CandidateCount
					  FROM MPDCView
					 WHERE ThaiYear = @ThaiYear
					   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
					 GROUP BY ProvinceNameTH, PollingUnitNo
				)
				-- COUNT TOTAL POLLING UNITS
				SELECT @iTotalUnits = COUNT(*) 
				  FROM MPDCUnits

				SELECT @maxPage = 
					   CASE WHEN (@iTotalUnits % @rowsPerPage > 0) THEN 
							(@iTotalUnits / @rowsPerPage) + 1
					   ELSE 
							(@iTotalUnits / @rowsPerPage)
				END;

				;WITH PollUnits AS
				(
					SELECT DISTINCT ThaiYear
						 , ProvinceNameTH
						 , PollingUnitNo 
					  FROM MPDCView
				     WHERE ThaiYear = @ThaiYear
					   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
				), SQLPaging AS
				(
					SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo) AS RowNo
						 , ThaiYear
						 , ProvinceNameTH
						 , PollingUnitNo
					  FROM PollUnits
				)
				-- SELECT OUTPUT QUERY
				SELECT M.ThaiYear
					 , M.ProvinceNameTH
					 , M.PollingUnitNo
					 , COUNT(A.CandidateNo) AS TotalCandidates
					 , @FullName AS FullNameFilter
				  FROM SQLPaging M WITH (NOLOCK)
					   LEFT OUTER JOIN MPDCView A ON 
					   (
							 A.ThaiYear = @ThaiYear
				         AND A.ProvinceNameTH = M.ProvinceNameTH
						 AND A.PollingUnitNo = M.PollingUnitNo
					   )
				 WHERE RowNo > ((@pageNum - 1) * @rowsPerPage)
				 GROUP BY M.ThaiYear, M.ProvinceNameTH, M.PollingUnitNo
			END
			ELSE
			BEGIN
				SELECT @iTotalUnits = COUNT(*) 
				  FROM MPDCView
				 WHERE ThaiYear = @ThaiYear
				   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
				   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM((@FullName)))) + '%'

				SELECT @maxPage = 
					   CASE WHEN (@iTotalUnits % @rowsPerPage > 0) THEN 
							(@iTotalUnits / @rowsPerPage) + 1
					   ELSE 
							(@iTotalUnits / @rowsPerPage)
				END;

				;WITH PollUnits AS
				(
					SELECT DISTINCT ThaiYear
						 , ProvinceNameTH
						 , PollingUnitNo 
					  FROM MPDCView
				     WHERE ThaiYear = @ThaiYear
					   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))
					   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(@FullName))) + '%'
				), SQLPaging AS
				(
					SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY ThaiYear, ProvinceNameTH, PollingUnitNo) AS RowNo
						 , ThaiYear
						 , ProvinceNameTH
						 , PollingUnitNo
					  FROM PollUnits
				)
				-- SELECT OUTPUT QUERY
				SELECT M.ThaiYear
					 , M.ProvinceNameTH
					 , M.PollingUnitNo
					 , COUNT(A.CandidateNo) AS TotalCandidates
					 , @FullName AS FullNameFilter
				  FROM SQLPaging M WITH (NOLOCK)
					   LEFT OUTER JOIN MPDCView A ON 
					   (
							 A.ThaiYear = @ThaiYear
				         AND A.ProvinceNameTH = M.ProvinceNameTH
						 AND A.PollingUnitNo = M.PollingUnitNo
					   )
				 WHERE RowNo > ((@pageNum - 1) * @rowsPerPage)
				 GROUP BY M.ThaiYear, M.ProvinceNameTH, M.PollingUnitNo
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
