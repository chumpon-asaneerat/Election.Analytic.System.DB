/****** MPDCOfficial ******/ 
CREATE TABLE MPDCOfficial (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	RevoteNo int NOT NULL,
	PartyId int NOT NULL,
	PersonId int NOT NULL,
    SortOrder int NOT NULL,
	VoteCount int NOT NULL,
    CONSTRAINT PK_MPDCOfficial PRIMARY KEY 
    (
        ThaiYear ASC
      , ADM1Code ASC
      , PollingUnitNo ASC
      , RevoteNo ASC
      , PartyId ASC
    )
)
GO

CREATE INDEX IX_MMPDCOfficial_ThaiYear ON MPDCOfficial(ThaiYear ASC)
GO

CREATE INDEX IX_MPDCOfficial_ADM1Code ON MPDCOfficial(ADM1Code ASC)
GO

CREATE INDEX IX_MPDCOfficial_PollingUnitNo ON MPDCOfficial(PollingUnitNo ASC)
GO

CREATE INDEX IX_MPDCOfficial_RevoteNo ON MPDCOfficial(RevoteNo ASC)
GO

CREATE INDEX IX_MPDCOfficial_PartyId ON MPDCOfficial(PartyId ASC)
GO

CREATE INDEX IX_MPDCOfficial_PersonId ON MPDCOfficial(PersonId ASC)
GO

CREATE INDEX IX_MPDCOfficial_SortOrder ON MPDCOfficial(SortOrder ASC)
GO

ALTER TABLE MPDCOfficial ADD  CONSTRAINT DF_MPDCOfficial_SortOrder  DEFAULT 0 FOR SortOrder
GO

ALTER TABLE MPDCOfficial ADD  CONSTRAINT DF_MPDCOfficial_RevoteNo  DEFAULT 0 FOR RevoteNo
GO

ALTER TABLE MPDCOfficial ADD  CONSTRAINT DF_MPDCOfficial_VoteCount  DEFAULT 0 FOR VoteCount
GO
