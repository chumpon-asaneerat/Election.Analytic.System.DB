/*********** Script Update Date: 2022-09-19  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[_MPD2562x350UnitSummaryView]
AS
	SELECT A.ProvinceName
		 , A.PollingUnitNo
		 , A.RightCount
		 , A.ExerciseCount
		 , A.InvalidCount
		 , A.NoVoteCount
		 , B.FullName
		 , B.PartyName
		 , B.VoteCount
		 , C.PollingUnitCount
	  FROM MPD2562x350UnitSummary A 
	  JOIN MPD2562VoteSummary B
		ON (
				B.ProvinceName = A.ProvinceName
			AND B.PollingUnitNo = A.PollingUnitNo
		   )
	  JOIN MPD2562PollingUnitSummary C
		ON (
				C.ProvinceName = A.ProvinceName
			AND C.PollingUnitNo = A.PollingUnitNo
		   )

GO


/*********** Script Update Date: 2022-09-19  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MPD2562x350UnitSummaryView]
AS
	SELECT A.ProvinceName
		 , A.PollingUnitNo
		 , A.RightCount
		 , A.ExerciseCount
		 , A.InvalidCount
		 , A.NoVoteCount
		 , A.FullName
		 , A.PartyName
		 , A.VoteCount
		 , A.PollingUnitCount
	  FROM _MPD2562x350UnitSummaryView A
	 WHERE VoteCount = (
						SELECT MAX(VoteCount) AS VoteCount 
						  FROM _MPD2562x350UnitSummaryView 
						 WHERE ProvinceName = A.ProvinceName
						   AND PollingUnitNo = A.PollingUnitNo 
					   )

GO


/*********** Script Update Date: 2022-09-19  ***********/
/*
-- ALREADY INSERTED
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2829, N'ร.ต. นายแพทย์', N'ร.ต.น.พ.', 1)
*/





/*
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2284, N'พลจัตวาหลวง', N'พล.จ.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2285, N'พลตรีหม่อมราชวงศ์', N'พล.ต.ม.ร.ว.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (712, N'พันตำรวจเอกหม่อมหลวง', N'พ.ต.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (713, N'พันตำรวจโทหม่อมหลวง', N'พ.ต.ท.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (291, N'พลเอกหม่อมหลวง', N'พล.อ.มล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2250, N'พลโทหม่อมหลวง', N'พล.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2255, N'พันตรีหม่อมหลวง', N'พ.ต.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2256, N'พันเอกหม่อมหลวง', N'พ.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2257, N'พันโทหม่อมหลวง', N'พ.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2254, N'พลตรีหม่อมหลวง', N'พล.ต.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2248, N'ร้อยเอกหม่อมหลวง', N'ร.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (251, N'ร้อยโทหม่อมหลวง', N'ร.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2252, N'ร้อยตรีหม่อมหลวง', N'ร.ต.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2260, N'ว่าที่ร้อยตรีหม่อมหลวง', N'ว่าที่ร.ต.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2259, N'นักเรียนนายร้อยหม่อมหลวง', N'นนร.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2261, N'จ่าสิบเอกหม่อมหลวง', N'จ.ส.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2258, N'จ่าสิบตรีหม่อมหลวง', N'จ.ส.ต.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2253, N'สิบเอกหม่อมหลวง', N'ส.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2249, N'สิบโทหม่อมหลวง', N'ส.ท.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2247, N'พลฯหม่อมหลวง', N'พลฯม.ล.', 1)


INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (540, N'นาวาอากาศเอกหม่อมหลวง', N'น.อ.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (388, N'นาวาโทหม่อมหลวง', N'น.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (389, N'นาวาตรีหม่อมหลวง', N'น.ต.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (396, N'พลเรือตรีหม่อมหลวง', N'พล.ร.ต.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (390, N'พันจ่าเอกหม่อมหลวง', N'พ.จ.อ.ม.ล.', 1)


INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (717, N'พันตำรวจตรีหม่อมหลวง', N'พ.ต.ต.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (727, N'ร้อยตำรวจเอกหม่อมหลวง', N'ร.ต.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (715, N'ร้อยตำรวจโทหม่อมหลวง', N'ร.ต.ท.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (730, N'พลตำรวจตรีหม่อมหลวง', N'พล.ต.ต.ม.ล.', 1)


INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (534, N'พันจ่าอากาศเอกหม่อมหลวง', N'พ.อ.อ.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (532, N'พลอากาศโทหม่อมหลวง', N'พล.อ.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (537, N'พลอากาศตรีหม่อมหลวง', N'พล.อ.ต.ม.ล.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (711, N'สิบตำรวจเอกหม่อมหลวง', N'ส.ต.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (716, N'นายดาบตำรวจหม่อมหลวง', N'ด.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (714, N'นักเรียนนายร้อยตำรวจหม่อมหลวง', N'นรต.ม.ล.', 1)


INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (382, N'นาวาเอกหม่อมเจ้า', N'น.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (381, N'นาวาโทหม่อมเจ้า', N'น.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (383, N'นาวาตรีหม่อมเจ้า', N'น.ต.ม.จ.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (704, N'พันตำรวจเอกหม่อมเจ้า', N'พ.ต.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (703, N'พันตำรวจโทหม่อมเจ้า', N'พ.ต.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (393, N'พลเรือตรีหม่อมเจ้า', N'พล.ร.ต.ม.จ.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (705, N'นักเรียนนายร้อยตำรวจหม่อมเจ้า', N'นรต.ม.จ.', 1)

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (392, N'นาวาอากาศเอกหลวง', N'น.อ.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (724, N'พันตำรวจตรีหลวง', N'พ.ต.ต.หลวง', 1)
*/

