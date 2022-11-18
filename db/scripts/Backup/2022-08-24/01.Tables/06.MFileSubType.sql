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
