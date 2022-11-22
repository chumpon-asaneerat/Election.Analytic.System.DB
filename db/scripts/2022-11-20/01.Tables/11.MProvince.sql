/****** MProvince ******/ 
CREATE TABLE MProvince(
	ADM1Code nvarchar(20) NOT NULL,
	ProvinceNameTH nvarchar(200) NOT NULL,
	ProvinceNameEN nvarchar(200) NULL,
	RegionId nvarchar(20)  NULL,
	ProvinceId nvarchar(20)  NULL,
	AreaM2 decimal(16, 3) NULL,
	CONSTRAINT PK_MProvince PRIMARY KEY (ADM1Code ASC)
)
GO

CREATE INDEX IX_MProvince ON MProvince(ADM1Code ASC)
GO

CREATE UNIQUE INDEX IX_MProvince_ProvinceNameTH ON MProvince(ProvinceNameTH ASC)
GO

CREATE UNIQUE INDEX IX_MProvince_ProvinceNameEN ON MProvince(ProvinceNameEN ASC)
GO

CREATE INDEX IX_MProvince_RegionId ON MProvince(RegionId ASC)
GO

CREATE INDEX IX_MProvince_ProvinceId ON MProvince(ProvinceId ASC)
GO

ALTER TABLE MProvince ADD  CONSTRAINT DF_MProvince_AreaM2  DEFAULT 0.0 FOR AreaM2
GO

