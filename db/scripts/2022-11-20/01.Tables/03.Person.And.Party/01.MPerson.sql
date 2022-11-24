/****** MPerson ******/ 
CREATE TABLE MPerson(
	PersonId int IDENTITY(1,1) NOT NULL,
	Prefix nvarchar(100) NULL,
	FirstName nvarchar(200) NOT NULL,
	LastName nvarchar(200) NOT NULL,
	DOB datetime NULL,
	GenderId int NULL,
	EducationId int NULL,
	OccupationId int NULL,
	[Remark] nvarchar(max) NULL,
	Data varbinary(max) NULL,
	CONSTRAINT PK_MPerson PRIMARY KEY (PersonId ASC)
)
GO

CREATE NONCLUSTERED INDEX IX_MPerson_FirstName ON MPerson(FirstName ASC)
GO

CREATE NONCLUSTERED INDEX IX_MPerson_LastName ON MPerson(LastName ASC)
GO

ALTER TABLE MPerson
  ADD CONSTRAINT DF_MPerson_GenderId DEFAULT 0 FOR GenderId
GO

ALTER TABLE MPerson
  ADD CONSTRAINT DF_MPerson_EducationId DEFAULT 0 FOR EducationId
GO

ALTER TABLE MPerson
  ADD CONSTRAINT DF_MPerson_OccupationId DEFAULT 0 FOR OccupationId
GO
