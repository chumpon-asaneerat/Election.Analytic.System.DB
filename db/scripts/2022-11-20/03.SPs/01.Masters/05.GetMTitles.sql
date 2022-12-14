/****** Object:  StoredProcedure [dbo].[GetMTitles]    Script Date: 11/27/2022 10:05:27 PM ******/
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
-- EXEC GetMTitles NULL, NULL    -- Gets all
-- EXEC GetMTitles N'นาง', NULL  -- Search all that Description contains 'นาง'
-- EXEC GetMTitles NULL, 1       -- Search all that gender is male (0 - None, 1 - Male, 2 - Female)
-- =============================================
CREATE PROCEDURE [dbo].[GetMTitles]
(
  @description nvarchar(200) = NULL
, @genderId int = NULL
)
AS
BEGIN
	SELECT A.TitleId
         , A.[Description]
	     , B.[Description] AS GenderName
	     , A.GenderId
	     , A.DLen
	  FROM MTitleView A, MGender B
	 WHERE A.GenderId = B.GenderId
	   AND UPPER(LTRIM(RTRIM(A.[Description]))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@description, A.[Description])))) + '%'
	   AND A.GenderId = COALESCE(@genderId, A.GenderId)
	 ORDER BY A.DLen DESC
			, A.[Description]
END

GO
