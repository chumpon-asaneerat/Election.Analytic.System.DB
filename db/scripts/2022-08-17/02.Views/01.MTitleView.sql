/****** Object:  View [dbo].[MTitleView]    Script Date: 8/20/2022 7:40:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MTitleView]
AS
SELECT TitleId
     , [Description]
	 , ShortName
	 , GenderId
	 , LEN([Description]) AS DLen
	 , LEN(ShortName) AS SLen
  FROM MTitle

GO
