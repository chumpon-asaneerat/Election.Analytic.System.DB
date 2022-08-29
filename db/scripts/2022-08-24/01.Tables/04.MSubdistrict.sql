/****** Object:  Table [dbo].[MSubdistrict]    Script Date: 8/29/2022 10:05:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MSubdistrict](
	[SubdistrictId] [nvarchar](10) NOT NULL,
	[RegionId] [nvarchar](10) NOT NULL,
	[ProvinceId] [nvarchar](10) NOT NULL,
	[DistrictId] [nvarchar](10) NOT NULL,
	[SubdistrictNameEN] [nvarchar](100) NULL,
	[SubdistrictNameTH] [nvarchar](100) NULL,
	[ADM3Code] [nvarchar](20) NULL,
 CONSTRAINT [PK_MSubdistrict_1] PRIMARY KEY CLUSTERED 
(
	[SubdistrictId] ASC,
	[RegionId] ASC,
	[ProvinceId] ASC,
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ADM3Code]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_ADM3Code] ON [dbo].[MSubdistrict]
(
	[ADM3Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_SubdistrictNameEN]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_SubdistrictNameEN] ON [dbo].[MSubdistrict]
(
	[SubdistrictNameEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_SubdistrictNameTH]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_SubdistrictNameTH] ON [dbo].[MSubdistrict]
(
	[SubdistrictNameTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MSubdistrict]  WITH CHECK ADD  CONSTRAINT [FK_MSubdistrict_MDistrict] FOREIGN KEY([DistrictId], [RegionId], [ProvinceId])
REFERENCES [dbo].[MDistrict] ([DistrictId], [RegionId], [ProvinceId])
GO
ALTER TABLE [dbo].[MSubdistrict] CHECK CONSTRAINT [FK_MSubdistrict_MDistrict]
GO
