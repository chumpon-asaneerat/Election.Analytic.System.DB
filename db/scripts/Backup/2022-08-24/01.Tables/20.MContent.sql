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
