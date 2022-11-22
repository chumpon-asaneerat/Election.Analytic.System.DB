/****** Object:  View [dbo].[MTitleView]    Script Date: 11/16/2022 2:21:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MTitleView]
AS
	SELECT TitleId
         , [Description]
	     , GenderId
		 , LEN([Description]) AS DLen
	  FROM MTitle

GO
