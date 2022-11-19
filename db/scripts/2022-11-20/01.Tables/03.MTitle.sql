/****** MTitle ******/ 
CREATE TABLE MTitle(
	TitleId int IDENTITY(1,1) NOT NULL,
	[Description] nvarchar(200) NOT NULL,
	GenderId int NULL,
	CONSTRAINT PK_MTitle PRIMARY KEY (TitleId ASC)
)
GO

CREATE UNIQUE INDEX IX_MTitle_Description ON MTitle([Description] ASC)
GO
