/*********** Script Update Date: 2022-08-17  ***********/
/****** Object:  Table [dbo].[MRegion]    Script Date: 8/17/2022 1:31:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MRegion](
	[RegionId] [nvarchar](10) NOT NULL,
	[RegionName] [nvarchar](100) NOT NULL,
	[GeoGroup] [nvarchar](100) NOT NULL,
	[GeoSubGroup] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[RegionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_GeoGroup]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_GeoGroup] ON [dbo].[MRegion]
(
	[GeoGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_GeoSubGroup]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_GeoSubGroup] ON [dbo].[MRegion]
(
	[GeoSubGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_RegionName]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_RegionName] ON [dbo].[MRegion]
(
	[RegionName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Region Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MRegion', @level2type=N'COLUMN',@level2name=N'RegionId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Region Name.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MRegion', @level2type=N'COLUMN',@level2name=N'RegionName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Geo location Group (main) like north/northeast/east/south/west' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MRegion', @level2type=N'COLUMN',@level2name=N'GeoGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Geo location Subgroup like North (upper area), North (lower area)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MRegion', @level2type=N'COLUMN',@level2name=N'GeoSubGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MRegion', @level2type=N'INDEX',@level2name=N'IX_RegionName'
GO


/*********** Script Update Date: 2022-08-17  ***********/
/****** Object:  Table [dbo].[MProvince]    Script Date: 8/17/2022 1:31:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MProvince](
	[ProvinceId] [nvarchar](10) NOT NULL,
	[ProvinceNameEN] [nvarchar](100) NULL,
	[ProvinceNameTH] [nvarchar](100) NOT NULL,
	[ADM1Code] [nvarchar](20) NULL,
 CONSTRAINT [PK_Province] PRIMARY KEY CLUSTERED 
(
	[ProvinceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ADM1PCode]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_ADM1PCode] ON [dbo].[MProvince]
(
	[ADM1Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProvinceNameEN]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProvinceNameEN] ON [dbo].[MProvince]
(
	[ProvinceNameEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProvinceNameTH]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProvinceNameTH] ON [dbo].[MProvince]
(
	[ProvinceNameTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The shape file reference for Admin level 1 code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MProvince', @level2type=N'COLUMN',@level2name=N'ADM1Code'
GO


/*********** Script Update Date: 2022-08-17  ***********/
/****** Object:  Table [dbo].[MDistrict]    Script Date: 8/17/2022 1:31:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MDistrict](
	[DistrictId] [nvarchar](10) NOT NULL,
	[DistrictNameEN] [nvarchar](100) NULL,
	[DistrictNameTH] [nvarchar](100) NOT NULL,
	[ADM2Code] [nvarchar](20) NULL,
 CONSTRAINT [PK_MDistrict] PRIMARY KEY CLUSTERED 
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ADM2Code]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_ADM2Code] ON [dbo].[MDistrict]
(
	[ADM2Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DistrictNameEN]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictNameEN] ON [dbo].[MDistrict]
(
	[DistrictNameEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DistrictNameTH]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictNameTH] ON [dbo].[MDistrict]
(
	[DistrictNameTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/*********** Script Update Date: 2022-08-17  ***********/
/****** Object:  Table [dbo].[MSubdistrict]    Script Date: 8/17/2022 1:31:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MSubdistrict](
	[SubdistrictId] [nvarchar](10) NOT NULL,
	[SubdistrictNameEN] [nvarchar](100) NULL,
	[SubdistrictNameTH] [nvarchar](100) NULL,
	[ADM3Code] [nvarchar](20) NULL,
 CONSTRAINT [PK_MSubdistrict] PRIMARY KEY CLUSTERED 
(
	[SubdistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ADM3Code]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_ADM3Code] ON [dbo].[MSubdistrict]
(
	[ADM3Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_SubdistrictNameEN]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_SubdistrictNameEN] ON [dbo].[MSubdistrict]
(
	[SubdistrictNameEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_SubdistrictNameTH]    Script Date: 8/17/2022 1:31:24 AM ******/
CREATE NONCLUSTERED INDEX [IX_SubdistrictNameTH] ON [dbo].[MSubdistrict]
(
	[SubdistrictNameTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/*********** Script Update Date: 2022-08-17  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMRegion
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveMRegion N'01', N'ภาค 1', N'กลาง', N'กลาง';
--exec SaveMRegion N'02', N'ภาค 2', N'ตะวันออก', N'ตะวันออก';
--exec SaveMRegion N'03', N'ภาค 3', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนล่าง';
--exec SaveMRegion N'04', N'ภาค 4', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนบน';
--exec SaveMRegion N'05', N'ภาค 5', N'เหนือ', N'เหนือตอนบน';
--exec SaveMRegion N'06', N'ภาค 6', N'เหนือ', N'เหนือตอนล่าง';
--exec SaveMRegion N'07', N'ภาค 7', N'ตะวันตก', N'ตะวันตก';
--exec SaveMRegion N'08', N'ภาค 8', N'ใต้', N'ใต้ตอนบน';
--exec SaveMRegion N'09', N'ภาค 9', N'ใต้', N'ใต้ตอนล่าง';
--exec SaveMRegion N'10', N'ภาค 10', N'กลาง', N'กรุงเทพมหานคร';
-- =============================================
CREATE PROCEDURE SaveMRegion (
  @RegionId nvarchar(10)
, @RegionName nvarchar(100)
, @GeoGroup nvarchar(100)
, @GeoSubGroup nvarchar(100)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
BEGIN TRY
	IF NOT EXISTS 
	(
		SELECT * 
		  FROM MRegion
		 WHERE RegionId = @RegionId
	)
	BEGIN
		INSERT INTO MRegion
		(
			  RegionId
			, RegionName 
			, GeoGroup
			, GeoSubGroup
		)
		VALUES
		(
			  @RegionId
			, @RegionName
			, @GeoGroup
			, @GeoSubGroup
		);
	END
	ELSE
	BEGIN
		UPDATE MRegion
		   SET RegionName = @RegionName
		     , GeoGroup = @GeoGroup
		     , GeoSubGroup = @GeoSubGroup
		 WHERE RegionId = @RegionId
	END

		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-08-17  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMRegions
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMRegions NULL, NULL, NULL, NULL      -- Gets all
-- EXEC GetMRegions NULL, N'1', NULL, NULL      -- Search all that RegionName contains '1'
-- EXEC GetMRegions NULL, NULL, N'เหนือ', NULL   -- Search all that GeoGroup contains 'เหนือ'
-- EXEC GetMRegions NULL, NULL, NULL, N'ตอนบน'  -- Search all that GeoSubGroup contains 'ตอนบน'
-- =============================================
CREATE PROCEDURE GetMRegions
(
  @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
	  FROM MRegion
	 WHERE UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY RegionId
END

GO


/*********** Script Update Date: 2022-08-17  ***********/
EXEC SaveMRegion N'01', N'ภาค 1', N'กลาง', N'กลาง';
EXEC SaveMRegion N'02', N'ภาค 2', N'ตะวันออก', N'ตะวันออก';
EXEC SaveMRegion N'03', N'ภาค 3', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนล่าง';
EXEC SaveMRegion N'04', N'ภาค 4', N'ตะวันออกเฉียงเหนือ', N'ตะวันออกเฉียงเหนือตอนบน';
EXEC SaveMRegion N'05', N'ภาค 5', N'เหนือ', N'เหนือตอนบน';
EXEC SaveMRegion N'06', N'ภาค 6', N'เหนือ', N'เหนือตอนล่าง';
EXEC SaveMRegion N'07', N'ภาค 7', N'ตะวันตก', N'ตะวันตก';
EXEC SaveMRegion N'08', N'ภาค 8', N'ใต้', N'ใต้ตอนบน';
EXEC SaveMRegion N'09', N'ภาค 9', N'ใต้', N'ใต้ตอนล่าง';
EXEC SaveMRegion N'10', N'ภาค 10', N'กลาง', N'กรุงเทพมหานคร';

