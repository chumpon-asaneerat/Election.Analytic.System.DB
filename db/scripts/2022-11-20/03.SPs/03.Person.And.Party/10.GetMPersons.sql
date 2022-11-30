/****** Object:  StoredProcedure [dbo].[GetMPersons]    Script Date: 11/26/2022 1:35:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPersons
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
--EXEC GetMPersons NULL, 'กร', NULL, @pageNum out, @rowsPerPage out, @totalRecords out, @maxPage out
--SELECT @totalRecords AS TotalPage, @maxPage AS MaxPage
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPersons]
(
  @Prefix nvarchar(100) = null
, @FirstName nvarchar(200) = null
, @LastName nvarchar(200) = null
, @pageNum as int = 1 out
, @rowsPerPage as int = 10 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
	BEGIN TRY
		-- calculate total record and maxpages
		SELECT @totalRecords = COUNT(*) 
		  FROM MPerson
		 WHERE UPPER(RTRIM(LTRIM(Prefix))) LIKE '%' + COALESCE(@Prefix, Prefix) + '%'
           AND UPPER(RTRIM(LTRIM(FirstName))) LIKE '%' + COALESCE(@FirstName, LastName) + '%'
           AND UPPER(RTRIM(LTRIM(LastName))) LIKE '%' + COALESCE(@LastName, LastName) + '%'

		SELECT @maxPage = 
			CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
				(@totalRecords / @rowsPerPage) + 1
			ELSE 
				(@totalRecords / @rowsPerPage)
			END;

		WITH SQLPaging AS
		(
			SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() 
              OVER (ORDER BY FirstName, LastName) AS RowNo
			     , PersonId
			     , Prefix
			     , FirstName
			     , LastName
                 , DOB
                 , GenderId
                 , EducationId
                 , OccupationId
                 , [Remark]
				 , [Data]
			  FROM MPerson
		     WHERE UPPER(RTRIM(LTRIM(Prefix))) LIKE '%' + COALESCE(@Prefix, Prefix) + '%'
               AND UPPER(RTRIM(LTRIM(FirstName))) LIKE '%' + COALESCE(@FirstName, FirstName) + '%'
               AND UPPER(RTRIM(LTRIM(LastName))) LIKE '%' + COALESCE(@LastName, LastName) + '%'
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
