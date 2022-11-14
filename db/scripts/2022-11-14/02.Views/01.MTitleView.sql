/****** Object:  View [dbo].[MTitleView]    Script Date: 11/14/2022 9:59:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[MTitleView]
AS
	(
		SELECT [Description]
			 , ShortName
			 , GenderId
			 , LEN([Description]) AS DLen
			 , LEN(ShortName) AS SLen
		  FROM MTitle
	)
	UNION
	(
		SELECT DISTINCT ShortName AS [Description]
			 , ShortName
			 , GenderId
			 , LEN(ShortName) AS DLen
			 , LEN(ShortName) AS SLen
		  FROM MTitle
	 )

GO
