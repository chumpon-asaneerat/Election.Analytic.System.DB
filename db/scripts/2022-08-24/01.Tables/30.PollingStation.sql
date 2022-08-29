/****** Object:  Table [dbo].[PollingStation]    Script Date: 8/29/2022 9:30:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PollingStation](
	[YearThai] [int] NOT NULL,
	[RegionId] [nvarchar](10) NOT NULL,
	[ProvinceId] [nvarchar](10) NOT NULL,
	[DistrictId] [nvarchar](10) NOT NULL,
	[SubdistrictId] [nvarchar](10) NOT NULL,
	[PollingUnitNo] [int] NOT NULL,
	[PollingSubUnitNo] [int] NULL,
	[VillageCount] [int] NULL,
 CONSTRAINT [PK_PollingStation] PRIMARY KEY CLUSTERED 
(
	[YearThai] ASC,
	[RegionId] ASC,
	[ProvinceId] ASC,
	[DistrictId] ASC,
	[SubdistrictId] ASC,
	[PollingUnitNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
