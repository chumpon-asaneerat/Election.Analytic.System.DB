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
