/****** MPDStatVoter ******/ 
CREATE TABLE MPDStatVoter (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	RightCount int NOT NULL,
	ExerciseCount int NOT NULL,
	InvalidCount int NOT NULL,
	NoVoteCount int NOT NULL,
    CONSTRAINT PK_MPDStatVoter PRIMARY KEY 
    (
        ThaiYear ASC
      , ADM1Code ASC
      , PollingUnitNo ASC
    )
)
GO

CREATE INDEX IX_MPDStatVoter_ThaiYear ON MPDStatVoter(ThaiYear ASC)
GO

CREATE INDEX IX_MPDStatVoter_ADM1Code ON MPDStatVoter(ADM1Code ASC)
GO

CREATE INDEX IX_MPDStatVoter_PollingUnitNo ON MPDStatVoter(PollingUnitNo ASC)
GO

ALTER TABLE MPDStatVoter ADD  CONSTRAINT DF_MPDStatVoter_RightCount  DEFAULT 0 FOR RightCount
GO

ALTER TABLE MPDStatVoter ADD  CONSTRAINT DF_MPDStatVoter_ExerciseCount  DEFAULT 0 FOR ExerciseCount
GO

ALTER TABLE MPDStatVoter ADD  CONSTRAINT DF_MPDStatVoter_InvalidCount  DEFAULT 0 FOR InvalidCount
GO

ALTER TABLE MPDStatVoter ADD  CONSTRAINT DF_MPDStatVoter_NoVoteCount  DEFAULT 0 FOR NoVoteCount
GO
