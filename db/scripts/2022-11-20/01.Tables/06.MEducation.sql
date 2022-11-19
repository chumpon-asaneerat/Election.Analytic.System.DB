/****** MEducation ******/ 
CREATE TABLE MEducation(
	EducationId int NOT NULL,
	[Description] nvarchar(200) NOT NULL,
	SortOrder int NOT NULL,
	Active int NOT NULL,
	CONSTRAINT PK_MEducation PRIMARY KEY (EducationId ASC)
)
GO

CREATE UNIQUE INDEX IX_MEducation_Description ON MEducation([Description] ASC)
GO

ALTER TABLE MEducation ADD  CONSTRAINT DF_MEducation_SortOrder  DEFAULT 0 FOR SortOrder
GO

ALTER TABLE MEducation ADD  CONSTRAINT DF_MEducation_Active  DEFAULT 1 FOR Active
GO
