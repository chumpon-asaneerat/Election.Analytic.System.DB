/****** Object:  StoredProcedure [dbo].[GetMParties]    Script Date: 11/26/2022 1:15:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMParties
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
--EXEC GetMParties 'กร', @pageNum out, @rowsPerPage out, @totalRecords out, @maxPage out
--SELECT @totalRecords AS TotalPage, @maxPage AS MaxPage
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMParties]
(
  @PartyName nvarchar(100) = null
, @pageNum as int = 1 out
, @rowsPerPage as int = 10 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @sPartyName nvarchar(100)
	BEGIN TRY
		IF (@PartyName IS NULL)
		BEGIN
			SET @sPartyName = N''
		END
		ELSE
		BEGIN
			SET @sPartyName = UPPER(RTRIM(LTRIM(@PartyName)))
		END

		-- calculate total record and maxpages
		SELECT @totalRecords = COUNT(PartyId) 
		  FROM MParty
		 WHERE UPPER(RTRIM(LTRIM(PartyName))) LIKE '%' + @sPartyName + '%'

		SELECT @maxPage = 
			CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
				(@totalRecords / @rowsPerPage) + 1
			ELSE 
				(@totalRecords / @rowsPerPage)
			END;

		WITH SQLPaging AS
		(
			SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY PartyName) AS RowNo
			     , PartyName
				 , Data
			  FROM MParty
			 WHERE UPPER(RTRIM(LTRIM(PartyName))) LIKE '%' + @sPartyName + '%'
			 ORDER BY PartyName
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
