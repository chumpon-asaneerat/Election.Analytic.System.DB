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

