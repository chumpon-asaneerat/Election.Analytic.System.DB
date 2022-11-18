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
