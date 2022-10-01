/*********** Script Update Date: 2022-09-29  ***********/
ALTER TABLE MPDC2566 ALTER COLUMN Remark NVARCHAR(4000);


/*********** Script Update Date: 2022-09-29  ***********/
ALTER TABLE MPD2562PollingUnitSummary ALTER COLUMN AreaRemark NVARCHAR(4000);


/*********** Script Update Date: 2022-09-29  ***********/
ALTER TABLE MPD2566PollingUnitSummary ALTER COLUMN AreaRemark NVARCHAR(4000);


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPD2562PollingUnitSummary]    Script Date: 9/29/2022 8:37:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPD2562PollingUnitSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--  - 
--  
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPD2562PollingUnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @AreaRemark nvarchar(4000) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter(s)) is null';
			RETURN
		END
		IF (@PollingUnitCount IS NULL) SET @PollingUnitCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562PollingUnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2562PollingUnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, PollingUnitCount
				, AreaRemark
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @PollingUnitCount
				, @AreaRemark
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562PollingUnitSummary
			   SET PollingUnitCount = @PollingUnitCount
			     , AreaRemark = @AreaRemark
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPD2562PollingUnitSummary]    Script Date: 9/29/2022 8:37:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2562PollingUnitSummary
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--  
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SaveMPD2562PollingUnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @AreaRemark nvarchar(4000) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter(s)) is null';
			RETURN
		END
		IF (@PollingUnitCount IS NULL) SET @PollingUnitCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562PollingUnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2562PollingUnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, PollingUnitCount
                , AreaRemark
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @PollingUnitCount
                , @AreaRemark
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562PollingUnitSummary
			   SET PollingUnitCount = @PollingUnitCount
                 , AreaRemark = @AreaRemark
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportPersonImage]    Script Date: 9/29/2022 8:46:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportPersonImage
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportPersonImage] (
  @FullName nvarchar(200)
, @Data varbinary(MAX)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @LastUpdate datetime
	BEGIN TRY
        -- SET LAST UPDATE DATETIME
	    SET @LastUpdate = GETDATE();

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM PersonImage
				 WHERE FullName = @FullName 
			)
		   )
		BEGIN
			INSERT INTO PersonImage
			(
				  FullName
				, [Data] 
			)
			VALUES
			(
				  @FullName
				, @Data
			);
		END
		ELSE
		BEGIN
			UPDATE PersonImage
			   SET [Data] = @Data
			 WHERE FullName = @FullName
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[SavePersonImage]    Script Date: 9/29/2022 8:46:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SavePersonImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SavePersonImage] (
  @FullName nvarchar(200)
, @Data varbinary(MAX)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @LastUpdate datetime
	BEGIN TRY
        -- SET LAST UPDATE DATETIME
	    SET @LastUpdate = GETDATE();

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM PersonImage
				 WHERE FullName = @FullName 
			)
		   )
		BEGIN
			INSERT INTO PersonImage
			(
				  FullName
				, [Data] 
			)
			VALUES
			(
				  @FullName
				, @Data
			);
		END
		ELSE
		BEGIN
			UPDATE PersonImage
			   SET [Data] = @Data
			 WHERE FullName = @FullName
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562PollingUnitSummaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562PollingUnitSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562PollingUnitSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
	  FROM MPD2562PollingUnitSummary
	 WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
	 ORDER BY ProvinceName, PollingUnitNo
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562PollingUnitSummary]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562PollingUnitSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562PollingUnitSummary]
(
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
)
AS
BEGIN
    SELECT * 
	  FROM MPD2562PollingUnitSummary
	 WHERE ProvinceName = @ProvinceName
	   AND PollingUnitNo = @PollingUnitNo
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2566PollingUnitSummaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2566PollingUnitSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2566PollingUnitSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
	  FROM MPD2566PollingUnitSummary
	 WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
	 ORDER BY ProvinceName, PollingUnitNo
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2566PollingUnitSummary]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2566PollingUnitSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2566PollingUnitSummary]
(
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
)
AS
BEGIN
    SELECT * 
	  FROM MPD2566PollingUnitSummary
	 WHERE ProvinceName = @ProvinceName
	   AND PollingUnitNo = @PollingUnitNo
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPD2566PollingUnitSummary]    Script Date: 9/29/2022 9:37:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPD2566PollingUnitSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPD2566PollingUnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @AreaRemark nvarchar(4000) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter(s) is null';
			RETURN
		END
		IF (@PollingUnitCount IS NULL) SET @PollingUnitCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2566PollingUnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2566PollingUnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, PollingUnitCount
				, AreaRemark
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @PollingUnitCount
				, @AreaRemark
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2566PollingUnitSummary
			   SET PollingUnitCount = @PollingUnitCount
                 , AreaRemark = @AreaRemark
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPD2566PollingUnitSummary]    Script Date: 9/29/2022 9:37:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2566PollingUnitSummary
-- [== History ==]
-- <2022-09-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SaveMPD2566PollingUnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @AreaRemark nvarchar(4000) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter(s) is null';
			RETURN
		END
		IF (@PollingUnitCount IS NULL) SET @PollingUnitCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2566PollingUnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2566PollingUnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, PollingUnitCount
                , AreaRemark
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @PollingUnitCount
                , @AreaRemark
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2566PollingUnitSummary
			   SET PollingUnitCount = @PollingUnitCount
                 , AreaRemark = @AreaRemark
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportPollingStation]    Script Date: 9/29/2022 9:59:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportPollingStation
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- 
-- EXEC ImportPollingStatione @data, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- =============================================
ALTER PROCEDURE [dbo].[ImportPollingStation] (
  @YearThai int
, @RegionName nvarchar(100)
, @GeoSubGroup nvarchar(100)
, @ProvinceId nvarchar(10)
, @ProvinceNameTH nvarchar(100)
, @DistrictId nvarchar(10)
, @DistrictNameTH nvarchar(100)
, @SubdistrictId nvarchar(10)
, @SubdistrictNameTH nvarchar(100)
, @PollingUnitNo int
, @PollingSubUnitNo int
, @VillageCount int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @RegionId nvarchar(10);
	BEGIN TRY
	    -- Check all required parameters should not be null
		IF (   @YearThai IS NULL 
		    OR @RegionName IS NULL
		    OR @GeoSubGroup IS NULL
		    OR @ProvinceId IS NULL
		    OR @ProvinceNameTH IS NULL
		    OR @DistrictId IS NULL
		    OR @DistrictNameTH IS NULL
		    OR @SubdistrictId IS NULL
		    OR @SubdistrictNameTH IS NULL
			OR @PollingUnitNo IS NULL
			OR @PollingSubUnitNo IS NULL
		   )
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some of required parameters is null.';
			RETURN
		END
	    
		-- Check RegionName to find RegionId
		SET @RegionId = dbo.FindRegionId(@RegionName);
		IF (@RegionId IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'Cannot Find RegionId by RegionName: ' + CONVERT(nvarchar(100), @RegionName);
			RETURN
		END

		-- Auto save master tables.
		EXEC SaveMProvince @ProvinceId, @RegionId, @ProvinceNameTH
		EXEC SaveMDistrict @DistrictId, @RegionId, @ProvinceId, @DistrictNameTH
		EXEC SaveMSubdistrict @SubdistrictId, @RegionId, @ProvinceId, @DistrictId, @SubdistrictNameTH

		-- Check INSERT OR UPDATE
		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM PollingStation
				 WHERE YearThai = @YearThai
				   AND RegionId = @RegionId
				   AND ProvinceId = @ProvinceId
				   AND DistrictId = @DistrictId
				   AND SubdistrictId = @SubdistrictId
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO PollingStation
			(
				  YearThai
				, RegionId
				, ProvinceId
				, DistrictId
				, SubdistrictId
				, PollingUnitNo
				, PollingSubUnitNo
				, VillageCount
			)
			VALUES
			(
				  @YearThai
				, @RegionId
				, @ProvinceId
				, @DistrictId
				, @SubdistrictId
				, @PollingUnitNo
				, @PollingSubUnitNo
				, @VillageCount
			);
		END
		ELSE
		BEGIN
			UPDATE PollingStation
			   SET PollingSubUnitNo = @PollingSubUnitNo
				 , VillageCount = @VillageCount
			 WHERE YearThai = @YearThai
			   AND RegionId = @RegionId
			   AND ProvinceId = @ProvinceId
			   AND DistrictId = @DistrictId
			   AND SubdistrictId = @SubdistrictId
			   AND PollingUnitNo = @PollingUnitNo;
		END

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[SavePollingStation]    Script Date: 9/29/2022 9:59:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SavePollingStation
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- 
-- EXEC SavePollingStation @data, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- =============================================
CREATE PROCEDURE [dbo].[SavePollingStation] (
  @YearThai int
, @RegionName nvarchar(100)
, @GeoSubGroup nvarchar(100)
, @ProvinceId nvarchar(10)
, @ProvinceNameTH nvarchar(100)
, @DistrictId nvarchar(10)
, @DistrictNameTH nvarchar(100)
, @SubdistrictId nvarchar(10)
, @SubdistrictNameTH nvarchar(100)
, @PollingUnitNo int
, @PollingSubUnitNo int
, @VillageCount int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @RegionId nvarchar(10);
	BEGIN TRY
	    -- Check all required parameters should not be null
		IF (   @YearThai IS NULL 
		    OR @RegionName IS NULL
		    OR @GeoSubGroup IS NULL
		    OR @ProvinceId IS NULL
		    OR @ProvinceNameTH IS NULL
		    OR @DistrictId IS NULL
		    OR @DistrictNameTH IS NULL
		    OR @SubdistrictId IS NULL
		    OR @SubdistrictNameTH IS NULL
			OR @PollingUnitNo IS NULL
			OR @PollingSubUnitNo IS NULL
		   )
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some of required parameters is null.';
			RETURN
		END
	    
		-- Check RegionName to find RegionId
		SET @RegionId = dbo.FindRegionId(@RegionName);
		IF (@RegionId IS NULL)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = 'Cannot Find RegionId by RegionName: ' + CONVERT(nvarchar(100), @RegionName);
			RETURN
		END

		-- Auto save master tables.
		EXEC SaveMProvince @ProvinceId, @RegionId, @ProvinceNameTH
		EXEC SaveMDistrict @DistrictId, @RegionId, @ProvinceId, @DistrictNameTH
		EXEC SaveMSubdistrict @SubdistrictId, @RegionId, @ProvinceId, @DistrictId, @SubdistrictNameTH

		-- Check INSERT OR UPDATE
		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM PollingStation
				 WHERE YearThai = @YearThai
				   AND RegionId = @RegionId
				   AND ProvinceId = @ProvinceId
				   AND DistrictId = @DistrictId
				   AND SubdistrictId = @SubdistrictId
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO PollingStation
			(
				  YearThai
				, RegionId
				, ProvinceId
				, DistrictId
				, SubdistrictId
				, PollingUnitNo
				, PollingSubUnitNo
				, VillageCount
			)
			VALUES
			(
				  @YearThai
				, @RegionId
				, @ProvinceId
				, @DistrictId
				, @SubdistrictId
				, @PollingUnitNo
				, @PollingSubUnitNo
				, @VillageCount
			);
		END
		ELSE
		BEGIN
			UPDATE PollingStation
			   SET PollingSubUnitNo = @PollingSubUnitNo
				 , VillageCount = @VillageCount
			 WHERE YearThai = @YearThai
			   AND RegionId = @RegionId
			   AND ProvinceId = @ProvinceId
			   AND DistrictId = @DistrictId
			   AND SubdistrictId = @SubdistrictId
			   AND PollingUnitNo = @PollingUnitNo;
		END

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetPollingStations]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPollingStations
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPollingStations]
(
  @RegionName nvarchar(100) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
        FROM PollingStationView 
        WHERE UPPER(LTRIM(RTRIM(RegionName))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName))))
        AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
        ORDER BY RegionId 
            , ProvinceNameTH 
            , DistrictNameTH 
            , SubdistrictNameTH 
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPD2562VoteSummary]    Script Date: 9/30/2022 6:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPD2562VoteSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPD2562VoteSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @FullName nvarchar(200)
, @VoteNo int
, @PartyName nvarchar(200)
, @VoteCount int = 0
, @RevoteNo int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL 
		 OR @FullName IS NULL 
		 OR @VoteNo IS NULL
		 OR @PartyName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END
		IF (@VoteCount IS NULL) SET @VoteCount = 0;
		IF (@RevoteNo IS NULL) SET @RevoteNo = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562VoteSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
				   AND FullName = @FullName
				   AND VoteNo = @VoteNo
				   AND PartyName = @PartyName
			)
		   )
		BEGIN
			INSERT INTO MPD2562VoteSummary
			(
				  ProvinceName
				, PollingUnitNo
				, FullName
				, VoteNo 
				, PartyName
				, VoteCount
				, RevoteNo
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @FullName
				, @VoteNo
				, @PartyName
				, @VoteCount
				, @RevoteNo
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562VoteSummary
			   SET VoteCount = @VoteCount
				 , RevoteNo = @RevoteNo
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
			   AND FullName = @FullName
			   AND VoteNo = @VoteNo
			   AND PartyName = @PartyName
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPD2562VoteSummary]    Script Date: 9/30/2022 6:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2562VoteSummary
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SaveMPD2562VoteSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @FullName nvarchar(200)
, @VoteNo int
, @PartyName nvarchar(200)
, @VoteCount int = 0
, @RevoteNo int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL 
		 OR @FullName IS NULL 
		 OR @VoteNo IS NULL
		 OR @PartyName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END
		IF (@VoteCount IS NULL) SET @VoteCount = 0;
		IF (@RevoteNo IS NULL) SET @RevoteNo = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562VoteSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
				   AND FullName = @FullName
				   AND VoteNo = @VoteNo
				   AND PartyName = @PartyName
			)
		   )
		BEGIN
			INSERT INTO MPD2562VoteSummary
			(
				  ProvinceName
				, PollingUnitNo
				, FullName
				, VoteNo 
				, PartyName
				, VoteCount
				, RevoteNo
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @FullName
				, @VoteNo
				, @PartyName
				, @VoteCount
				, @RevoteNo
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562VoteSummary
			   SET VoteCount = @VoteCount
				 , RevoteNo = @RevoteNo
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
			   AND FullName = @FullName
			   AND VoteNo = @VoteNo
			   AND PartyName = @PartyName
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562VoteSummaries]    Script Date: 9/30/2022 6:59:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562VoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562VoteSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    ;WITH MPD2562VoteSum62
    AS
    -- Define the Vote Summary by Province and PollingUnit query.
    (
        SELECT ROW_NUMBER() OVER(ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC) AS RowNo
                , * 
          FROM MPD2562VoteSummary
         WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
    )
    SELECT * 
      FROM MPD2562VoteSum62 
     ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC

END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562VoteSummaryByFullName]    Script Date: 9/30/2022 6:59:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562VoteSummaryByFullName
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562VoteSummaryByFullName]
(
  @FullName nvarchar(200) = NULL
)
AS
BEGIN
    ;WITH MPD2562VoteSum62_A
    AS
    (
        SELECT ProvinceName, PollingUnitNo 
          FROM MPD2562VoteSummary 
         WHERE UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ),
    MPD2562VoteSum62_B
    AS
    -- Find the Vote Summary by Province and PollingUnit query.
    (
        SELECT ROW_NUMBER() OVER(ORDER BY A.VoteCount DESC) AS RowNo
                , A.* 
            FROM MPD2562VoteSummary A JOIN MPD2562VoteSum62_A B
            ON (
                    UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(B.ProvinceName)))
                AND A.PollingUnitNo = B.PollingUnitNo
                )
    )
    SELECT * FROM MPD2562VoteSum62_B
        WHERE UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%' 
    ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC

END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetPersonImages]    Script Date: 9/30/2022 7:43:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPersonImages
-- [== History ==]
-- <2022-09-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--DECLARE @pageNum as int = 1
--DECLARE @rowsPerPage as int = 10
--DECLARE @totalRecords as int = 0
--DECLARE @maxPage as int = 0
--
--EXEC GetPersonImages 'กร', @pageNum out, @rowsPerPage out, @totalRecords out, @maxPage out
--SELECT @totalRecords AS TotalPage, @maxPage AS MaxPage
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonImages]
(
  @FullName nvarchar(200) = null
, @pageNum as int = 1 out
, @rowsPerPage as int = 10 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @sFullName nvarchar(200)
	BEGIN TRY
		IF (@FullName IS NULL)
		BEGIN
			SET @sFullName = N''
		END
		ELSE
		BEGIN
			SET @sFullName = UPPER(RTRIM(LTRIM(@FullName)))
		END

		-- calculate total record and maxpages
		SELECT @totalRecords = COUNT(*) 
		  FROM PersonImage
		 WHERE UPPER(RTRIM(LTRIM(FullName))) LIKE '%' + @sFullName + '%'

		SELECT @maxPage = 
			CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
				(@totalRecords / @rowsPerPage) + 1
			ELSE 
				(@totalRecords / @rowsPerPage)
			END;

		WITH SQLPaging AS
		(
			SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY FullName) AS RowNo
			     , FullName
				 , Data
			  FROM PersonImage
			 WHERE UPPER(RTRIM(LTRIM(FullName))) LIKE '%' + @sFullName + '%'
		)
		SELECT * FROM SQLPaging WITH (NOLOCK) 
			WHERE RowNo > ((@pageNum - 1) * @rowsPerPage);

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH

END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPD2562x350UnitSummary]    Script Date: 9/30/2022 8:54:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPD2562x350UnitSummary
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPD2562x350UnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @RightCount int = 0
, @ExerciseCount int = 0
, @InvalidCount int = 0
, @NoVoteCount int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END
		IF (@RightCount IS NULL) SET @RightCount = 0;
		IF (@ExerciseCount IS NULL) SET @ExerciseCount = 0;
		IF (@InvalidCount IS NULL) SET @InvalidCount = 0;
		IF (@NoVoteCount IS NULL) SET @NoVoteCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562x350UnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2562x350UnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, RightCount
				, ExerciseCount 
				, InvalidCount
				, NoVoteCount
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @RightCount
				, @ExerciseCount 
				, @InvalidCount
				, @NoVoteCount
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562x350UnitSummary
			   SET RightCount = @RightCount
				 , ExerciseCount = @ExerciseCount
				 , InvalidCount = @InvalidCount
				 , NoVoteCount = @NoVoteCount
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPD2562x350UnitSummary]    Script Date: 9/30/2022 8:54:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2562x350UnitSummary
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SaveMPD2562x350UnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @RightCount int = 0
, @ExerciseCount int = 0
, @InvalidCount int = 0
, @NoVoteCount int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END
		IF (@RightCount IS NULL) SET @RightCount = 0;
		IF (@ExerciseCount IS NULL) SET @ExerciseCount = 0;
		IF (@InvalidCount IS NULL) SET @InvalidCount = 0;
		IF (@NoVoteCount IS NULL) SET @NoVoteCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562x350UnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2562x350UnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, RightCount
				, ExerciseCount 
				, InvalidCount
				, NoVoteCount
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @RightCount
				, @ExerciseCount 
				, @InvalidCount
				, @NoVoteCount
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562x350UnitSummary
			   SET RightCount = @RightCount
				 , ExerciseCount = @ExerciseCount
				 , InvalidCount = @InvalidCount
				 , NoVoteCount = @NoVoteCount
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPDC2566]    Script Date: 9/30/2022 9:05:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPDC2566
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPDC2566] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @CandidateNo int
, @FullName nvarchar(200)
, @PrevPartyName nvarchar(100) = NULL
, @EducationLevel nvarchar(100) = NULL
, @SubGroup nvarchar(200) = NULL
, @Remark nvarchar(4000) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL 
		 OR @CandidateNo IS NULL
		 OR @FullName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPDC2566
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
				   AND CandidateNo = @CandidateNo
				   AND FullName = @FullName
			)
		   )
		BEGIN
			INSERT INTO MPDC2566
			(
				  ProvinceName
				, PollingUnitNo
				, CandidateNo 
				, FullName
				, PrevPartyName
				, EducationLevel
				, SubGroup
				, [Remark]
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @CandidateNo
				, @FullName
				, @PrevPartyName
				, @EducationLevel
				, @SubGroup
				, @Remark
			);
		END
		ELSE
		BEGIN
			UPDATE MPDC2566
			   SET PrevPartyName = @PrevPartyName
				 , EducationLevel = @EducationLevel
				 , [Remark] = @Remark
				 , SubGroup = @SubGroup
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
			   AND CandidateNo = @CandidateNo
			   AND FullName = @FullName
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPDC2566]    Script Date: 9/30/2022 9:05:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPDC2566
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-07> :
--	- Add SubGroup parameter.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SaveMPDC2566] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @CandidateNo int
, @FullName nvarchar(200)
, @PrevPartyName nvarchar(100) = NULL
, @EducationLevel nvarchar(100) = NULL
, @SubGroup nvarchar(200) = NULL
, @Remark nvarchar(4000) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL 
		 OR @CandidateNo IS NULL
		 OR @FullName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPDC2566
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
				   AND CandidateNo = @CandidateNo
				   AND FullName = @FullName
			)
		   )
		BEGIN
			INSERT INTO MPDC2566
			(
				  ProvinceName
				, PollingUnitNo
				, CandidateNo 
				, FullName
				, PrevPartyName
				, EducationLevel
				, SubGroup
				, [Remark]
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @CandidateNo
				, @FullName
				, @PrevPartyName
				, @EducationLevel
				, @SubGroup
				, @Remark
			);
		END
		ELSE
		BEGIN
			UPDATE MPDC2566
			   SET PrevPartyName = @PrevPartyName
				 , EducationLevel = @EducationLevel
				 , [Remark] = @Remark
				 , SubGroup = @SubGroup
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
			   AND CandidateNo = @CandidateNo
			   AND FullName = @FullName
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
DROP PROCEDURE SaveMProvinceADM1
GO



/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMProvinceADM1]    Script Date: 9/30/2022 9:20:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMProvinceADM1
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC ImportMProvinceADM1 N'กรุงเทพมหานคร', N'Bangkok', N'TH10'
-- =============================================
CREATE PROCEDURE [dbo].[ImportMProvinceADM1] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @ADM1Code nvarchar(20)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceNameTH IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		IF ((@ProvinceNameTH IS NOT NULL) 
		    AND
		    (@ProvinceNameEN IS NOT NULL)
		    AND
		    (@ADM1Code IS NOT NULL)
            AND
            EXISTS 
			(
				SELECT * 
				  FROM MProvince
				 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
			)
		   )
		BEGIN
			UPDATE MProvince
			   SET ProvinceNameEN = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameEN, ProvinceNameEN))))
				 , ADM1Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
				 , AreaM2 = @AreaM2
			 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
DROP PROCEDURE SaveMDistrictADM2
GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMDistrictADM2]    Script Date: 9/30/2022 9:26:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMDistrictADM2
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- ImportMDistrictADM2 N'สกลนคร', N'Sakon Nakhon', N'อากาศอำนวย', N'Akat Amnuai', N'TH4711', 661338974.564
-- =============================================
CREATE PROCEDURE [dbo].[ImportMDistrictADM2] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100)
, @ADM2Code nvarchar(20)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
		    OR @ProvinceNameEN IS NULL 
			OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL
			OR @ADM2Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		IF ((@DistrictNameEN IS NOT NULL)
		    AND 
			(@ADM2Code IS NOT NULL)
		   )
		BEGIN
			UPDATE MM
			   SET MM.DistrictNameEN = UPPER(LTRIM(RTRIM(@DistrictNameEN)))
				 , MM.ADM2Code = UPPER(LTRIM(RTRIM(@ADM2Code)))
				 , MM.AreaM2 = @AreaM2
			  FROM MDistrict MM 
			  JOIN MDistrictView MV ON 
			       (    
					    MM.DistrictId = MV.DistrictId 
				    AND MM.ProvinceId = MV.ProvinceId
				   )
			 WHERE UPPER(LTRIM(RTRIM(MV.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
			   AND UPPER(LTRIM(RTRIM(MV.DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
DROP PROCEDURE SaveMSubdistrictADM3
GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMSubdistrictADM3]    Script Date: 9/30/2022 9:38:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMSubdistrictADM3
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC ImportMSubdistrictADM3 N'ชลบุรี', N'Chon Buri', N'เมืองชลบุรี', N'Mueang Chon Buri', N'อ่างศิลา', N'Ang Sila', N'TH200117', 6568129.19107
-- =============================================
CREATE PROCEDURE [dbo].[ImportMSubdistrictADM3] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100)
, @SubdistrictNameTH nvarchar(100)
, @SubdistrictNameEN nvarchar(100) = NULL
, @ADM3Code nvarchar(20) = NULL
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
		    OR @ProvinceNameEN IS NULL 
			OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL
			OR @SubdistrictNameTH IS NULL 
			OR @SubdistrictNameEN IS NULL
			OR @ADM3Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END

		IF ((@SubdistrictNameEN IS NOT NULL)
			AND
			(@ADM3Code IS NOT NULL)
		   )
		BEGIN
			UPDATE MM
			   SET SubdistrictNameEN = UPPER(LTRIM(RTRIM(@SubdistrictNameEN)))
				 , ADM3Code = UPPER(LTRIM(RTRIM(@ADM3Code)))
				 , AreaM2 = @AreaM2
		     FROM MSubdistrict MM
			 JOIN MSubdistrictView MV ON
				  (
					    MM.DistrictId = MV.DistrictId 
				    AND MM.ProvinceId = MV.ProvinceId
					AND MM.SubdistrictId = MV.SubdistrictId
				  )
			 WHERE UPPER(LTRIM(RTRIM(MV.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
			   AND UPPER(LTRIM(RTRIM(MV.DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))
			   AND UPPER(LTRIM(RTRIM(MV.SubdistrictNameTH))) = UPPER(LTRIM(RTRIM(@SubdistrictNameTH)))
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562TopVoteSummaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562TopVoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562TopVoteSummaries]
(
  @ProvinceId nvarchar(10)
, @PollingUnitNo int
, @Top int = 6
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    ;WITH PartyImg AS
    (
        SELECT P.PartyId
             , P.PartyName
             , C.Data AS LogoData
          FROM MParty P
             , MContent C
         WHERE P.ContentId = C.ContentId
    )
    , PersonImg AS
    (
        SELECT P.FullName
             , P.Data AS PersonImageData
          FROM PersonImage P
    )
    , ProvinceA AS
    (
        SELECT ProvinceId
             , ProvinceNameTH
          FROM MProvince
    )
    , Top6VoteSum62 AS
    (
        SELECT D.ProvinceId
             , D.ProvinceNameTH
             , A.PollingUnitNo
             , A.FullName
             , A.PartyName
             , B.PartyId
             , B.LogoData
             , C.PersonImageData
             , A.VoteNo
             , A.VoteCount
          FROM MPD2562VoteSummary A
             , PartyImg B
             , PersonImg C
             , ProvinceA D
         WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(D.ProvinceNameTH)))
           AND UPPER(LTRIM(RTRIM(B.PartyName))) = UPPER(LTRIM(RTRIM(A.PartyName)))
           AND (
                    C.FullName = A.FullName
                 OR UPPER(LTRIM(RTRIM(C.FullName))) LIKE ''%'' + UPPER(LTRIM(RTRIM(A.FullName)))
                 OR UPPER(LTRIM(RTRIM(A.FullName))) LIKE ''%'' + UPPER(LTRIM(RTRIM(C.FullName)))
               )
    )
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' *
            FROM Top6VoteSum62
            WHERE ProvinceId = N''' + @ProvinceId + '''
            AND PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
            ORDER BY VoteCount DESC
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562TotalVotes]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562TotalVotes
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562TotalVotes]
(
  @ProvinceId nvarchar(10)
, @PollingUnitNo int
, @Top int = 6
)
AS
BEGIN
    SELECT SUM(A.VoteCount) AS TotalVotes
      FROM MPD2562VoteSummary A
         , MProvince B 
     WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(B.ProvinceNameTH)))
       AND B.ProvinceId = @ProvinceId
       AND A.PollingUnitNo = @PollingUnitNo
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562x350UnitSummaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562x350UnitSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562x350UnitSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
      FROM MPD2562x350UnitSummary
     WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
     ORDER BY ProvinceName, PollingUnitNo
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562x350UnitSummary]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562x350UnitSummary
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562x350UnitSummary]
(
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
)
AS
BEGIN
    SELECT A.ProvinceName
         , A.PollingUnitNo 
         , A.RightCount
         , A.ExerciseCount
         , A.InvalidCount 
         , A.NoVoteCount 
         , B.PollingUnitCount
      FROM MPD2562x350UnitSummary A, MPD2562PollingUnitSummary B
     WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(B.ProvinceName)))
       AND B.PollingUnitNo = A.PollingUnitNo
       AND UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(@ProvinceName)))
       AND A.PollingUnitNo = @PollingUnitNo
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562x350UnitFullSummaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562x350UnitFullSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPD2562x350UnitFullSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
      FROM MPD2562x350UnitSummaryView
     WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
     ORDER BY ProvinceName, PollingUnitNo
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDC2566s]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566s
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDC2566s]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    SELECT *
      FROM MPDC2566
     WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
     ORDER BY ProvinceName, PollingUnitNo
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDC2566Summaries]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566Summaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDC2566Summaries]
(
  @ProvinceId nvarchar(10)
, @PollingUnitNo int
, @Top int = 4
)
AS
BEGIN
DECLARE @sqlCommand as nvarchar(MAX);
    SET @sqlCommand = N'
    SELECT TOP ' + CONVERT(nvarchar, @Top) + ' 
           B.ProvinceId
         , B.ProvinceNameTH AS ProvinceName
         , A.PollingUnitNo
         , A.FullName
         , IMG.Data AS PersonImageData
         , C.PartyId
         , A.PrevPartyName
         , C.Data AS LogoData
         , A.CandidateNo
         , A.EducationLevel
         , A.SubGroup
         , A.Remark
      FROM MPDC2566 A
           LEFT OUTER JOIN (SELECT P.PartyId
                                  , P.PartyName  
                                  , CT.Data
                              FROM MParty P LEFT OUTER JOIN MContent CT 
                                ON P.ContentId = CT.ContentId) C 
                        ON 
                        (
                            UPPER(LTRIM(RTRIM(A.PrevPartyName))) = UPPER(LTRIM(RTRIM(C.PartyName)))
                        )
            LEFT OUTER JOIN PersonImage IMG 
                        ON 
                        (   
                               (IMG.FullName = A.FullName)
                            OR (IMG.FullName LIKE ''%'' + A.FullName + ''%'')
                            OR (A.FullName LIKE ''%'' + IMG.FullName + ''%'')
                        )
          , MProvince B 
    WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(B.ProvinceNameTH)))
      AND B.ProvinceId = N''' + @ProvinceId + '''
      AND A.PollingUnitNo = ' + CONVERT(nvarchar, @PollingUnitNo) + '
    ORDER BY A.CandidateNo
    ';
    EXECUTE dbo.sp_executesql @sqlCommand
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetRegionMenuItems]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetRegionMenuItems
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetRegionMenuItems]
AS
BEGIN
    SELECT RegionId, RegionName
      FROM MRegion 
     ORDER BY RegionId
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetProvinceMenuItems]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetProvinceMenuItems
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetProvinceMenuItems]
(
  @RegionId nvarchar(10)
)
AS
BEGIN
    SELECT A.RegionId
         , A.ProvinceId
         , A.ProvinceNameTH
         , COUNT(A.PollingUnitNo) AS UnitCount
      FROM MPDPollingUnitSummary A 
     WHERE A.RegionId = @RegionId
       AND A.RegionId IS NOT NULL
     GROUP BY A.RegionId
            , A.ProvinceId
            , A.ProvinceNameTH
     ORDER BY A.RegionId
            , A.ProvinceNameTH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetPollingUnitMenuItems]    Script Date: 9/29/2022 8:54:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPollingUnitMenuItems
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPollingUnitMenuItems]
(
  @RegionId nvarchar(10)
, @ProvinceId nvarchar(10)
)
AS
BEGIN
    SELECT *
      FROM MPDPollingUnitSummary
     WHERE RegionId = @RegionId
       AND ProvinceId = @ProvinceId
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[ImportMPD2562PollingUnitAreaRemark]    Script Date: 10/1/2022 10:20:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPD2562PollingUnitAreaRemark
-- [== History ==]
-- <2022-09-12> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[ImportMPD2562PollingUnitAreaRemark] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @AreaRemark nvarchar(4000) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter(s)  is null';
			RETURN
		END
		IF (dbo.IsNullOrEmpty(@AreaRemark) = 1) SET @AreaRemark = NULL;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562PollingUnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2562PollingUnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, AreaRemark
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @AreaRemark
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562PollingUnitSummary
			   SET AreaRemark = @AreaRemark
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		END
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[DeletePersonImage]    Script Date: 10/1/2022 10:20:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeletePersonImage
-- [== History ==]
-- <2022-09-12> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[DeletePersonImage] (
  @FullName nvarchar(200)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
        IF (@FullName IS NULL)
        BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
        END
        DELETE 
          FROM PersonImage
         WHERE UPPER(LTRIM(RTRIM(FullName))) = UPPER(LTRIM(RTRIM(@FullName)))
		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
--
/****** Object:  StoredProcedure [dbo].[DeleteMParty]    Script Date: 10/1/2022 10:20:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeleteMParty
-- [== History ==]
-- <2022-09-12> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMParty] (
  @partyName nvarchar(100)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @PartyId int
DECLARE @ContentId uniqueidentifier
	BEGIN TRY
        IF (@partyName IS NULL)
        BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
        END

        SELECT @PartyId = PartyId 
             , @ContentId = ContentId 
          FROM MParty
         WHERE UPPER(LTRIM(RTRIM(PartyName))) = UPPER(LTRIM(RTRIM(@partyName)))

        IF (@PartyId IS NOT NULL)
        BEGIN
            DELETE 
              FROM MParty
             WHERE PartyId = @PartyId
        END

        IF (@ContentId IS NOT NULL)
        BEGIN
            DELETE 
              FROM MContent
             WHERE ContentId = @ContentId
        END

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-09-29  ***********/
/****** Object:  StoredProcedure [dbo].[GetMParties]    Script Date: 9/30/2022 7:43:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMParties
-- [== History ==]
-- <2022-09-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--DECLARE @pageNum as int = 1
--DECLARE @rowsPerPage as int = 10
--DECLARE @totalRecords as int = 0
--DECLARE @maxPage as int = 0
--
--EXEC GetMParties 'กร', @pageNum out, @rowsPerPage out, @totalRecords out, @maxPage out
--SELECT @totalRecords AS TotalPage, @maxPage AS MaxPage
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMParties]
(
  @PartyName nvarchar(100) = null
, @pageNum as int = 1 out
, @rowsPerPage as int = 10 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @sPartyName nvarchar(100)
	BEGIN TRY
		IF (@PartyName IS NULL)
		BEGIN
			SET @sPartyName = N''
		END
		ELSE
		BEGIN
			SET @sPartyName = UPPER(RTRIM(LTRIM(@PartyName)))
		END

		-- calculate total record and maxpages
		SELECT @totalRecords = COUNT(*) 
		  FROM MParty
		 WHERE UPPER(RTRIM(LTRIM(PartyName))) LIKE '%' + @sPartyName + '%'

		SELECT @maxPage = 
			CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
				(@totalRecords / @rowsPerPage) + 1
			ELSE 
				(@totalRecords / @rowsPerPage)
			END;

		WITH SQLPaging AS
		(
			SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY A.PartyName) AS RowNo
			     , A.PartyName
				 , B.Data
			  FROM MParty A, MContent B
			 WHERE A.ContentId = B.ContentId
               AND UPPER(RTRIM(LTRIM(A.PartyName))) LIKE '%' + @sPartyName + '%'
			 ORDER BY A.PartyName
		)
		SELECT * FROM SQLPaging WITH (NOLOCK) 
			WHERE RowNo > ((@pageNum - 1) * @rowsPerPage);

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH

END

GO

