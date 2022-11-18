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
