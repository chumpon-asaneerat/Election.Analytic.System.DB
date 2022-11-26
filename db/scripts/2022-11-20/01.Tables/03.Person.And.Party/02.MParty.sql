/****** MParty ******/ 
CREATE TABLE MParty(
	PartyId int IDENTITY(1,1) NOT NULL,
	PartyName nvarchar(200) NOT NULL,
	Data varbinary(max) NULL,
	CONSTRAINT PK_MParty PRIMARY KEY (PartyId ASC)
)
GO

CREATE UNIQUE INDEX IX_MParty_PartyName ON MParty(PartyName ASC)
GO
