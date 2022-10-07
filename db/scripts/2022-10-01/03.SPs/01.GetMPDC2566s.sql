/****** Object:  StoredProcedure [dbo].[GetMPDC2566s]    Script Date: 10/7/2022 6:46:22 PM ******/
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
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[GetMPDC2566s]
(
  @ProvinceName nvarchar(100) = NULL
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
