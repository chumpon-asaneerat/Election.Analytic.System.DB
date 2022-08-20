/****** Object:  View [dbo].[MContentView]    Script Date: 8/20/2022 10:00:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MContentView]
AS
	SELECT A.ContentId
	     , A.Data
	     , A.LastUpdated
		 , B.[Description] AS FileTypeName
		 , C.[Description] AS FileSubTypeName
		 , A.FileTypeId
		 , A.FileSubTypeId
	  FROM MContent A
	     , MFileType B
	     , MFileSubType C
	 WHERE C.FileTypeId = B.FileTypeId
	   AND A.FileTypeId = C.FileTypeId
	   AND A.FileSubTypeId = C.FileSubTypeId

GO
