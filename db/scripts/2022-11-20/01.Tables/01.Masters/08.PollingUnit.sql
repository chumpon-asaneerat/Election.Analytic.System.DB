/****** PollingUnit ******/ 
CREATE TABLE PollingUnit (
	ThaiYear int NOT NULL,
	ADM1Code nvarchar(20) NOT NULL,
	PollingUnitNo int NOT NULL,
	PollingUnitCount int NOT NULL,
	AreaRemark nvarchar(MAX) NULL,
    CONSTRAINT PK_PollingUnit PRIMARY KEY (ThaiYear ASC, ADM1Code ASC, PollingUnitNo ASC )
)
GO

CREATE INDEX IX_PollingUnit_ThaiYear ON PollingUnit(ThaiYear ASC)
GO

CREATE INDEX IX_PollingUnit_ADM1Code ON PollingUnit(ADM1Code ASC)
GO

CREATE INDEX IX_PollingUnit_PollingUnitNo ON PollingUnit(PollingUnitNo ASC)
GO

ALTER TABLE PollingUnit ADD  CONSTRAINT DF_PollingUnit_PollingUnitCount  DEFAULT 0 FOR PollingUnitCount
GO
