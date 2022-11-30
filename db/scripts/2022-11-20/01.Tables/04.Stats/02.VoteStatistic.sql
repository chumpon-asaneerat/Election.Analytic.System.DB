/****** MPDVoteSummary ******/ 
CREATE TABLE MPDVoteStatistic (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	RightCount int NOT NULL,
	ExerciseCount int NOT NULL,
	InvalidCount int NOT NULL,
	NoVoteCount int NOT NULL,
    CONSTRAINT PK_MPDVoteStatistic PRIMARY KEY 
    (
        ThaiYear ASC
      , ADM1Code ASC
      , PollingUnitNo ASC
    )
)
GO

CREATE INDEX IX_MPDVoteStatistic_ThaiYear ON MPDVoteStatistic(ThaiYear ASC)
GO

CREATE INDEX IX_MPDVoteStatistic_ADM1Code ON MPDVoteStatistic(ADM1Code ASC)
GO

CREATE INDEX IX_MPDVoteStatistic_PollingUnitNo ON MPDVoteStatistic(PollingUnitNo ASC)
GO

ALTER TABLE MPDVoteStatistic ADD  CONSTRAINT DF_MPDVoteStatistic_RightCount  DEFAULT 0 FOR RightCount
GO

ALTER TABLE MPDVoteStatistic ADD  CONSTRAINT DF_MPDVoteStatistic_ExerciseCount  DEFAULT 0 FOR ExerciseCount
GO

ALTER TABLE MPDVoteStatistic ADD  CONSTRAINT DF_MPDVoteStatistic_InvalidCount  DEFAULT 0 FOR InvalidCount
GO

ALTER TABLE MPDVoteStatistic ADD  CONSTRAINT DF_MPDVoteStatistic_NoVoteCount  DEFAULT 0 FOR NoVoteCount
GO
