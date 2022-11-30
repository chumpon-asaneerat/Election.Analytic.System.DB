/****** MPDVoteStatistic ******/ 
CREATE TABLE MPDC (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	CandidateNo int NOT NULL,
	PersonId int NOT NULL,
	PrevPartyId int NULL,
	EducationId int NULL,
    [Remark] nvarchar(max) NULL,
    SubGroup nvarchar(max) NULL,
    CONSTRAINT PK_MPDVoteStatistic PRIMARY KEY 
    (
        ThaiYear ASC
      , ADM1Code ASC
      , PollingUnitNo ASC
      , CandidateNo ASC
    )
)
GO

CREATE INDEX IX_MPDC_ThaiYear ON MPDC(ThaiYear ASC)
GO

CREATE INDEX IX_MPDC_ADM1Code ON MPDC(ADM1Code ASC)
GO

CREATE INDEX IX_MPDC_PollingUnitNo ON MPDC(PollingUnitNo ASC)
GO

CREATE INDEX IX_MPDC_CandidateNo ON MPDC(CandidateNo ASC)
GO

ALTER TABLE MPDC ADD  CONSTRAINT DF_MPDC_CandidateNo  DEFAULT 0 FOR CandidateNo
GO
