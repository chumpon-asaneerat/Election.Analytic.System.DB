/****** MPDVoteSummary ******/ 
CREATE TABLE MPDVoteSummary (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	CandidateNo int NOT NULL,
	RevoteNo int NOT NULL,
	PartyId int NOT NULL,
	PersonId int NOT NULL,
	VoteCount int NOT NULL,
    CONSTRAINT PK_MPDVoteSummary PRIMARY KEY 
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

CREATE INDEX IX_MPDVoteSummary_ThaiYear ON MPDVoteSummary(ThaiYear ASC)
GO

CREATE INDEX IX_MPDVoteSummary_ADM1Code ON MPDVoteSummary(ADM1Code ASC)
GO

CREATE INDEX IX_MPDVoteSummary_PollingUnitNo ON MPDVoteSummary(PollingUnitNo ASC)
GO

CREATE INDEX IX_MPDVoteSummary_CandidateNo ON MPDVoteSummary(CandidateNo ASC)
GO

CREATE INDEX IX_MPDVoteSummary_RevoteNo ON MPDVoteSummary(RevoteNo ASC)
GO

CREATE INDEX IX_MPDVoteSummary_PartyId ON MPDVoteSummary(PartyId ASC)
GO

CREATE INDEX IX_MPDVoteSummary_PersonId ON MPDVoteSummary(PersonId ASC)
GO

ALTER TABLE MPDVoteSummary ADD  CONSTRAINT DF_MPDVoteSummary_CandidateNo  DEFAULT 0 FOR CandidateNo
GO

ALTER TABLE MPDVoteSummary ADD  CONSTRAINT DF_MPDVoteSummary_RevoteNo  DEFAULT 0 FOR RevoteNo
GO

ALTER TABLE MPDVoteSummary ADD  CONSTRAINT DF_MPDVoteSummary_VoteCount  DEFAULT 0 FOR VoteCount
GO
