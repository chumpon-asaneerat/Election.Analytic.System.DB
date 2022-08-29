/****** Object:  Table [dbo].[MProvince]    Script Date: 8/29/2022 10:05:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MProvince](
	[ProvinceId] [nvarchar](10) NOT NULL,
	[RegionId] [nvarchar](10) NOT NULL,
	[ProvinceNameEN] [nvarchar](100) NULL,
	[ProvinceNameTH] [nvarchar](100) NOT NULL,
	[ADM1Code] [nvarchar](20) NULL,
 CONSTRAINT [PK_MProvince] PRIMARY KEY CLUSTERED 
(
	[ProvinceId] ASC,
	[RegionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ADM1PCode]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_ADM1PCode] ON [dbo].[MProvince]
(
	[ADM1Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProvinceNameEN]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProvinceNameEN] ON [dbo].[MProvince]
(
	[ProvinceNameEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProvinceNameTH]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProvinceNameTH] ON [dbo].[MProvince]
(
	[ProvinceNameTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MProvince]  WITH CHECK ADD  CONSTRAINT [FK_MProvince_MRegion] FOREIGN KEY([RegionId])
REFERENCES [dbo].[MRegion] ([RegionId])
GO
ALTER TABLE [dbo].[MProvince] CHECK CONSTRAINT [FK_MProvince_MRegion]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The shape file reference for Admin level 1 code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MProvince', @level2type=N'COLUMN',@level2name=N'ADM1Code'
GO
