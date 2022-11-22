CREATE TABLE MDistrict(
	ADM2Code nvarchar(20) NOT NULL,
	DistrictNameTH nvarchar(200) NOT NULL,
	DistrictNameEN nvarchar(200) NULL,
	ADM1Code nvarchar(20) NULL,
	RegionId nvarchar(20)  NULL,
	ProvinceId nvarchar(20)  NULL,
	AreaM2 decimal(16, 3) NULL,
	CONSTRAINT PK_MDistrict PRIMARY KEY (ADM2Code ASC)
)
GO

CREATE INDEX IX_MDistrict ON MDistrict(ADM2Code ASC)
GO

CREATE INDEX IX_MDistrict_ADM1Code ON MDistrict(ADM1Code ASC)
GO

CREATE UNIQUE INDEX IX_MDistrict_DistrictNameTH ON MDistrict(DistrictNameTH ASC)
GO

CREATE UNIQUE INDEX IX_MDistrict_DistrictNameEN ON MDistrict(DistrictNameEN ASC)
GO

CREATE INDEX IX_MDistrict_RegionId ON MDistrict(RegionId ASC)
GO

ALTER TABLE MDistrict ADD  CONSTRAINT DF_MDistrict_AreaM2  DEFAULT 0.0 FOR AreaM2
GO

