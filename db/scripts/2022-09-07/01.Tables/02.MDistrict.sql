ALTER TABLE MDistrict 
  ADD AreaKm2 decimal(16, 3) NULL;
GO

ALTER TABLE MDistrict 
  ADD ContentId uniqueidentifier NULL;
GO