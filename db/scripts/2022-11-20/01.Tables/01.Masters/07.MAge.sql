/****** MAge ******/ 
CREATE TABLE MAge(
	AgeId int NOT NULL,
    AgeMin int NOT NULL,
    AgeMax int NOT NULL,
	[Description] nvarchar(200) NOT NULL,
	SortOrder int NOT NULL,
	Active int NOT NULL,
	CONSTRAINT PK_MAge PRIMARY KEY (AgeId ASC)
)
GO

CREATE UNIQUE INDEX IX_MAge_Description ON MAge([Description] ASC)
GO

ALTER TABLE MAge ADD  CONSTRAINT DF_MAge_SortOrder  DEFAULT 0 FOR SortOrder
GO

ALTER TABLE MAge ADD  CONSTRAINT DF_MAge_Active  DEFAULT 1 FOR Active
GO
