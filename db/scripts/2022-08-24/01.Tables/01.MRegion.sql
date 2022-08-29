/****** Object:  Table [dbo].[MRegion]    Script Date: 8/29/2022 10:05:54 PM ******/
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
/****** Object:  Index [IX_GeoGroup]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_GeoGroup] ON [dbo].[MRegion]
(
	[GeoGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_GeoSubGroup]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_GeoSubGroup] ON [dbo].[MRegion]
(
	[GeoSubGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_RegionName]    Script Date: 8/29/2022 10:05:54 PM ******/
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
