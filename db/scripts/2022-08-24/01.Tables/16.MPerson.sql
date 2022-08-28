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
