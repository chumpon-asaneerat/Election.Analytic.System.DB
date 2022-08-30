/*********** Script Update Date: 2022-08-24  ***********/
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


/*********** Script Update Date: 2022-08-24  ***********/
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MDistrict]    Script Date: 8/29/2022 10:05:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MDistrict](
	[DistrictId] [nvarchar](10) NOT NULL,
	[RegionId] [nvarchar](10) NOT NULL,
	[ProvinceId] [nvarchar](10) NOT NULL,
	[DistrictNameEN] [nvarchar](100) NULL,
	[DistrictNameTH] [nvarchar](100) NOT NULL,
	[ADM2Code] [nvarchar](20) NULL,
 CONSTRAINT [PK_MDistrict_1] PRIMARY KEY CLUSTERED 
(
	[DistrictId] ASC,
	[RegionId] ASC,
	[ProvinceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ADM2Code]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_ADM2Code] ON [dbo].[MDistrict]
(
	[ADM2Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DistrictNameEN]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictNameEN] ON [dbo].[MDistrict]
(
	[DistrictNameEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DistrictNameTH]    Script Date: 8/29/2022 10:05:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictNameTH] ON [dbo].[MDistrict]
(
	[DistrictNameTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MDistrict]  WITH CHECK ADD  CONSTRAINT [FK_MDistrict_MProvince] FOREIGN KEY([ProvinceId], [RegionId])
REFERENCES [dbo].[MProvince] ([ProvinceId], [RegionId])
GO
ALTER TABLE [dbo].[MDistrict] CHECK CONSTRAINT [FK_MDistrict_MProvince]
GO


/*********** Script Update Date: 2022-08-24  ***********/
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MFileType]    Script Date: 8/18/2022 1:12:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MFileType](
	[FileTypeId] [int] NOT NULL,
	[Description] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_MFileType] PRIMARY KEY CLUSTERED 
(
	[FileTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MFileSubType]    Script Date: 8/18/2022 1:12:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MFileSubType](
	[FileTypeId] [int] NOT NULL,
	[FileSubTypeId] [int] NOT NULL,
	[Description] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_MFileSubType] PRIMARY KEY CLUSTERED 
(
	[FileTypeId] ASC,
	[FileSubTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MFileSubType]  WITH CHECK ADD  CONSTRAINT [FK_MFileSubType_MFileType] FOREIGN KEY([FileTypeId])
REFERENCES [dbo].[MFileType] ([FileTypeId])
GO

ALTER TABLE [dbo].[MFileSubType] CHECK CONSTRAINT [FK_MFileSubType_MFileType]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MGender]    Script Date: 8/18/2022 1:52:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MGender](
	[GenderId] [int] NOT NULL,
	[Description] [nvarchar](20) NULL,
 CONSTRAINT [PK_MGender] PRIMARY KEY CLUSTERED 
(
	[GenderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MTitle]    Script Date: 8/18/2022 1:52:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MTitle](
	[TitleId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[ShortName] [nvarchar](50) NULL,
	[GenderId] [int] NULL,
 CONSTRAINT [PK_MTitle] PRIMARY KEY CLUSTERED 
(
	[TitleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MTitle_Description]    Script Date: 8/18/2022 1:52:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MTitle_Description] ON [dbo].[MTitle]
(
	[Description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MTitle_ShortName]    Script Date: 8/18/2022 1:52:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MTitle_ShortName] ON [dbo].[MTitle]
(
	[ShortName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MAge]    Script Date: 8/18/2022 1:52:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAge](
	[AgeId] [int] NOT NULL,
	[AgeMin] [int] NOT NULL,
	[AgeMax] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[Active] [int] NOT NULL,
 CONSTRAINT [PK_MAge] PRIMARY KEY CLUSTERED 
(
	[AgeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[MAge] ADD  CONSTRAINT [DF_MAge_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[MAge] ADD  CONSTRAINT [DF_MAge_Active]  DEFAULT ((1)) FOR [Active]
GO

SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MAge_Description]    Script Date: 8/18/2022 1:52:48 AM ******/
CREATE NONCLUSTERED INDEX [IX_MAge_Description] ON [dbo].[MAge]
(
	[Description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MOccupation]    Script Date: 8/18/2022 1:52:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MOccupation](
	[OccupationId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[Active] [int] NOT NULL,
 CONSTRAINT [PK_MOccupation] PRIMARY KEY CLUSTERED 
(
	[OccupationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MOccupation] ADD  CONSTRAINT [DF_MOccupation_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[MOccupation] ADD  CONSTRAINT [DF_MOccupation_Active]  DEFAULT ((1)) FOR [Active]
GO

SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MOccupation_Description]    Script Date: 8/18/2022 1:52:48 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MOccupation_Description] ON [dbo].[MOccupation]
(
	[Description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MEducation]    Script Date: 8/18/2022 2:15:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MEducation](
	[EducationId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[Active] [int] NOT NULL,
 CONSTRAINT [PK_MEducation] PRIMARY KEY CLUSTERED 
(
	[EducationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MEducation] ADD  CONSTRAINT [DF_MEducation_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[MEducation] ADD  CONSTRAINT [DF_MEducation_Active]  DEFAULT ((1)) FOR [Active]
GO


SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MEducation_Description]    Script Date: 8/18/2022 2:15:49 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MEducation_Description] ON [dbo].[MEducation]
(
	[Description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[UserRole]    Script Date: 8/22/2022 6:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserRole](
	[RoleId] [int] NOT NULL,
	[RoleName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserRole_RoleName]    Script Date: 8/22/2022 6:09:02 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserRole_RoleName] ON [dbo].[UserRole]
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[UserInfo]    Script Date: 8/22/2022 6:09:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserInfo](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Active] [int] NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_UserInfo] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [IX_UserInfo]    Script Date: 8/22/2022 6:09:02 AM ******/
CREATE NONCLUSTERED INDEX [IX_UserInfo] ON [dbo].[UserInfo]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserInfo_FullName]    Script Date: 8/22/2022 6:09:02 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserInfo_FullName] ON [dbo].[UserInfo]
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_UserInfo_UserName]    Script Date: 8/22/2022 6:09:02 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserInfo_UserName] ON [dbo].[UserInfo]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserInfo] ADD  CONSTRAINT [DF_UserInfo_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UserInfo] ADD  CONSTRAINT [DF_UserInfo_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO
ALTER TABLE [dbo].[UserInfo]  WITH CHECK ADD  CONSTRAINT [FK_UserInfo_UserRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[UserRole] ([RoleId])
GO
ALTER TABLE [dbo].[UserInfo] CHECK CONSTRAINT [FK_UserInfo_UserRole]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MVoteDate]    Script Date: 8/22/2022 9:04:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MVoteDate](
	[Year] [int] NOT NULL,
	[Seq] [int] NOT NULL,
	[ReNo] [int] NOT NULL,
	[VoteDate] [datetime] NOT NULL,
	[Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_MVoteDate] PRIMARY KEY CLUSTERED 
(
	[Year] ASC,
	[Seq] ASC,
	[ReNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[MVoteDate] ADD  CONSTRAINT [DF_MVoteDate_Seq]  DEFAULT ((1)) FOR [Seq]
GO
ALTER TABLE [dbo].[MVoteDate] ADD  CONSTRAINT [DF_MVoteDate_ReNo]  DEFAULT ((0)) FOR [ReNo]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Year of Election' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVoteDate', @level2type=N'COLUMN',@level2name=N'Year'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vote Sequence No. in same year' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVoteDate', @level2type=N'COLUMN',@level2name=N'Seq'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Re-Election Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVoteDate', @level2type=N'COLUMN',@level2name=N'ReNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date ot Election' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MVoteDate', @level2type=N'COLUMN',@level2name=N'VoteDate'
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MParty]    Script Date: 8/29/2022 1:52:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MParty](
	[PartyId] [int] IDENTITY(1,1) NOT NULL,
	[PartyName] [nvarchar](100) NOT NULL,
	[ContentId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_MParty] PRIMARY KEY CLUSTERED 
(
	[PartyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MParty_PartyName]    Script Date: 8/29/2022 1:52:32 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MParty_PartyName] ON [dbo].[MParty]
(
	[PartyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MPerson]    Script Date: 8/29/2022 3:04:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MPerson](
	[PersonId] [int] NOT NULL,
	[Prefix] [nvarchar](100) NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NULL,
	[DOB] [datetime] NULL,
	[GenderId] [int] NULL,
	[EducationId] [int] NULL,
	[OccupationId] [int] NULL,
	[ContentId] [uniqueidentifier] NULL,
	[Remark] [nvarchar](255) NULL,
 CONSTRAINT [PK_MPerson] PRIMARY KEY CLUSTERED 
(
	[PersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MPerson_FirstName]    Script Date: 8/29/2022 3:04:04 AM ******/
CREATE NONCLUSTERED INDEX [IX_MPerson_FirstName] ON [dbo].[MPerson]
(
	[FirstName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MPerson_LastName]    Script Date: 8/29/2022 3:04:04 AM ******/
CREATE NONCLUSTERED INDEX [IX_MPerson_LastName] ON [dbo].[MPerson]
(
	[LastName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MPerson_Prefix]    Script Date: 8/29/2022 3:04:04 AM ******/
CREATE NONCLUSTERED INDEX [IX_MPerson_Prefix] ON [dbo].[MPerson]
(
	[Prefix] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MPerson] ADD  CONSTRAINT [DF_MPerson_GenderId]  DEFAULT ((0)) FOR [GenderId]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MContent]    Script Date: 8/18/2022 1:52:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MContent](
	[ContentId] [uniqueidentifier] NOT NULL,
	[Data] [varbinary](max) NULL,
	[FileTypeId] [int] NULL,
	[FileSubTypeId] [int] NULL,
	[LastUpdated] [datetime] NULL,
 CONSTRAINT [PK_MContent] PRIMARY KEY CLUSTERED 
(
	[ContentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[MContent] ADD  CONSTRAINT [DF_MContent_ContentId]  DEFAULT (newid()) FOR [ContentId]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[PollingStation]    Script Date: 8/29/2022 9:30:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PollingStation](
	[YearThai] [int] NOT NULL,
	[RegionId] [nvarchar](10) NOT NULL,
	[ProvinceId] [nvarchar](10) NOT NULL,
	[DistrictId] [nvarchar](10) NOT NULL,
	[SubdistrictId] [nvarchar](10) NOT NULL,
	[PollingUnitNo] [int] NOT NULL,
	[PollingSubUnitNo] [int] NULL,
	[VillageCount] [int] NULL,
 CONSTRAINT [PK_PollingStation] PRIMARY KEY CLUSTERED 
(
	[YearThai] ASC,
	[RegionId] ASC,
	[ProvinceId] ASC,
	[DistrictId] ASC,
	[SubdistrictId] ASC,
	[PollingUnitNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/*********** Script Update Date: 2022-08-24  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MPD2562VoteSummary](
	[ProvinceName] [nvarchar](100) NOT NULL,
	[PollingUnitNo] [int] NOT NULL,
	[FullName] [nvarchar](200) NOT NULL,
	[VoteNo] [int] NOT NULL,
	[PartyName] [nvarchar](100) NOT NULL,
	[RevoteNo] [int] NOT NULL,
	[VoteCount] [int] NOT NULL,
 CONSTRAINT [PK_MPDVoteSummary] PRIMARY KEY CLUSTERED 
(
	[ProvinceName] ASC,
	[PollingUnitNo] ASC,
	[FullName] ASC,
	[VoteNo] ASC,
	[PartyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[MPD2562VoteSummary] ADD  CONSTRAINT [DF_MPD2562VoteSummary_RevoteNo]  DEFAULT ((0)) FOR [RevoteNo]
GO
ALTER TABLE [dbo].[MPD2562VoteSummary] ADD  CONSTRAINT [DF_MPDVoteSummary_VoteCount]  DEFAULT ((0)) FOR [VoteCount]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[MPDC2566]    Script Date: 8/30/2022 6:28:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MPDC2566](
	[ProvinceName] [nvarchar](100) NOT NULL,
	[PollingUnitNo] [int] NOT NULL,
	[CandidateNo] [int] NOT NULL,
	[FullName] [nvarchar](200) NOT NULL,
	[PrevPartyName] [nvarchar](100) NULL,
	[EducationLevel] [nvarchar](100) NULL,
	[Remark] [nvarchar](200) NULL,
 CONSTRAINT [PK_MPDC2566] PRIMARY KEY CLUSTERED 
(
	[ProvinceName] ASC,
	[PollingUnitNo] ASC,
	[CandidateNo] ASC,
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MPDC2566] ADD  CONSTRAINT [DF_MPDC2566_CandidateNo]  DEFAULT ((0)) FOR [CandidateNo]
GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  Table [dbo].[PersonImage]    Script Date: 8/30/2022 6:47:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PersonImage](
	[FullName] [nvarchar](200) NOT NULL,
	[Data] [varbinary](max) NULL,
 CONSTRAINT [PK_PersonImage] PRIMARY KEY CLUSTERED 
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  View [dbo].[MTitleView]    Script Date: 8/20/2022 7:40:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MTitleView]
AS
SELECT TitleId
     , [Description]
	 , ShortName
	 , GenderId
	 , LEN([Description]) AS DLen
	 , LEN(ShortName) AS SLen
  FROM MTitle

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  View [dbo].[UserInfoView]    Script Date: 8/20/2022 10:00:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[UserInfoView]
AS
	SELECT A.UserId
	     , A.FullName
	     , A.UserName
	     , A.[Password]
		 , A.Active
         , A.LastUpdated
		 , A.RoleId
		 , B.RoleName
	  FROM UserInfo A
	     , UserRole B
	 WHERE A.RoleId = B.RoleId

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  View [dbo].[MProvinceView]    Script Date: 8/30/2022 12:04:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MProvinceView]
AS
	SELECT A.ProvinceId
	     , A.ProvinceNameTH
	     , A.ProvinceNameEN
	     , A.ADM1Code
	     , B.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
	  FROM MProvince A
	     , MRegion B
	 WHERE A.RegionId = B.RegionId

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  View [dbo].[MDistrictView]    Script Date: 8/29/2022 11:38:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[MDistrictView]
AS
	SELECT A.RegionId
		 , A.ProvinceId
		 , A.DistrictId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ProvinceNameTH
		 , A.DistrictNameTH
		 , C.ProvinceNameEN
		 , A.DistrictNameEN
		 , C.ADM1Code
		 , A.ADM2Code
	  FROM MDistrict A
		 , MRegion B
		 , MProvince C
	 WHERE A.RegionId = B.RegionId
	   AND C.RegionId = B.RegionId
	   AND A.ProvinceId = C.ProvinceId

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  View [dbo].[MSubdistrictView]    Script Date: 8/29/2022 11:38:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[MSubdistrictView]
AS
	SELECT A.RegionId
		 , A.ProvinceId
		 , A.DistrictId
		 , A.SubdistrictId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ProvinceNameTH
		 , D.DistrictNameTH
		 , A.SubdistrictNameTH
		 , C.ProvinceNameEN
		 , D.DistrictNameEN
		 , A.SubdistrictNameEN
		 , C.ADM1Code
		 , D.ADM2Code
		 , A.ADM3Code
	  FROM MSubdistrict A
		 , MRegion B
		 , MProvince C
		 , MDistrict D
	 WHERE A.RegionId = B.RegionId
	   AND C.RegionId = B.RegionId
	   AND D.RegionId = B.RegionId
	   AND A.ProvinceId = C.ProvinceId
	   AND D.ProvinceId = C.ProvinceId
	   AND A.DistrictId = D.DistrictId

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  View [dbo].[MContentView]    Script Date: 8/20/2022 10:00:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MContentView]
AS
	SELECT A.ContentId
	     , A.Data
	     , A.LastUpdated
		 , B.[Description] AS FileTypeName
		 , C.[Description] AS FileSubTypeName
		 , A.FileTypeId
		 , A.FileSubTypeId
	  FROM MContent A
	     , MFileType B
	     , MFileSubType C
	 WHERE C.FileTypeId = B.FileTypeId
	   AND A.FileTypeId = C.FileTypeId
	   AND A.FileSubTypeId = C.FileSubTypeId

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  View [dbo].[PollingStationView]    Script Date: 8/30/2022 12:48:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PollingStationView]
AS
	SELECT A.YearThai
	     , A.RegionId
		 , E.RegionName
		 , E.GeoGroup
		 , E.GeoSubGroup
	     , A.ProvinceId
		 , E.ProvinceNameTH
		 , E.ProvinceNameEN
		 , E.ADM1Code
		 , A.DistrictId
		 , E.DistrictNameTH
		 , E.DistrictNameEN
		 , E.ADM2Code
		 , A.SubdistrictId
		 , E.SubdistrictNameTH
		 , E.SubdistrictNameEN
		 , E.ADM3Code
		 , A.PollingUnitNo
		 , A.PollingSubUnitNo
		 , A.VillageCount
	  FROM PollingStation A
	     , MSubdistrictView E
	 WHERE A.RegionId = E.RegionId
	   AND A.ProvinceId = E.ProvinceId
	   AND A.DistrictId = E.DistrictId
	   AND A.SubdistrictId = E.SubdistrictId

GO


/*********** Script Update Date: 2022-08-24  ***********/
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
		IF ((@RegionId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MRegion
				 WHERE RegionId = @RegionId
			)
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


/*********** Script Update Date: 2022-08-24  ***********/
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMTitle]    Script Date: 8/20/2022 8:48:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMTitle
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveMTitle N'นางสาว1', N'น.ส.1', 2;
-- =============================================
CREATE PROCEDURE [dbo].[SaveMTitle] (
  @Description nvarchar(100)
, @ShortName nvarchar(50)
, @GenderId int = 0
, @TitleId int out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF ((@TitleId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MTitle
				 WHERE TitleId = @TitleId
			)
		   )
		BEGIN
		    -- Get New ID.
		    SELECT @TitleId = (MAX(TitleId) + 1)
			  FROM MTitle;
			-- NEW ID should over than 9000
			IF (@TitleId < 9000) SET @TitleId = 9000

			INSERT INTO MTitle
			(
				  TitleId
				, [Description]
				, ShortName
				, GenderId
			)
			VALUES
			(
				  @TitleId
				, @Description
				, @ShortName
				, @GenderId
			);
		END
		ELSE
		BEGIN
			UPDATE MTitle
			   SET [Description] = @Description
				 , ShortName = @ShortName
				 , GenderId = @GenderId
			 WHERE TitleId = @TitleId
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[GetMTitles]    Script Date: 8/20/2022 7:42:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMTitles
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMTitles NULL, NULL, NULL, NULL      -- Gets all
-- EXEC GetMTitles NULL, N'นาง', NULL, NULL      -- Search all that Description contains 'นาง'
-- EXEC GetMTitles NULL, NULL, N'จ.', NULL   -- Search all that ShortName contains 'จ.'
-- EXEC GetMTitles NULL, NULL, NULL, 1  -- Search all that gender is male (0 - None, 1 - Male, 2 - Female)
-- =============================================
CREATE PROCEDURE [dbo].[GetMTitles]
(
  @TitleId int = NULL
, @description nvarchar(100) = NULL
, @shortName nvarchar(50) = NULL
, @genderId int = NULL
)
AS
BEGIN
	SELECT A.TitleId
	     , A.[Description]
	     , A.ShortName
	     , B.[Description] AS GenderName
	     , A.GenderId
	     , A.DLen
	     , A.SLen
	  FROM MTitleView A, MGender B
	 WHERE A.GenderId = B.GenderId
	   AND A.TitleId = COALESCE(@TitleId, A.TitleId)
	   AND UPPER(LTRIM(RTRIM(A.[Description]))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@description, A.[Description])))) + '%'
	   AND UPPER(LTRIM(RTRIM(A.ShortName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@shortName, A.ShortName)))) + '%'
	   AND A.GenderId = COALESCE(@genderId, A.GenderId)
	 ORDER BY A.DLen DESC
	        , A.SLen DESC
			, A.[Description]
			, A.ShortName
END

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMContent]    Script Date: 8/20/2022 9:55:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMContent
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @contentId uniqueidentifier
-- 
-- DECLARE @jsonData NVARCHAR(MAX) = N'{"age":1,"name":"sample"}'
-- DECLARE @data VARBINARY(MAX) = CONVERT(VARBINARY(MAX), @jsonData)
-- 
-- EXEC SaveMContent @data, 2, 1, @contentId out, @errNum out, @errMsg out
-- 
-- SELECT @contentId AS ContentId, @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT ContentId
--      , Data
--      , CONVERT(NVARCHAR(MAX), Data) AS JsonData
--   FROM MContent
-- 
-- -- CHANGE DATA
-- SET @jsonData = N'{"age":100,"name":"sample 222"}'
-- SET @data = CONVERT(VARBINARY(MAX), @jsonData)
-- EXEC SaveMContent @data, 2, 1, @contentId out, @errNum out, @errMsg out
-- 
-- SELECT @contentId AS ContentId, @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT ContentId
--      , Data
--      , CONVERT(NVARCHAR(MAX), Data) AS JsonData
--   FROM MContent
-- =============================================
CREATE PROCEDURE [dbo].[SaveMContent] (
  @Data varbinary(MAX)
, @FileTypeId int = NULL
, @FileSubTypeId int = NULL
, @ContentId uniqueidentifier out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @LastUpdate datetime
	BEGIN TRY
        -- SET LAST UPDATE DATETIME
	    SET @LastUpdate = GETDATE();
        
		IF ((@ContentId IS NULL)
			OR 
			NOT EXISTS 
			(
				SELECT * 
				  FROM MContent
				 WHERE ContentId = @ContentId 
			)
		   )
		BEGIN
			SET @ContentId = NEWID();
			INSERT INTO MContent
			(
				  ContentId
				, [Data] 
				, FileTypeId
				, FileSubTypeId
				, LastUpdated
			)
			VALUES
			(
				  @ContentId
				, @Data
				, @FileTypeId
				, @FileSubTypeId
				, @LastUpdate
			);
		END
		ELSE
		BEGIN
			UPDATE MContent
			   SET [Data] = @Data
				 , FileTypeId = @FileTypeId
				 , FileSubTypeId = @FileSubTypeId
				 , LastUpdated = @LastUpdate
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[GetMContents]    Script Date: 8/20/2022 9:41:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMContents
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMContents NULL, NULL, NULL      -- Gets all
-- EXEC GetMContents NULL, 1, NULL         -- Gets all images
-- EXEC GetMContents NULL, 1, 2            -- Gets all person images
-- EXEC GetMContents NULL, 1, 2            -- Gets all logo images
-- EXEC GetMContents NULL, 2, NULL         -- Gets all data
-- EXEC GetMContents NULL, 2, 1            -- Gets all json data
-- =============================================
CREATE PROCEDURE [dbo].[GetMContents]
(
  @ContentId uniqueidentifier = NULL
, @FileTypeId int = NULL
, @FileSubTypeId int = NULL
)
AS
BEGIN
	SELECT *
	  FROM MContentView
	 WHERE ContentId = COALESCE(@ContentId, ContentId)
	   AND FileTypeId = COALESCE(@FileTypeId, FileTypeId)
	   AND FileSubTypeId = COALESCE(@FileSubTypeId, FileSubTypeId)
END

GO


/*********** Script Update Date: 2022-08-24  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveUserRole
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveUserRole 10, N'Exclusive';
--exec SaveUserRole 10, N'Supervisor';
--exec SaveUserRole 20, N'Normal User';
--exec SaveUserRole 20, N'User';
-- =============================================
CREATE PROCEDURE SaveUserRole (
  @RoleId int
, @RoleName nvarchar(100)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF ((@RoleId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM UserRole
				 WHERE RoleId = @RoleId
			)
		   )
		BEGIN
			INSERT INTO UserRole
			(
				  RoleId
				, RoleName 
			)
			VALUES
			(
				  @RoleId
				, @RoleName
			);
		END
		ELSE
		BEGIN
			UPDATE UserRole
			   SET RoleName = @RoleName
			 WHERE RoleId = @RoleId
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[GetUserRoles]    Script Date: 8/20/2022 9:41:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUserRoles
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetUserRoles NULL, NULL      -- Gets all
-- EXEC GetUserRoles 1, NULL         -- Get RoleId 1
-- EXEC GetUserRoles NULL, N'adm'    -- Gets all person images
-- =============================================
CREATE PROCEDURE [dbo].[GetUserRoles]
(
  @RoleId int = NULL
, @RoleName nvarchar(100) = NULL
)
AS
BEGIN
	SELECT *
	  FROM UserRole
	 WHERE RoleId = COALESCE(@RoleId, RoleId)
       AND UPPER(LTRIM(RTRIM(RoleName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RoleName, RoleName)))) + '%'
END

GO


/*********** Script Update Date: 2022-08-24  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveUser
-- [== History ==]
-- <2022-08-22> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveUser 20, N'User 6', N'user6', N'123';     -- Save User with RoleId = 20 (user)
-- =============================================
CREATE PROCEDURE SaveUser (
  @RoleId int
, @FullName nvarchar(100)
, @UserName nvarchar(50)
, @Password nvarchar(50)
, @UserId int = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @LastUpdated datetime;
	BEGIN TRY
        -- Gets Current DateTime
        SET @LastUpdated = GETDATE();

		IF ((@UserId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM UserInfo
				 WHERE UserId = @UserId
			)
		   )
		BEGIN
			INSERT INTO UserInfo
			(
				  RoleId 
				, FullName 
				, UserName 
				, [Password] 
				, Active
                , LastUpdated 
			)
			VALUES
			(
				  @RoleId 
				, @FullName 
				, @UserName 
				, @Password
                , 1
                , @LastUpdated
			);

            SET @UserId = @@IDENTITY;
		END
		ELSE
		BEGIN
			UPDATE UserInfo
			   SET FullName = @FullName
                 , RoleId = @RoleId
                 , UserName = @UserName
                 , [Password] = @Password
                 , LastUpdated = @LastUpdated
			 WHERE UserId = @UserId
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[GetUsers]    Script Date: 8/20/2022 9:41:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUsers
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetUsers                                  -- Gets all active users
-- EXEC GetUsers N'user'                          -- Gets active all users that full name contains 'user'
-- EXEC GetUsers NULL, N'sup'                     -- Gets all active users that user name contains 'sup'
-- EXEC GetUsers NULL, NULL, N'u'                 -- Gets all active users that role name contains 'u'
-- EXEC GetUsers NULL, NULL, N'u', 10             -- Gets all active users that role name contains 'u' and RoleId = 10
-- EXEC GetUsers NULL, NULL, NULL, NULL, NULL     -- Gets all users (active/inactive)
-- =============================================
CREATE PROCEDURE [dbo].[GetUsers]
(
  @FullName nvarchar(100) = NULL
, @UserName nvarchar(50) = NULL
, @RoleName nvarchar(100) = NULL
, @RoleId int = NULL
, @Active int = 1
)
AS
BEGIN
	SELECT *
	  FROM UserInfoView
	 WHERE UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
       AND UPPER(LTRIM(RTRIM(UserName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@UserName, UserName)))) + '%'
       AND UPPER(LTRIM(RTRIM(RoleName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RoleName, RoleName)))) + '%'
       AND RoleId = COALESCE(@RoleId, RoleId)
       AND Active = COALESCE(@Active, Active)
     ORDER BY FullName, UserName
END

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[GetUser]    Script Date: 8/20/2022 9:41:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUser
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetUser N'user1', N'123'  -- Get active user that has UserName = 'user1' and password = '123'
-- =============================================
CREATE PROCEDURE [dbo].[GetUser]
(
  @UserName nvarchar(50)
, @Password nvarchar(50)
)
AS
BEGIN
	SELECT *
	  FROM UserInfoView
	 WHERE UPPER(LTRIM(RTRIM(UserName))) = UPPER(LTRIM(RTRIM(@UserName)))
       AND UPPER(LTRIM(RTRIM([Password]))) = UPPER(LTRIM(RTRIM(@Password)))
       AND Active = 1
END

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  UserDefinedFunction [dbo].[IsNullOrEmpty]    Script Date: 8/26/2022 11:00:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsNullOrEmpty.
-- Description:	IsNullOrEmpty is function to check is string is in null or empty
--              returns 1 if string is null or empty string otherwise return 0.
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.IsNullOrEmpty(null) AS RET;     -- NULL Returns 1
--SELECT dbo.IsNullOrEmpty('') AS RET;       -- Empty Returns 1
--SELECT dbo.IsNullOrEmpty(' ') AS RET;      -- Whitespace Returns 1
--SELECT dbo.IsNullOrEmpty('Test') AS RET;   -- Has data Returns 0
-- =============================================
CREATE FUNCTION [dbo].[IsNullOrEmpty](@str nvarchar)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    IF @str IS NULL OR RTRIM(LTRIM(@str)) = N''
		SET @result = 1
	ELSE SET @result = 0

    RETURN @result;
END

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMProvince]    Script Date: 8/29/2022 10:10:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMProvince
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC SaveMProvince N'10', N'10', N'กรุงเทพมหานคร', NULL, NULL
-- =============================================
ALTER PROCEDURE [dbo].[SaveMProvince] (
  @ProvinceId nvarchar(10)
, @RegionId nvarchar(10)
, @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100) = NULL
, @ADM1Code nvarchar(20) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@RegionId IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId is null';
			RETURN
		END

		IF ((@ProvinceId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MProvince
				 WHERE RegionId = @RegionId
				   AND ProvinceId = @ProvinceId
			)
		   )
		BEGIN
			INSERT INTO MProvince
			(
				  RegionId
				, ProvinceId 
				, ProvinceNameEN
				, ProvinceNameTH
				, ADM1Code
			)
			VALUES
			(
				  @RegionId
				, @ProvinceId
				, @ProvinceNameEN
				, @ProvinceNameTH
				, @ADM1Code
			);
		END
		ELSE
		BEGIN
			UPDATE MProvince
			   SET ProvinceNameEN = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameEN, ProvinceNameEN))))
				 , ProvinceNameTH = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
				 , ADM1Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
			 WHERE RegionId = @RegionId
			   AND ProvinceId = @ProvinceId
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



/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMDistrict]    Script Date: 8/29/2022 10:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMDistrict
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- SaveMDistrict N'01', N'10', N'10', N'พระนคร', NULL, NULL
-- =============================================
CREATE PROCEDURE [dbo].[SaveMDistrict] (
  @DistrictId nvarchar(10)
, @RegionId nvarchar(10)
, @ProvinceId nvarchar(10)
, @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100) = NULL
, @ADM2Code nvarchar(20) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@RegionId IS NULL OR @ProvinceId IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
			RETURN
		END

		IF ((@DistrictId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MDistrict
				 WHERE DistrictId = @DistrictId
				   AND RegionId = @RegionId
				   AND ProvinceId = @ProvinceId
			)
		   )
		BEGIN
			INSERT INTO MDistrict
			(
				  DistrictId
				, RegionId
				, ProvinceId 
				, DistrictNameEN
				, DistrictNameTH
				, ADM2Code
			)
			VALUES
			(
				  @DistrictId
				, @RegionId
				, @ProvinceId
				, @DistrictNameEN
				, @DistrictNameTH
				, @ADM2Code
			);
		END
		ELSE
		BEGIN
			UPDATE MDistrict
			   SET DistrictNameEN = UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameEN, DistrictNameEN))))
				 , DistrictNameTH = UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH))))
				 , ADM2Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM2Code, ADM2Code))))
			 WHERE DistrictId = @DistrictId
			   AND RegionId = @RegionId
			   AND ProvinceId = @ProvinceId
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMSubdistrict]    Script Date: 8/29/2022 10:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMSubdistrict
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC SaveMDistrict N'02', N'10', N'10', N'01', N'วังบูรพาภิรมย์', NULL, NULL
-- =============================================
CREATE PROCEDURE [dbo].[SaveMSubdistrict] (
  @SubdistrictId nvarchar(10)
, @RegionId nvarchar(10)
, @ProvinceId nvarchar(10)
, @DistrictId nvarchar(10)
, @SubdistrictNameTH nvarchar(100)
, @SubdistrictNameEN nvarchar(100) = NULL
, @ADM3Code nvarchar(20) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@RegionId IS NULL OR @ProvinceId IS NULL OR @DistrictId IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
			RETURN
		END

		IF ((@SubdistrictId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM MSubdistrict
				 WHERE SubdistrictId = @SubdistrictId
				   AND RegionId = @RegionId
				   AND ProvinceId = @ProvinceId
				   AND DistrictId = @DistrictId
			)
		   )
		BEGIN
			INSERT INTO MSubdistrict
			(
				  SubdistrictId
				, DistrictId
				, RegionId
				, ProvinceId 
				, SubdistrictNameEN
				, SubdistrictNameTH
				, ADM3Code
			)
			VALUES
			(
				  @SubdistrictId
				, @DistrictId
				, @RegionId
				, @ProvinceId
				, @SubdistrictNameEN
				, @SubdistrictNameTH
				, @ADM3Code
			);
		END
		ELSE
		BEGIN
			UPDATE MSubdistrict
			   SET SubdistrictNameEN = UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameEN, SubdistrictNameEN))))
				 , SubdistrictNameTH = UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameTH, SubdistrictNameTH))))
				 , ADM3Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM3Code, ADM3Code))))
			 WHERE SubdistrictId = @SubdistrictId
			   AND DistrictId = @DistrictId
			   AND RegionId = @RegionId
			   AND ProvinceId = @ProvinceId
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[GetMProvinces]    Script Date: 8/29/2022 11:42:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMProvinces
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMProvinces NULL, NULL, NULL, NULL, NULL, NULL		-- Gets all
-- EXEC GetMProvinces NULL, NULL, NULL, N'1', NULL, NULL		-- Search all that RegionName contains '1'
-- EXEC GetMProvinces NULL, N'ก', NULL, NULL, N'กลาง', NULL		-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
CREATE PROCEDURE [dbo].[GetMProvinces]
(
  @ProvinceId nvarchar(10) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
, @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
	  FROM MProvinceView
	 WHERE UPPER(LTRIM(RTRIM(ProvinceId))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceId, ProvinceId))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[GetMDistricts]    Script Date: 8/30/2022 12:19:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMDistricts
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMDistricts NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL	-- Gets all
-- EXEC GetMDistricts NULL, NULL, NULL, NULL, NULL, N'1', NULL, NULL	-- Search all that RegionName contains '1'
-- EXEC GetMDistricts NULL, NULL, NULL, N'ก', NULL, NULL, N'กลาง', NULL	-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
CREATE PROCEDURE [dbo].[GetMDistricts]
(
  @DistrictId nvarchar(10) = NULL
, @DistrictNameTH nvarchar(100) = NULL
, @ProvinceId nvarchar(10) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
, @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT DistrictId
	     , DistrictNameTH
	     , DistrictNameEN
	     , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , ADM2Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
	  FROM MDistrictView
	 WHERE UPPER(LTRIM(RTRIM(DistrictId))) = UPPER(LTRIM(RTRIM(COALESCE(@DistrictId, DistrictId))))
	   AND UPPER(LTRIM(RTRIM(DistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(ProvinceId))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceId, ProvinceId))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[GetMSubdistricts]    Script Date: 8/30/2022 12:19:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMSubdistricts
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL		-- Gets all
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'1', NULL, NULL		-- Search all that RegionName contains '1'
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL, NULL, N'ก', NULL, NULL, N'กลาง', NULL	-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
CREATE PROCEDURE [dbo].[GetMSubdistricts]
(
  @SubdistrictId nvarchar(10) = NULL
, @SubdistrictNameTH nvarchar(100) = NULL
, @DistrictId nvarchar(10) = NULL
, @DistrictNameTH nvarchar(100) = NULL
, @ProvinceId nvarchar(10) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
, @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT SubdistrictId
	     , SubdistrictNameTH
	     , SubdistrictNameEN
	     , DistrictId
	     , DistrictNameTH
	     , DistrictNameEN
	     , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , ADM2Code
	     , ADM3Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
	  FROM MSubdistrictView
	 WHERE UPPER(LTRIM(RTRIM(SubdistrictId))) = UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictId, SubdistrictId))))
	   AND UPPER(LTRIM(RTRIM(SubdistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameTH, SubdistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(DistrictId))) = UPPER(LTRIM(RTRIM(COALESCE(@DistrictId, DistrictId))))
	   AND UPPER(LTRIM(RTRIM(DistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(ProvinceId))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceId, ProvinceId))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[ImportPartyImage]    Script Date: 8/29/2022 1:57:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportPartyImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @errNum int
-- DECLARE @errMsg nvarchar(MAX)
-- DECLARE @partyName nvarchar(100)
-- 
-- DECLARE @jsonData NVARCHAR(MAX) = N'{"age":1,"name":"sample"}'
-- DECLARE @data VARBINARY(MAX) = CONVERT(VARBINARY(MAX), @jsonData)
-- 
-- SET @partyName = N'พลังประชารัฐ';
-- EXEC ImportPartyImage @partyName, @data, @errNum out, @errMsg out
-- 
-- SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
-- 
-- SELECT * FROM MParty
-- 
-- SELECT A.PartyId
--      , A.PartyName
--      , B.Data
--      , CONVERT(NVARCHAR(MAX), B.Data) AS JsonData
--   FROM MParty A, MContent B
-- =============================================
CREATE PROCEDURE [dbo].[ImportPartyImage] (
  @partyName nvarchar(100)
, @Data varbinary(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @LastUpdate datetime;
DECLARE @FileTypeId int = 1;    -- 1: Images
DECLARE @FileSubTypeId int = 2; -- 1: Person, 2: Logo
DECLARE @PartyId int;
DECLARE @ContentId uniqueidentifier;
DECLARE @IsNewContentId bit;
	BEGIN TRY
        -- SET LAST UPDATE DATETIME
	    SET @LastUpdate = GETDATE();
		SELECT @PartyId = PartyId
		     , @ContentId = ContentId
		  FROM MParty
		 WHERE UPPER(LTRIM(RTRIM(PartyName))) = UPPER(LTRIM(RTRIM(@PartyName)))

		IF (@PartyId IS NULL)
		BEGIN
			INSERT INTO MParty
			(
				  PartyName 
			)
			VALUES
			(
				  @PartyName
			);

			SET @PartyId = @@IDENTITY;
		END

		IF (@ContentId IS NULL)  
		BEGIN
			SET @IsNewContentId = 1
		END

		-- SAVE IMAGE
		EXEC SaveMContent @Data, @FileTypeId, @FileSubTypeId, @ContentId out, @errNum out, @errMsg out

		IF (@errNum = 0)
		BEGIN
		    -- SAVE IMAGE WITH NO ERROR
			IF (@IsNewContentId = 1)
			BEGIN
				-- Update Content Id back to MParty Table
				UPDATE MParty
				   SET ContentId = @ContentId
				 WHERE PartyId = @PartyId
			END
			-- Update Error Status/Message
			SET @errNum = 0;
			SET @errMsg = 'Success';
		END
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  UserDefinedFunction [dbo].[FindRegionId]    Script Date: 8/29/2022 8:52:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: Chumpon Asaneerat
-- Name: indRegionId.
-- Description:	IsNullOrEmpty is function to check is string is in null or empty
--              returns 1 if string is null or empty string otherwise return 0.
-- [== History ==]
-- <2022-08-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.FindRegionId(N'ภาค 10') AS RegionId;
-- =============================================
CREATE FUNCTION [dbo].[FindRegionId]
(
  @RegionName nvarchar(100)
)
RETURNS nvarchar(10)
AS
BEGIN
DECLARE @diff int;
DECLARE @RegionId nvarchar(10);
	SET @RegionId = NULL;

	SELECT @RegionId = RegionId
	  FROM MRegion
	 WHERE UPPER(LTRIM(RTRIM(RegionName))) = UPPER(LTRIM(RTRIM(@RegionName)))

	RETURN @RegionId;
END

GO




/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[ImportPollingStation]    Script Date: 8/30/2022 12:38:38 AM ******/
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
CREATe PROCEDURE [dbo].[ImportPollingStation] (
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


/*********** Script Update Date: 2022-08-24  ***********/
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
CREATE PROCEDURE [dbo].[SaveMPD2562VoteSummary] (
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
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPDC2566]    Script Date: 8/30/2022 6:31:39 AM ******/
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
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[SaveMPDC2566] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @CandidateNo int
, @FullName nvarchar(200)
, @PrevPartyName nvarchar(100) = NULL
, @EducationLevel nvarchar(100) = NULL
, @Remark nvarchar(200) = NULL
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
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
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
				, @Remark
			);
		END
		ELSE
		BEGIN
			UPDATE MPDC2566
			   SET PrevPartyName = @PrevPartyName
				 , EducationLevel = @EducationLevel
				 , [Remark] = @Remark
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[SavePersonImage]    Script Date: 8/30/2022 6:49:08 AM ******/
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
CREATE PROCEDURE [dbo].[SavePersonImage] (
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


/*********** Script Update Date: 2022-08-24  ***********/
/****** Object:  StoredProcedure [dbo].[GetPersonImage]    Script Date: 8/30/2022 6:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPersonImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonImage]
(
  @FullName nvarchar(200)
)
AS
BEGIN
	SELECT *
	  FROM PersonImage
	 WHERE FullName = @FullName
END

GO


/*********** Script Update Date: 2022-08-24  ***********/
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


/*********** Script Update Date: 2022-08-24  ***********/
-- INSERT File Types
INSERT INTO MFileType(FileTypeId, [Description]) VALUES(1, N'Image');
INSERT INTO MFileType(FileTypeId, [Description]) VALUES(2, N'Data');
GO

-- INSERT File Sub Types
INSERT INTO MFileSubType(FileTypeId, FileSubTypeId, [Description]) VALUES(1, 1, N'Person');
INSERT INTO MFileSubType(FileTypeId, FileSubTypeId, [Description]) VALUES(1, 2, N'Logo');
INSERT INTO MFileSubType(FileTypeId, FileSubTypeId, [Description]) VALUES(2, 1, N'Json');
GO


/*********** Script Update Date: 2022-08-24  ***********/
INSERT INTO MGender(GenderId, [Description]) VALUES(0, N'ไม่ระบุ');
INSERT INTO MGender(GenderId, [Description]) VALUES(1, N'ชาย');
INSERT INTO MGender(GenderId, [Description]) VALUES(2, N'หญิง');
GO


/*********** Script Update Date: 2022-08-24  ***********/
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (0, N'คุณ', N'คุณ', 0)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (1, N'เด็กชาย', N'ด.ช.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2, N'เด็กหญิง', N'ด.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (3, N'นาย', N'นาย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (4, N'นางสาว', N'น.ส.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (5, N'นาง', N'นาง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (6, N'นักโทษชายหม่อมหลวง', N'น.ช.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (7, N'นักโทษชาย', N'น.ช.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (8, N'นักโทษหญิง', N'น.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (9, N'นักโทษชายจ่าสิบเอก', N'น.ช.จ.ส.อ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (10, N'นักโทษชายจ่าเอก', N'น.ช.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (11, N'นักโทษชายพลทหาร', N'น.ช.พลฯ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (12, N'นักโทษชายร้อยตรี', N'น.ช.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (99, N'พระเจ้าหลานเธอ พระองค์เจ้า', N'พระเจ้าหลานเธอ พระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (100, N'พระบาทสมเด็จพระเจ้าอยู่หัว', N'พระบาทสมเด็จพระเจ้าอยู่หัว', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (101, N'สมเด็จพระนางเจ้า', N'สมเด็จพระนางเจ้า', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (102, N'สมเด็จพระศรีนครินทราบรมราชชนนี', N'สมเด็จพระศรีนครินทราบรมราชชนนี', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (103, N'พลโทสมเด็จพระบรมโอรสาธิราช', N'พลโทสมเด็จพระบรมโอรสาธิราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (104, N'พลตรีสมเด็จพระเทพรัตนราชสุดา', N'พลตรีสมเด็จพระเทพรัตนราชสุดา', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (105, N'พระเจ้าวรวงศ์เธอพระองค์หญิง', N'พระเจ้าวรวงศ์เธอพระองค์หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (106, N'พระเจ้าวรวงศ์เธอ พระองค์เจ้า', N'พระเจ้าวรวงศ์เธอ พระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (107, N'สมเด็จพระราชชนนี', N'สมเด็จพระราชชนนี', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (108, N'สมเด็จพระเจ้าพี่นางเธอเจ้าฟ้า', N'สมเด็จพระเจ้าพี่นางเธอเจ้าฟ้า', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (109, N'สมเด็จพระ', N'สมเด็จพระ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (110, N'สมเด็จพระเจ้าลูกเธอ', N'สมเด็จพระเจ้าลูกเธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (111, N'สมเด็จพระเจ้าลูกยาเธอ', N'สมเด็จพระเจ้าลูกยาเธอ', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (112, N'สมเด็จเจ้าฟ้า', N'สมเด็จเจ้าฟ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (113, N'พระเจ้าบรมวงศ์เธอ', N'พระเจ้าบรมวงศ์เธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (114, N'พระเจ้าวรวงศ์เธอ', N'พระเจ้าวรวงศ์เธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (115, N'พระเจ้าหลานเธอ', N'พระเจ้าหลานเธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (116, N'พระเจ้าหลานยาเธอ', N'พระเจ้าหลานยาเธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (117, N'พระวรวงศ์เธอ', N'พระวรวงศ์เธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (118, N'สมเด็จพระเจ้าภคินีเธอ', N'สมเด็จพระเจ้าภคินีเธอ', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (119, N'พระองค์เจ้า', N'พระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (120, N'หม่อมเจ้า', N'ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (121, N'หม่อมราชวงศ์', N'ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (122, N'หม่อมหลวง', N'ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (123, N'พระยา', N'พระยา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (124, N'หลวง', N'หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (125, N'ขุน', N'ขุน', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (126, N'หมื่น', N'หมื่น', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (127, N'เจ้าคุณ', N'เจ้าคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (128, N'พระวรวงศ์เธอพระองค์เจ้า', N'พระวรวงศ์เธอพระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (129, N'คุณ', N'คุณ', 0)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (130, N'คุณหญิง', N'คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (131, N'ท่านผู้หญิงหม่อมหลวง', N'ท่านผู้หญิง ม.ล.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (132, N'ศาสตราจารย์นายแพทย์', N'ศจ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (133, N'แพทย์หญิงคุณหญิง', N'พ.ญ.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (134, N'นายแพทย์', N'น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (135, N'แพทย์หญิง', N'พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (136, N'ทัณตแพทย์', N'ท.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (137, N'ทัณตแพทย์หญิง', N'ท.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (138, N'สัตวแพทย์', N'สพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (139, N'สัตวแพทย์หญิง', N'สญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (140, N'ดอกเตอร์', N'ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (141, N'ผู้ช่วยศาสตราจารย์', N'ผศ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (142, N'รองศาสตราจารย์', N'รศ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (143, N'ศาสตราจารย์', N'ศจ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (144, N'เภสัชกรชาย', N'ภก.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (145, N'เภสัชกรหญิง', N'ภญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (146, N'หม่อม', N'หม่อม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (147, N'รองอำมาตย์เอก', N'รองอำมาตย์เอก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (148, N'ท้าว', N'ท้าว', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (149, N'เจ้า', N'เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (150, N'ท่านผู้หญิง', N'ท่านผู้หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (151, N'คุณพระ', N'คุณพระ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (152, N'ศาสตราจารย์คุณหญิง', N'ศจ.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (153, N'ซิสเตอร์', N'ซิสเตอร์', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (154, N'เจ้าชาย', N'เจ้าชาย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (155, N'เจ้าหญิง', N'เจ้าหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (156, N'รองเสวกตรี', N'รองเสวกตรี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (157, N'เสด็จเจ้า', N'เสด็จเจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (158, N'เอกอัครราชฑูต', N'เอกอัครราชฑูต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (159, N'พลสารวัตร', N'พลสารวัตร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (160, N'สมเด็จเจ้า', N'สมเด็จเจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (161, N'เจ้าฟ้า', N'เจ้าฟ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (162, N'รองอำมาตย์ตรี', N'รองอำมาตย์ตรี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (163, N'หม่อมเจ้าหญิง', N'ม.จ.หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (164, N'ทูลกระหม่อม', N'ทูลกระหม่อม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (165, N'ศาสตราจารย์ดอกเตอร์', N'ศ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (166, N'เจ้านาง', N'เจ้านาง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (167, N'จ่าสำรอง', N'จ่าสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (200, N'พลเอก', N'พล.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (201, N'ว่าที่พลเอก', N'ว่าที่ พล.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (202, N'พลโท', N'พล.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (204, N'พลตรี', N'พล.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (205, N'ว่าที่พลตรี', N'ว่าที่ พล.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (206, N'พันเอกพิเศษ', N'พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (207, N'ว่าที่พันเอกพิเศษ', N'ว่าที่ พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (208, N'พันเอก', N'พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (209, N'ว่าที่พันเอก', N'ว่าที่ พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (210, N'พันโท', N'พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (211, N'ว่าที่พันโท', N'ว่าที่ พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (212, N'พันตรี', N'พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (213, N'ว่าที่พันตรี', N'ว่าที่ พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (214, N'ร้อยเอก', N'ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (215, N'ว่าที่ร้อยเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (216, N'ร้อยโท', N'ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (217, N'ว่าที่ร้อยโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (218, N'ร้อยตรี', N'ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (219, N'ว่าที่ร้อยตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (220, N'จ่าสิบเอก', N'จ.ส.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (221, N'จ่าสิบโท', N'จ.ส.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (222, N'จ่าสิบตรี', N'จ.ส.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (223, N'สิบเอก', N'ส.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (224, N'สิบโท', N'ส.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (225, N'สิบตรี', N'ส.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (226, N'พลทหาร', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (227, N'นักเรียนนายร้อย', N'นนร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (228, N'นักเรียนนายสิบ', N'นนส.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (229, N'พลจัตวา', N'พล.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (230, N'พลฯ อาสาสมัคร', N'พลฯ อาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (231, N'ร้อยเอกหม่อมเจ้า', N'ร.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (232, N'พลโทหม่อมเจ้า', N'พล.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (233, N'ร้อยตรีหม่อมเจ้า', N'ร.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (234, N'ร้อยโทหม่อมเจ้า', N'ร.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (235, N'พันโทหม่อมเจ้า', N'พ.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (236, N'พันเอกหม่อมเจ้า', N'พ.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (237, N'พันตรีหม่อมราชวงศ์', N'พ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (238, N'พันโทหม่อมราชวงศ์', N'พ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (239, N'สิบตรีหม่อมราชวงศ์', N'ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (240, N'พันเอกหม่อมราชวงศ์', N'พ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (241, N'จ่าสิบเอกหม่อมราชวงศ์', N'จ.ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (242, N'ร้อยเอกหม่อมราชวงศ์', N'ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (243, N'ร้อยตรีหม่อมราชวงศ์', N'ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (244, N'สิบเอกหม่อมราชวงศ์', N'ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (245, N'ร้อยโทหม่อมราชวงศ์', N'ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (246, N'พันเอก(พิเศษ)หม่อมราชวงศ์', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (247, N'พลฯหม่อมหลวง', N'พลฯม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (248, N'ร้อยเอกหม่อมหลวง', N'ร.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (249, N'สิบโทหม่อมหลวง', N'ส.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (250, N'พลโทหม่อมหลวง', N'พล.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (251, N'ร้อยโทหม่อมหลวง', N'ร.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (252, N'ร้อยตรีหม่อมหลวง', N'ร.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (253, N'สิบเอกหม่อมหลวง', N'ส.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (254, N'พลตรีหม่อมหลวง', N'พล.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (255, N'พันตรีหม่อมหลวง', N'พ.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (256, N'พันเอกหม่อมหลวง', N'พ.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (257, N'พันโทหม่อมหลวง', N'พ.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (258, N'จ่าสิบตรีหม่อมหลวง', N'จ.ส.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (259, N'นักเรียนนายร้อยหม่อมหลวง', N'นนร.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (260, N'ว่าที่ร้อยตรีหม่อมหลวง', N'ว่าที่ร.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (261, N'จ่าสิบเอกหม่อมหลวง', N'จ.ส.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (262, N'ร้อยเอกนายแพทย์', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (263, N'ร้อยเอกแพทย์หญิง', N'ร.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (264, N'ร้อยโทนายแพทย์', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (265, N'พันตรีนายแพทย์', N'พ.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (266, N'ว่าที่ร้อยโทนายแพทย์', N'ว่าที่ ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (267, N'พันเอกนายแพทย์', N'พ.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (268, N'ร้อยตรีนายแพทย์', N'ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (269, N'ร้อยโทแพทย์หญิง', N'ร.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (270, N'พลตรีนายแพทย์', N'พล.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (271, N'พันโทนายแพทย์', N'พ.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (272, N'จอมพล', N'จอมพล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (273, N'พันโทหลวง', N'พ.ท.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (274, N'พันตรีพระเจ้าวรวงศ์เธอพระองค์เจ้า', N'พ.ต.พระเจ้าวรวงศ์เธอพระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (275, N'ศาสตราจารย์พันเอก', N'ศจ.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (276, N'พันตรีหลวง', N'พ.ต.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (277, N'พลโทหลวง', N'พล.ท.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (278, N'ร้อยโทดอกเตอร์', N'ร.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (279, N'ร้อยเอกดอกเตอร์', N'ร.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (280, N'สารวัตรทหาร', N'ส.ห.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (281, N'ร้อยตรีดอกเตอร์', N'ร.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (282, N'พันตรีคุณหญิง', N'พ.ต.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (283, N'จ่าสิบตรีหม่อมราชวงศ์', N'จ.ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (284, N'พลจัตวาหลวง', N'พล.จ.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (285, N'พลตรีหม่อมราชวงศ์', N'พล.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (286, N'พันตรีพระเจ้าวรวงศ์เธอพระองค์', N'พ.ต.พระเจ้าวรวงศ์เธอพระองค์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (287, N'ท่านผู้หญิงหม่อมราชวงศ์', N'ท่านผู้หญิง ม.ร.ว.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (288, N'ศาสตราจารย์ร้อยเอก', N'ศจ.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (289, N'พันโทคุณหญิง', N'พ.ท.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (290, N'ร้อยตรีแพทย์หญิง', N'ร.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (291, N'พลเอกหม่อมหลวง', N'พล.อ.มล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (292, N'ว่าที่ร้อยตรีหม่อมราชวงศ์', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (293, N'พันเอกหญิงคุณหญิง', N'พ.อ.หญิง คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (294, N'จ่าสิบเอกพิเศษ', N'จ.ส.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (351, N'พลเรือเอก', N'พล.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (352, N'ว่าที่พลเรือเอก', N'ว่าที่ พล.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (353, N'พลเรือโท', N'พล.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (354, N'ว่าที่พลเรือโท', N'ว่าที่ พล.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (355, N'พลเรือตรี', N'พล.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (356, N'ว่าที่พลเรือตรี', N'ว่าที่ พล.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (357, N'นาวาเอกพิเศษ', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (358, N'ว่าที่นาวาเอกพิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (359, N'นาวาเอก', N'น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (360, N'ว่าที่นาวาเอก', N'ว่าที่ น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (361, N'นาวาโท', N'น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (362, N'ว่าที่นาวาโท', N'ว่าที่ น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (363, N'นาวาตรี', N'น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (364, N'ว่าที่นาวาตรี', N'ว่าที่ น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (365, N'เรือเอก', N'ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (366, N'ว่าที่เรือเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (367, N'เรือโท', N'ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (368, N'ว่าที่เรือโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (369, N'เรือตรี', N'ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (370, N'ว่าที่เรือตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (371, N'พันจ่าเอก', N'พ.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (372, N'พันจ่าโท', N'พ.จ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (373, N'พันจ่าตรี', N'พ.จ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (374, N'จ่าเอก', N'จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (375, N'จ่าโท', N'จ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (376, N'จ่าตรี', N'จ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (377, N'พลฯทหารเรือ', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (378, N'นักเรียนนายเรือ', N'นนร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (379, N'นักเรียนจ่าทหารเรือ', N'นรจ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (380, N'พลเรือจัตวา', N'พล.ร.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (381, N'นาวาโทหม่อมเจ้า', N'น.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (382, N'นาวาเอกหม่อมเจ้า', N'น.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (383, N'นาวาตรีหม่อมเจ้า', N'น.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (384, N'พลเรือตรีหม่อมราชวงศ์', N'พล.ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (385, N'นาวาเอกหม่อมราชวงศ์', N'น.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (386, N'นาวาโทหม่อมราชวงศ์', N'น.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (387, N'นาวาตรีหม่อมราชวงศ์', N'น.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (388, N'นาวาโทหม่อมหลวง', N'น.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (389, N'นาวาตรีหม่อมหลวง', N'น.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (390, N'พันจ่าเอกหม่อมหลวง', N'พ.จ.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (391, N'นาวาตรีแพทย์หญิง', N'น.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (392, N'นาวาอากาศเอกหลวง', N'น.อ.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (393, N'พลเรือตรีหม่อมเจ้า', N'พล.ร.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (395, N'นาวาตรีนายแพทย์', N'น.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (396, N'พลเรือตรีหม่อมหลวง', N'พล.ร.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (500, N'พลอากาศเอก', N'พล.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (501, N'ว่าที่พลอากาศเอก', N'ว่าที่ พล.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (502, N'พลอากาศโท', N'พล.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (503, N'ว่าที่พลอากาศโท', N'ว่าที่ พล.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (504, N'พลอากาศตรี', N'พล.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (505, N'ว่าที่พลอากาศตรี', N'ว่าที่ พล.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (506, N'นาวาอากาศเอกพิเศษ', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (507, N'ว่าที่นาวาอากาศเอกพิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (508, N'นาวาอากาศเอก', N'น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (509, N'ว่าที่นาวาอากาศเอก', N'ว่าที่ น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (510, N'นาวาอากาศโท', N'น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (511, N'ว่าที่นาวาอากาศโท', N'ว่าที่ น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (512, N'นาวาอากาศตรี', N'น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (513, N'ว่าที่นาวาอากาศตรี', N'ว่าที่ น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (514, N'เรืออากาศเอก', N'ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (515, N'ว่าที่เรืออากาศเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (516, N'เรืออากาศโท', N'ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (517, N'ว่าที่เรืออากาศโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (518, N'เรืออากาศตรี', N'ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (519, N'ว่าที่เรืออากาศตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (520, N'พันจ่าอากาศเอก', N'พ.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (521, N'พันจ่าอากาศโท', N'พ.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (522, N'พันจ่าอากาศตรี', N'พ.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (523, N'จ่าอากาศเอก', N'จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (524, N'จ่าอากาศโท', N'จ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (525, N'จ่าอากาศตรี', N'จ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (526, N'พลฯทหารอากาศ', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (527, N'นักเรียนนายเรืออากาศ', N'นนอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (528, N'นักเรียนจ่าอากาศ', N'นจอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (529, N'นักเรียนพยาบาลทหารอากาศ', N'น.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (530, N'พันอากาศเอกหม่อมราชวงศ์', N'พ.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (531, N'พลอากาศตรีหม่อมราชวงศ์', N'พล.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (532, N'พลอากาศโทหม่อมหลวง', N'พล.อ.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (533, N'เรืออากาศโทขุน', N'ร.ท.ขุน', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (534, N'พันจ่าอากาศเอกหม่อมหลวง', N'พ.อ.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (535, N'เรืออากาศเอกนายแพทย์', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (536, N'พลอากาศเอกหม่อมราชวงศ์', N'พล.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (537, N'พลอากาศตรีหม่อมหลวง', N'พล.อ.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (538, N'พลอากาศจัตวา', N'พล.อ.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (539, N'พลอากาศโทหม่อมราชวงศ์', N'พล.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (540, N'นาวาอากาศเอกหม่อมหลวง', N'น.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (606, N'พระครูพิบูลสมณธรรม', N'พระครูพิบูลสมณธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (651, N'พลตำรวจเอก', N'พล.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (652, N'ว่าที่พลตำรวจเอก', N'ว่าที่ พล.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (653, N'พลตำรวจโท', N'พล.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (654, N'ว่าที่พลตำรวจโท', N'ว่าที่ พล.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (655, N'พลตำรวจตรี', N'พล.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (656, N'ว่าที่พลตำรวจตรี', N'ว่าที่ พล.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (657, N'พลตำรวจจัตวา', N'พล.ต.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (658, N'ว่าที่พลตำรวจจัตวา', N'ว่าที่พล.ต.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (659, N'พันตำรวจเอก (พิเศษ)', N'พ.ต.อ. (พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (660, N'ว่าที่พันตำรวจเอก(พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (661, N'พันตำรวจเอก', N'พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (662, N'ว่าที่พันตำรวจเอก', N'ว่าที่ พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (663, N'พันตำรวจโท', N'พ.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (664, N'ว่าที่พันตำรวจโท', N'ว่าที่ พ.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (665, N'พันตำรวจตรี', N'พ.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (666, N'ว่าที่พันตำรวจตรี', N'ว่าที่ พ.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (667, N'ร้อยตำรวจเอก', N'ร.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (668, N'ว่าที่ร้อยตำรวจเอก', N'ว่าที่ ร.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (669, N'ร้อยตำรวจโท', N'ร.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (670, N'ว่าที่ร้อยตำรวจโท', N'ว่าที่ ร.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (671, N'ร้อยตำรวจตรี', N'ร.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (672, N'ว่าที่ร้อยตำรวจตรี', N'ว่าที่ ร.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (673, N'นายดาบตำรวจ', N'ด.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (674, N'จ่าสิบตำรวจ', N'จ.ส.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (675, N'สิบตำรวจเอก', N'ส.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (676, N'สิบตำรวจโท', N'ส.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (677, N'สิบตำรวจตรี', N'ส.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (678, N'นักเรียนนายร้อยตำรวจ', N'นรต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (679, N'นักเรียนนายสิบตำรวจ', N'นสต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (680, N'นักเรียนพลตำรวจ', N'นพต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (681, N'พลตำรวจ', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (682, N'พลตำรวจพิเศษ', N'พลฯพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (683, N'พลตำรวจอาสาสมัคร', N'พลฯอาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (684, N'พลตำรวจสำรอง', N'พลฯสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (685, N'พลตำรวจสำรองพิเศษ', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (686, N'พลตำรวจสมัคร', N'พลฯสมัคร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (687, N'สมาชิกอาสารักษาดินแดน', N'อส.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (688, N'นายกองใหญ่', N'ก.ญ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (689, N'นายกองเอก', N'ก.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (690, N'นายกองโท', N'ก.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (691, N'นายกองตรี', N'ก.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (692, N'นายหมวดเอก', N'มว.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (693, N'นายหมวดโท', N'มว.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (694, N'นายหมวดตรี', N'มว.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (695, N'นายหมู่ใหญ่', N'ม.ญ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (696, N'นายหมู่เอก', N'ม.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (697, N'นายหมู่โท', N'ม.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (698, N'นายหมู่ตรี', N'ม.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (699, N'สมาชิกเอก', N'สมาชิกเอก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (700, N'สมาชิกโท', N'สมาชิกโท', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (701, N'สมาชิกตรี', N'สมาชิกตรี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (702, N'อาสาสมัครทหารพราน', N'อส.ทพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (703, N'พันตำรวจโทหม่อมเจ้า', N'พ.ต.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (704, N'พันตำรวจเอกหม่อมเจ้า', N'พ.ต.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (705, N'นักเรียนนายร้อยตำรวจหม่อมเจ้า', N'นรต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (706, N'พลตำรวจตรีหม่อมราชวงศ์', N'พล.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (707, N'พันตำรวจตรีหม่อมราชวงศ์', N'พ.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (708, N'พันตำรวจโทหม่อมราชวงศ์', N'พ.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (709, N'พันตำรวจเอกหม่อมราชวงศ์', N'พ.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (710, N'ร้อยตำรวจเอกหม่อมราชวงศ์', N'ร.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (711, N'สิบตำรวจเอกหม่อมหลวง', N'ส.ต.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (712, N'พันตำรวจเอกหม่อมหลวง', N'พ.ต.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (713, N'พันตำรวจโทหม่อมหลวง', N'พ.ต.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (714, N'นักเรียนนายร้อยตำรวจหม่อมหลวง', N'นรต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (715, N'ร้อยตำรวจโทหม่อมหลวง', N'ร.ต.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (716, N'นายดาบตำรวจหม่อมหลวง', N'ด.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (717, N'พันตำรวจตรีหม่อมหลวง', N'พ.ต.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (718, N'ศาสตราจารย์นายแพทย์พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (719, N'พันตำรวจโทนายแพทย์', N'พ.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (720, N'ร้อยตำรวจโทนายแพทย์', N'ร.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (721, N'ร้อยตำรวจเอกนายแพทย์', N'ร.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (722, N'พันตำรวจตรีนายแพทย์', N'พ.ต.ต.นพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (723, N'พันตำรวจเอกนายแพทย์', N'พ.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (724, N'พันตำรวจตรีหลวง', N'พ.ต.ต.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (725, N'ร้อยตำรวจโทดอกเตอร์', N'ร.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (726, N'พันตำรวจเอกดอกเตอร์', N'พ.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (727, N'ร้อยตำรวจเอกหม่อมหลวง', N'ร.ต.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (729, N'พันตำรวจเอกหญิง ท่านผู้หญิง', N'พ.ต.อ.หญิง ท่านผู้หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (730, N'พลตำรวจตรีหม่อมหลวง', N'พล.ต.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (731, N'พลตรีหญิง คุณหญิง', N'พล.ต.หญิง คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (732, N'ว่าที่สิบเอก', N'ว่าที่ ส.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (733, N'พลตำรวจเอกดอกเตอร์', N'พล.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (800, N'สมเด็จพระสังฆราชเจ้า', N'สมเด็จพระสังฆราชเจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (801, N'สมเด็จพระสังฆราช', N'สมเด็จพระสังฆราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (802, N'สมเด็จพระราชาคณะ', N'สมเด็จพระราชาคณะ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (803, N'รองสมเด็จพระราชาคณะ', N'รองสมเด็จพระราชาคณะ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (804, N'พระราชาคณะ', N'พระราชาคณะ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (805, N'พระเปรียญธรรม', N'พระเปรียญธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (806, N'พระหิรัญยบัฏ', N'พระหิรัญยบัฏ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (807, N'พระสัญญาบัตร', N'พระสัญญาบัตร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (808, N'พระราช', N'พระราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (809, N'พระเทพ', N'พระเทพ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (810, N'พระปลัดขวา', N'พระปลัดขวา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (811, N'พระปลัดซ้าย', N'พระปลัดซ้าย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (812, N'พระครูปลัด', N'พระครูปลัด', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (813, N'พระครูปลัดสุวัฒนญาณคุณ', N'พระครูปลัดสุวัฒนญาณคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (814, N'พระครูปลัดอาจารย์วัฒน์', N'พระครูปลัดอาจารย์วัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (815, N'พระครูวิมลสิริวัฒน์', N'พระครูปลัดวิมลสิริวัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (816, N'พระสมุห์', N'พระสมุห์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (817, N'พระครูสมุห์', N'พระครูสมุห์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (818, N'พระครู', N'พระครู', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (819, N'พระครูใบฎีกา', N'พระครูใบฎีกา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (820, N'พระครูธรรมธร', N'พระครูธรรมธร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (821, N'พระครูวิมลภาณ', N'พระครูวิมลภาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (822, N'พระครูศัพทมงคล', N'พระครูศัพทมงคล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (823, N'พระครูสังฆภารวิชัย', N'พระครูสังฆภารวิชัย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (824, N'พระครูสังฆรักษ์', N'พระครูสังฆรักษ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (825, N'พระครูสังฆวิชัย', N'พระครูสังฆวิชัย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (826, N'พระครูสังฆวิชิต', N'พระครูสังฆวิชิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (827, N'พระปิฎก', N'พระปิฎก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (828, N'พระปริยัติ', N'พระปริยัติ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (829, N'เจ้าอธิการ', N'เจ้าอธิการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (830, N'พระอธิการ', N'พระอธิการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (831, N'พระ', N'พระ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (832, N'สามเณร', N'ส.ณ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (833, N'พระปลัด', N'พระปลัด', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (834, N'สมเด็จพระอริยวงศาคตญาณ', N'สมเด็จพระอริยวงศาคตญาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (835, N'พระคาร์ดินัล', N'พระคาร์ดินัล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (836, N'พระสังฆราช', N'พระสังฆราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (837, N'พระคุณเจ้า', N'พระคุณเจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (838, N'บาทหลวง', N'บาทหลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (839, N'พระมหา', N'พระมหา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (840, N'พระราชปัญญา', N'พระราชปัญญา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (841, N'ภาราดา', N'ภาราดา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (842, N'พระศรีปริยัติธาดา', N'พระศรีปริยัติธาดา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (843, N'พระญาณโศภณ', N'พระญาณโศภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (844, N'สมเด็จพระมหาวีรวงศ์', N'สมเด็จพระมหาวีรวงศ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (845, N'พระโสภณธรรมาภรณ์', N'พระโสภณธรรมาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (846, N'พระวิริวัฒน์วิสุทธิ์', N'พระวิริวัฒน์วิสุทธิ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (847, N'พระญาณ', N'พระญาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (848, N'พระอัครสังฆราช', N'พระอัครสังฆราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (849, N'พระธรรม', N'พระธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (850, N'พระสาสนโสภณ', N'พระสาสนโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (851, N'พระธรรมโสภณ', N'พระธรรมโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (852, N'พระอุดมสารโสภณ', N'พระอุดมสารโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (853, N'พระครูวิมลญาณโสภณ', N'พระครูวิมลญาณโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (854, N'พระครูปัญญาภรณโสภณ', N'พระครูปัญญาภรณโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (855, N'พระครูโสภณปริยัติคุณ', N'พระครูโสภณปริยัติคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (856, N'พระอธิธรรม', N'พระอธิธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (857, N'พระราชญาณ', N'พระราชญาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (858, N'พระสุธีวัชโรดม', N'พระสุธีวัชโรดม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (859, N'รองเจ้าอธิการ', N'รองเจ้าอธิการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (860, N'พระครูวินัยธร', N'พระครูวินัยธร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (861, N'พระศรีวชิราภรณ์', N'พระศรีวชิราภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (862, N'พระราชบัณฑิต', N'พระราชบัณฑิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (863, N'แม่ชี', N'แม่ชี', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (864, N'นักบวช', N'นักบวช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (865, N'พระรัตน', N'พระรัตน', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (866, N'พระโสภณปริยัติธรรม', N'พระโสภณปริยัติธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (867, N'พระครูวิศาลปัญญาคุณ', N'พระครูวิศาลปัญญาคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (868, N'พระศรีปริยัติโมลี', N'พระศรีปริยัติโมลี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (869, N'พระครูวัชรสีลาภรณ์', N'พระครูวัชรสีลาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (870, N'พระครูพิพัฒน์บรรณกิจ', N'พระครูพิพัฒน์บรรณกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (871, N'พระครูวิบูลธรรมกิจ', N'พระครูวิบูลธรรมกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (872, N'พระครูพัฒนสารคุณ', N'พระครูพัฒนสารคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (873, N'พระครูสุวรรณพัฒนคุณ', N'พระครูสุวรรณพัฒนคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (874, N'พระครูพรหมวีรสุนทร', N'พระครูพรหมวีรสุนทร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (875, N'พระครูอุปถัมภ์นันทกิจ', N'พระครูอุปถัมภ์นันทกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (876, N'พระครูวิจารณ์สังฆกิจ', N'พระครูวิจารณ์สังฆกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (877, N'พระครูวิมลสารวิสุทธิ์', N'พระครูวิมลสารวิสุทธิ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (878, N'พระครูไพศาลศุภกิจ', N'พระครูไพศาลศุภกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (879, N'พระครูโอภาสธรรมพิมล', N'พระครูโอภาสธรรมพิมล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (880, N'พระครูพิพิธวรคุณ', N'พระครูพิพิธวรคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (881, N'พระครูสุนทรปภากร', N'พระครูสุนทรปภากร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (882, N'พระครูสิริชัยสถิต', N'พระครูสิริชัยสถิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (883, N'พระครูเกษมธรรมานันท์', N'พระครูเกษมธรรมานันท์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (884, N'พระครูถาวรสันติคุณ', N'พระครูถาวรสันติคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (885, N'พระครูวิสุทธาจารวิมล', N'พระครูวิสุทธาจารวิมล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (886, N'พระครูปภัสสราธิคุณ', N'พระครูปภัสสราธิคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (887, N'พระครูวรสังฆกิจ', N'พระครูวรสังฆกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (888, N'พระครูไพบูลชัยสิทธิ์', N'พระครูไพบูลชัยสิทธิ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (889, N'พระครูโกวิทธรรมโสภณ', N'พระครูโกวิทธรรมโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (890, N'พระครูสุพจน์วราภรณ์', N'พระครูสุพจน์วราภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (891, N'พระครูไพโรจน์อริญชัย', N'พระครูไพโรจน์อริญชัย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (892, N'พระครูสุนทรคณาภิรักษ์', N'พระครูสุนทรคณาภิรักษ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (893, N'พระสรภาณโกศล', N'พระสรภาณโกศล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (894, N'พระครูประโชติธรรมรัตน์', N'พระครูประโชติธรรมรัตน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (895, N'พระครูจารุธรรมกิตติ์', N'พระครูจารุธรรมกิตติ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (896, N'พระครูพิทักษ์พรหมรังษี', N'พระครูพิทักษ์พรหมรังษี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (897, N'พระศรีปริยัติบัณฑิต', N'พระศรีปริยัติบัณฑิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (898, N'พระครูพุทธิธรรมานุศาสน์', N'พระครูพุทธิธรรมานุศาสน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (899, N'พระธรรมเมธาจารย์', N'พระธรรมเมธาจารย์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (900, N'พระครูกิตติกาญจนวงศ์', N'พระครูกิตติกาญจนวงศ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (901, N'พระครูปลัดสัมพิพัฒนวิริยาจารย์', N'พระครูปลัดสัมพิพัฒนวิริยาจารย์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (902, N'พระครูศีลกันตาภรณ์', N'พระครูศีลกันตาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (903, N'พระครูประกาศพุทธพากย์', N'พระครูประกาศพุทธพากย์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (904, N'พระครูอมรวิสุทธิคุณ', N'พระครูอมรวิสุทธิคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (905, N'พระครูสุทัศน์ธรรมาภิรม', N'พระครูสุทัศน์ธรรมาภิรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (906, N'พระครูอุปถัมภ์วชิโรภาส', N'พระครูอุปถัมภ์วชิโรภาส', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (907, N'พระครูสุนทรสมณคุณ', N'พระครูสุนทรสมณคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (908, N'พระพรหมมุนี', N'พระพรหมมุนี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (909, N'พระครูสิริคุณารักษ์', N'พระครูสิริคุณารักษ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (910, N'พระครูวิชิตพัฒนคุณ', N'พระครูวิชิตพัฒนคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (911, N'พระครูพิบูลโชติธรรม', N'พระครูพิบูลโชติธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (912, N'พระพิศาลสารคุณ', N'พระพิศาลสารคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (913, N'พระรัตนมงคลวิสุทธ์', N'พระรัตนมงคลวิสุทธ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (914, N'พระครูโสภณคุณานุกูล', N'พระครูโสภณคุณานุกูล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (915, N'พระครูผาสุกวิหารการ', N'พระครูผาสุกวิหารการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (916, N'พระครูวชิรวุฒิกร', N'พระครูวชิรวุฒิกร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (917, N'พระครูกาญจนยติกิจ', N'พระครูกาญจนยติกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (918, N'พระครูบวรรัตนวงศ์', N'พระครูบวรรัตนวงศ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (919, N'พระราชพัชราภรณ์', N'พระราชพัชราภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (920, N'พระครูพิพิธอุดมคุณ', N'พระครูพิพิธอุดมคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (921, N'องสุตบทบวร', N'องสุตบทบวร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (922, N'พระครูจันทเขมคุณ', N'พระครูจันทเขมคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (923, N'พระครูศีลสารวิสุทธิ์', N'พระครูศีลสารวิสุทธิ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (924, N'พระครูสุธรรมโสภิต', N'พระครูสุธรรมโสภิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (925, N'พระครูอุเทศธรรมนิวิฐ', N'พระครูอุเทศธรรมนิวิฐ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (926, N'พระครูบรรณวัตร', N'พระครูบรรณวัตร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (927, N'พระครูวิสุทธาจาร', N'พระครูวิสุทธาจาร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (928, N'พระครูสุนทรวรวัฒน์', N'พระครูสุนทรวรวัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (929, N'พระเทพชลธารมุนี ศรีชลบุราจารย์', N'พระเทพชลธารมุนี ศรีชลบุราจารย์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (930, N'พระครูโสภณสมุทรคุณ', N'พระครูโสภณสมุทรคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (931, N'พระราชเมธาภรณ์', N'พระราชเมธาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (932, N'พระครูศรัทธาธรรมโสภณ', N'พระครูศรัทธาธรรมโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (933, N'พระครูสังฆบริรักษ์', N'พระครูสังฆบริรักษ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (934, N'พระมหานายก', N'พระมหานายก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (935, N'พระครูโอภาสสมาจาร', N'พระครูโอภาสสมาจาร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (936, N'พระครูศรีธวัชคุณาภรณ์', N'พระครูศรีธวัชคุณาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (937, N'พระครูโสภิตวัชรกิจ', N'พระครูโสภิตวัชรกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (938, N'พระราชวชิราภรณ์', N'พระราชวชิราภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (939, N'พระครูสุนทรวรธัช', N'พระครูสุนทรวรธัช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (940, N'พระครูอาทรโพธิกิจ', N'พระครูอาทรโพธิกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (941, N'พระครูวิบูลกาญจนกิจ', N'พระครูวิบูลกาญจนกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (942, N'พระพรหมวชิรญาณ', N'พระพรหมวชิรญาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (943, N'พระครูสุพจน์วรคุณ', N'พระครูสุพจน์วรคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (944, N'พระราชาวิมลโมลี', N'พระราชวิมลโมลี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (945, N'พระครูอมรธรรมนายก', N'พระครูอมรธรรมนายก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (946, N'พระครูพิศิษฎ์ศาสนการ', N'พระครูพิศิษฎ์ศาสนการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (947, N'พระครูเมธีธรรมานุยุต', N'พระครูเมธีธรรมานุยุต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (948, N'พระครูปิยสีลสาร', N'พระครูปิยสีลสาร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (949, N'พระครูสถิตบุญวัฒน์', N'พระครูสถิตบุญวัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (950, N'พระครูนิเทศปิยธรรม', N'พระครูนิเทศปิยธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (951, N'พระครูวิสุทธิ์กิจจานุกูล', N'พระครูวิสุทธิ์กิจจานุกูล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (952, N'พระครูสถิตย์บุญวัฒน์', N'พระครูสถิตย์บุญวัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (953, N'พระครูประโชติธรรมานุกูล', N'พระครูประโชติธรรมานุกูล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (954, N'พระเทพญาณกวี', N'พระเทพญาณกวี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (955, N'พระครูพิพัฒน์ชินวงศ์', N'พระครูพิพัฒน์ชินวงศ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (956, N'พระครูสมุทรขันตยาภรณ์', N'พระครูสมุทรขันตยาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (957, N'พระครูภาวนาวรกิจ', N'พระครูภาวนาวรกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (958, N'พระครูศรีศาสนคุณ', N'พระครูศรีศาสนคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (959, N'พระครูวิบูลย์ธรรมศาสก์', N'พระครูวิบูลย์ธรรมศาสก์', 1)
GO


/*********** Script Update Date: 2022-08-24  ***********/
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(1, 15, 24,  N'ต่ำกว่า 25 ปี',  1, 0);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(2, 25, 30,  N'25 - 30 ปี',   2, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(3, 31, 40,  N'31 - 40 ปี',   3, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(4, 41, 50,  N'41 - 50 ปี',   4, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(5, 51, 60,  N'51 - 60 ปี',   5, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(6, 61, 70,  N'61 - 70 ปี',   6, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(7, 71, 80,  N'71 - 80 ปี',   7, 1);
INSERT INTO MAge(AgeId, AgeMin, AgeMax, [Description], SortOrder, Active) VALUES(8, 81, 150, N'มากกว่า 80 ปี', 8, 1);
GO


/*********** Script Update Date: 2022-08-24  ***********/
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(0, N'ไม่ระบุ', 0, 1);
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(1, N'ต่ำกว่าปริญญาตรี', 1, 1);
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(2, N'ปริญญาตรี', 2, 1);
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(3, N'ปริญญาโท', 3, 1);
INSERT INTO MEducation(EducationId, [Description], SortOrder, Active) VALUES(4, N'ปริญญาเอก', 4, 1);
GO


/*********** Script Update Date: 2022-08-24  ***********/
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(1, N'ข้าราชการ/พนักงาน/เจ้าหน้าที่ ของรัฐ', 1, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(2, N'ข้าราชการการเมือง/นักการเมือง', 2, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(3, N'ข้าราชการส่วนท้องถิ่น', 3, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(4, N'ข้าราชการบำนาญ', 4, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(5, N'ครู/อาจารย์/นักวิชาการ', 5, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(6, N'แพทย์', 6, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(7, N'ทนายความ/นักกฎหมาย', 7, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(8, N'ธุรกิจส่วนตัว/ค้าขาย', 8, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(9, N'ผู้บริหาร/พนักงาน/ลูกจ้าง ภาคเอกชน', 9, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(10, N'รัฐวิสาหกิจ', 10, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(11, N'เกษตรกร', 11, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(12, N'รับจ้างอิสระ', 12, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(13, N'วิชาชีพ', 13, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(14, N'ที่ปรึกษา', 14, 1);
INSERT INTO MOccupation(OccupationId, [Description], SortOrder, Active) VALUES(15, N'อื่นๆ', 15, 1);
GO


/*********** Script Update Date: 2022-08-24  ***********/
-- CREATE DEFAULT USER ROLES
INSERT INTO UserRole(RoleId, RoleName) VALUES(1, N'Admistrator');
INSERT INTO UserRole(RoleId, RoleName) VALUES(10, N'Supervisor');
INSERT INTO UserRole(RoleId, RoleName) VALUES(20, N'User');

-- CREATE DEFAULT USERS
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(1, N'Administrator', N'admin', N'admin');

INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(10, N'Supervisor 1', N'sup1', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(10, N'Supervisor 2', N'sup2', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 1', N'user1', N'123');

INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 2', N'user2', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 3', N'user3', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 4', N'user4', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 5', N'user5', N'123');
GO

