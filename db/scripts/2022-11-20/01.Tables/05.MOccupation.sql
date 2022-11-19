/****** MOccupation ******/ 
CREATE TABLE MOccupation(
	OccupationId int NOT NULL,
	[Description] nvarchar(100) NOT NULL,
	SortOrder int NOT NULL,
	Active int NOT NULL,
	CONSTRAINT PK_MOccupation PRIMARY KEY (OccupationId ASC)
)
GO

ALTER TABLE MOccupation ADD  CONSTRAINT DF_MOccupation_SortOrder  DEFAULT 0 FOR SortOrder
GO

ALTER TABLE MOccupation ADD  CONSTRAINT DF_MOccupation_Active  DEFAULT 1 FOR Active
GO
