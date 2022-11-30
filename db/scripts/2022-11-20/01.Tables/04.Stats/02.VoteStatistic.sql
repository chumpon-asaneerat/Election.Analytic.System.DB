/****** MPDVoteSummary ******/ 
CREATE TABLE MPDVoteStatistic (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	CandidateNo int NOT NULL,
	RevoteNo int NOT NULL,
	PartyId int NOT NULL,
	PersonId int NOT NULL,
	VoteCount int NOT NULL,
    CONSTRAINT PK_MPDVoteStatistic PRIMARY KEY 
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

CREATE INDEX IX_MPDVoteStatistic_ThaiYear ON MPDVoteStatistic(ThaiYear ASC)
GO

CREATE INDEX IX_MPDVoteStatistic_ADM1Code ON MPDVoteStatistic(ADM1Code ASC)
GO

CREATE INDEX IX_MPDVoteStatistic_PollingUnitNo ON MPDVoteStatistic(PollingUnitNo ASC)
GO

CREATE INDEX IX_MPDVoteStatistic_CandidateNo ON MPDVoteStatistic(CandidateNo ASC)
GO

CREATE INDEX IX_MPDVoteStatistic_RevoteNo ON MPDVoteStatistic(RevoteNo ASC)
GO

CREATE INDEX IX_MPDVoteStatistic_PartyId ON MPDVoteStatistic(PartyId ASC)
GO

CREATE INDEX IX_MPDVoteStatistic_PersonId ON MPDVoteStatistic(PersonId ASC)
GO

ALTER TABLE MPDVoteStatistic ADD  CONSTRAINT DF_MPDVoteStatistic_CandidateNo  DEFAULT 0 FOR CandidateNo
GO

ALTER TABLE MPDVoteStatistic ADD  CONSTRAINT DF_MPDVoteStatistic_RevoteNo  DEFAULT 0 FOR RevoteNo
GO

ALTER TABLE MPDVoteStatistic ADD  CONSTRAINT DF_MPDVoteStatistic_VoteCount  DEFAULT 0 FOR VoteCount
GO
