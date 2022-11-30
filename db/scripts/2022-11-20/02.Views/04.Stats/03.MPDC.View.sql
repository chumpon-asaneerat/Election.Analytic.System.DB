/****** Object:  View [dbo].[MTitleView]    Script Date: 11/26/2022 1:56:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MTitleView]
AS
	SELECT TitleId
         , [Description]
	     , GenderId
		 , LEN([Description]) AS DLen
	  FROM MTitle

GO
