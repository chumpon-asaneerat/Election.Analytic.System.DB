/****** MPDCOfficial ******/ 
CREATE TABLE MPDCOfficial (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	CandidateNo int NOT NULL,
	RevoteNo int NOT NULL,
	PartyId int NOT NULL,
	PersonId int NOT NULL,
	VoteCount int NOT NULL,
    CONSTRAINT PK_MPDCOfficial PRIMARY KEY 
    (
        ThaiYear ASC
      , ADM1Code ASC
      , PollingUnitNo ASC
      , CandidateNo ASC
      , RevoteNo ASC
      , PartyId ASC
      , PersonId ASC
    )
)
GO

CREATE INDEX IX_MMPDCOfficial_ThaiYear ON MPDCOfficial(ThaiYear ASC)
GO

CREATE INDEX IX_MPDCOfficial_ADM1Code ON MPDCOfficial(ADM1Code ASC)
GO

CREATE INDEX IX_MPDCOfficial_PollingUnitNo ON MPDCOfficial(PollingUnitNo ASC)
GO

CREATE INDEX IX_MPDCOfficial_CandidateNo ON MPDCOfficial(CandidateNo ASC)
GO

CREATE INDEX IX_MPDCOfficial_RevoteNo ON MPDCOfficial(RevoteNo ASC)
GO

CREATE INDEX IX_MPDCOfficial_PartyId ON MPDCOfficial(PartyId ASC)
GO

CREATE INDEX IX_MPDCOfficial_PersonId ON MPDCOfficial(PersonId ASC)
GO

ALTER TABLE MPDCOfficial ADD  CONSTRAINT DF_MPDCOfficial_CandidateNo  DEFAULT 0 FOR CandidateNo
GO

ALTER TABLE MPDCOfficial ADD  CONSTRAINT DF_MPDCOfficial_RevoteNo  DEFAULT 0 FOR RevoteNo
GO

ALTER TABLE MPDCOfficial ADD  CONSTRAINT DF_MPDCOfficial_VoteCount  DEFAULT 0 FOR VoteCount
GO
