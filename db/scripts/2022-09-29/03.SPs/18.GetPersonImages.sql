/****** Object:  StoredProcedure [dbo].[GetPersonImages]    Script Date: 9/30/2022 7:43:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPersonImages
-- [== History ==]
-- <2022-09-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--DECLARE @pageNum as int = 1
--DECLARE @rowsPerPage as int = 10
--DECLARE @totalRecords as int = 0
--DECLARE @maxPage as int = 0
--
--EXEC GetPersonImages 'กร', @pageNum out, @rowsPerPage out, @totalRecords out, @maxPage out
--SELECT @totalRecords AS TotalPage, @maxPage AS MaxPage
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonImages]
(
  @FullName nvarchar(200) = null
, @pageNum as int = 1 out
, @rowsPerPage as int = 10 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @sFullName nvarchar(200)
	BEGIN TRY
		IF (@FullName IS NULL)
		BEGIN
			SET @sFullName = N''
		END
		ELSE
		BEGIN
			SET @sFullName = UPPER(RTRIM(LTRIM(@FullName)))
		END

		-- calculate total record and maxpages
		SELECT @totalRecords = COUNT(*) 
		  FROM PersonImage
		 WHERE UPPER(RTRIM(LTRIM(FullName))) LIKE '%' + @sFullName + '%'

		SELECT @maxPage = 
			CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
				(@totalRecords / @rowsPerPage) + 1
			ELSE 
				(@totalRecords / @rowsPerPage)
			END;

		WITH SQLPaging AS
		(
			SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY FullName) AS RowNo
			     , FullName
				 , Data
			  FROM PersonImage
			 WHERE UPPER(RTRIM(LTRIM(FullName))) LIKE '%' + @sFullName + '%'
		)
		SELECT * FROM SQLPaging WITH (NOLOCK) 
			WHERE RowNo > ((@pageNum - 1) * @rowsPerPage);

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
