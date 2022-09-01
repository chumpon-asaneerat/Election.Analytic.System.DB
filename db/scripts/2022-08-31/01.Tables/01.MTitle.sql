/****** Object:  Index [IX_MTitle_ShortName]    Script Date: 9/1/2022 5:42:10 PM ******/
DROP INDEX [IX_MTitle_ShortName] ON [dbo].[MTitle]
GO

/****** Object:  Index [IX_MTitle_ShortName]    Script Date: 9/1/2022 5:45:17 PM ******/
CREATE NONCLUSTERED INDEX [IX_MTitle_ShortName] ON [dbo].[MTitle]
(
	[ShortName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
