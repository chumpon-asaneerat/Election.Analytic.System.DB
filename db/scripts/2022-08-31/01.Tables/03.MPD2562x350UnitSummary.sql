/****** Object:  Table [dbo].[MPD2562x350UnitSummary]    Script Date: 9/7/2022 10:06:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MPD2562x350UnitSummary](
	[ProvinceName] [nvarchar](100) NOT NULL,
	[PollingUnitNo] [int] NOT NULL,
	[RightCount] [int] NULL,
	[ExerciseCount] [int] NULL,
	[InvalidCount] [int] NULL,
	[NoVoteCount] [int] NULL,
 CONSTRAINT [PK_MPD2562x350UnitSummary] PRIMARY KEY CLUSTERED 
(
	[ProvinceName] ASC,
	[PollingUnitNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MPD2562x350UnitSummary] ADD  CONSTRAINT [DF_MPD2562x350UnitSummary_RightCount]  DEFAULT ((0)) FOR [RightCount]
GO

ALTER TABLE [dbo].[MPD2562x350UnitSummary] ADD  CONSTRAINT [DF_MPD2562x350UnitSummary_ExerciseCount]  DEFAULT ((0)) FOR [ExerciseCount]
GO

ALTER TABLE [dbo].[MPD2562x350UnitSummary] ADD  CONSTRAINT [DF_MPD2562x350UnitSummary_InvalidCount]  DEFAULT ((0)) FOR [InvalidCount]
GO

ALTER TABLE [dbo].[MPD2562x350UnitSummary] ADD  CONSTRAINT [DF_MPD2562x350UnitSummary_NoVoteCount]  DEFAULT ((0)) FOR [NoVoteCount]
GO
