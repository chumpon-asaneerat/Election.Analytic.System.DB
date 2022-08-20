/****** Object:  StoredProcedure [dbo].[GetMContents]    Script Date: 8/20/2022 9:41:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMContents
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMContents NULL, NULL, NULL      -- Gets all
-- EXEC GetMContents NULL, 1, NULL         -- Gets all images
-- EXEC GetMContents NULL, 1, 2            -- Gets all person images
-- EXEC GetMContents NULL, 1, 2            -- Gets all logo images
-- EXEC GetMContents NULL, 2, NULL         -- Gets all data
-- EXEC GetMContents NULL, 2, 1            -- Gets all json data
-- =============================================
CREATE PROCEDURE [dbo].[GetMContents]
(
  @ContentId uniqueidentifier = NULL
, @FileTypeId int = NULL
, @FileSubTypeId int = NULL
)
AS
BEGIN
	SELECT *
	  FROM MContentView
	 WHERE ContentId = COALESCE(@ContentId, ContentId)
	   AND FileTypeId = COALESCE(@FileTypeId, FileTypeId)
	   AND FileSubTypeId = COALESCE(@FileSubTypeId, FileSubTypeId)
END

GO
