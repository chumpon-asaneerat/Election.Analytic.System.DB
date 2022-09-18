/*********** Script Update Date: 2022-09-13  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MPD2566PollingUnitSummary](
	[ProvinceName] [nvarchar](100) NOT NULL,
	[PollingUnitNo] [int] NOT NULL,
	[PollingUnitCount] [int] NOT NULL,
	[AreaRemark] [nvarchar](1000) NULL,
 CONSTRAINT [PK_MPD2566PollingUnitSummary] PRIMARY KEY CLUSTERED 
(
	[ProvinceName] ASC,
	[PollingUnitNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MPD2566PollingUnitSummary] ADD  CONSTRAINT [DF_MPD2566PollingUnitSummary_PollingUnitCount]  DEFAULT ((0)) FOR [PollingUnitCount]
GO


/*********** Script Update Date: 2022-09-13  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[_MPDPollingUnitSummary]
AS
	SELECT ThaiYear = 2562, A.* 
	  FROM MPD2562PollingUnitSummary A
	UNION
	SELECT ThaiYear = 2566, B.* 
	  FROM MPD2566PollingUnitSummary B
	 WHERE NOT EXISTS (
					  SELECT C.* 
						FROM MPD2562PollingUnitSummary C 
					   WHERE C.ProvinceName = B.ProvinceName
						 AND C.PollingUnitNo = B.PollingUnitNo
					 )

GO


/*********** Script Update Date: 2022-09-13  ***********/
/****** Object:  View [dbo].[MPDPollingUnitSummary]    Script Date: 9/17/2022 7:16:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPDPollingUnitSummary]
AS
	SELECT   A.ThaiYear
	       , A.ProvinceName
	       , A.PollingUnitNo
		   , A.PollingUnitCount
		   , A.AreaRemark
		   , B.ProvinceNameTH
		   , B.ProvinceId
		   , B.RegionId
		   , B.RegionName
	  FROM _MPDPollingUnitSummary A 
	       LEFT OUTER JOIN MProvinceView B 
		        ON UPPER(LTRIM(RTRIM(B.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(A.ProvinceName)))

GO


/*********** Script Update Date: 2022-09-13  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPD2566PollingUnitSummary]    Script Date: 9/17/2022 3:43:51 PM ******/
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
CREATE PROCEDURE [dbo].[SaveMPD2566PollingUnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
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
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @PollingUnitCount
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2566PollingUnitSummary
			   SET PollingUnitCount = @PollingUnitCount
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

