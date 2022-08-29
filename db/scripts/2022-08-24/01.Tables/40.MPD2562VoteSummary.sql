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
