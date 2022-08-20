/****** Object:  StoredProcedure [dbo].[GetMTitles]    Script Date: 8/20/2022 7:42:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMTitles
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMTitles NULL, NULL, NULL, NULL      -- Gets all
-- EXEC GetMTitles NULL, N'นาง', NULL, NULL      -- Search all that Description contains 'นาง'
-- EXEC GetMTitles NULL, NULL, N'จ.', NULL   -- Search all that ShortName contains 'จ.'
-- EXEC GetMTitles NULL, NULL, NULL, 1  -- Search all that gender is male (0 - None, 1 - Male, 2 - Female)
-- =============================================
CREATE PROCEDURE [dbo].[GetMTitles]
(
  @TitleId int = NULL
, @description nvarchar(100) = NULL
, @shortName nvarchar(50) = NULL
, @genderId int = NULL
)
AS
BEGIN
	SELECT A.TitleId
	     , A.[Description]
	     , A.ShortName
	     , B.[Description] AS GenderName
	     , A.GenderId
	     , A.DLen
	     , A.SLen
	  FROM MTitleView A, MGender B
	 WHERE A.GenderId = B.GenderId
	   AND A.TitleId = COALESCE(@TitleId, A.TitleId)
	   AND UPPER(LTRIM(RTRIM(A.[Description]))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@description, A.[Description])))) + '%'
	   AND UPPER(LTRIM(RTRIM(A.ShortName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@shortName, A.ShortName)))) + '%'
	   AND A.GenderId = COALESCE(@genderId, A.GenderId)
	 ORDER BY A.DLen DESC
	        , A.SLen DESC
			, A.[Description]
			, A.ShortName
END

GO
