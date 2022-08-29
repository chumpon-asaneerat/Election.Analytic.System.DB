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
