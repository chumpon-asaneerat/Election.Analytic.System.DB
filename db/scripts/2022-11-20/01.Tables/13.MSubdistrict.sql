/****** MSubdistrict ******/ 
CREATE TABLE MSubdistrict(
	ADM3Code nvarchar(20) NOT NULL,
	SubdistrictNameTH nvarchar(200) NOT NULL,
	SubdistrictNameEN nvarchar(200) NULL,
	ADM1Code nvarchar(20) NULL,
	ADM2Code nvarchar(20) NULL,
	RegionId nvarchar(20)  NULL,
	ProvinceId nvarchar(20)  NULL,
	DistrictId nvarchar(20)  NULL,
	SubdistrictId nvarchar(20)  NULL,
	AreaM2 decimal(16, 3) NULL,
	CONSTRAINT PK_MSubdistrict PRIMARY KEY (ADM3Code ASC)
)
GO

CREATE INDEX IX_MSubdistrict ON MSubdistrict(ADM3Code ASC)
GO

CREATE INDEX IX_MSubdistrict_ADM1Code ON MSubdistrict(ADM1Code ASC)
GO

CREATE INDEX IX_MSubdistrict_ADM2Code ON MSubdistrict(ADM2Code ASC)
GO

CREATE UNIQUE INDEX IX_MSubdistrict_SubdistrictNameTH ON MSubdistrict(SubdistrictNameTH ASC)
GO

CREATE UNIQUE INDEX IX_MSubdistrict_SubdistrictNameEN ON MSubdistrict(SubdistrictNameEN ASC)
GO

CREATE INDEX IX_MSubdistrict_RegionId ON MSubdistrict(RegionId ASC)
GO

CREATE INDEX IX_MSubdistrict_ProvinceId ON MSubdistrict(ProvinceId ASC)
GO

CREATE INDEX IX_MSubdistrict_DistrictId ON MSubdistrict(DistrictId ASC)
GO

CREATE INDEX IX_MSubdistrict_SubdistrictId ON MSubdistrict(SubdistrictId ASC)
GO

ALTER TABLE MSubdistrict ADD  CONSTRAINT DF_MSubdistrict_AreaM2  DEFAULT 0.0 FOR AreaM2
GO
