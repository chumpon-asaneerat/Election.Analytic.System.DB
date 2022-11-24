/****** MRegion ******/ 
CREATE TABLE MRegion(
	RegionId nvarchar(20) NOT NULL,
	RegionName nvarchar(200) NOT NULL,
	GeoGroup nvarchar(200) NULL,
	GeoSubGroup nvarchar(200) NULL,
	CONSTRAINT PK_MRegion PRIMARY KEY (RegionId ASC)
)
GO

CREATE INDEX IX_MRegion ON MRegion(RegionId ASC)
GO

CREATE UNIQUE INDEX IX_MRegion_RegionName ON MRegion(RegionName ASC)
GO

CREATE INDEX IX_MRegion_GeoGroup ON MRegion(GeoGroup ASC)
GO

CREATE INDEX IX_MRegion_GeoSubGroup ON MRegion(GeoSubGroup ASC)
GO
