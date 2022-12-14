/****** Object:  Table [dbo].[MPD2562PollingUnitSummary]    Script Date: 9/7/2022 11:42:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MPD2562PollingUnitSummary](
	[ProvinceName] [nvarchar](100) NOT NULL,
	[PollingUnitNo] [int] NOT NULL,
	[PollingUnitCount] [int] NOT NULL,
 CONSTRAINT [PK_MPD2562PollingUnitSummary] PRIMARY KEY CLUSTERED 
(
	[ProvinceName] ASC,
	[PollingUnitNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MPD2562PollingUnitSummary] ADD  CONSTRAINT [DF_MPD2562PollingUnitSummary_PollingUnitCount]  DEFAULT ((0)) FOR [PollingUnitCount]
GO
