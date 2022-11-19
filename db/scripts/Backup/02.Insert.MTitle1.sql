/*
-- ALREADY INSERTED
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2987, N'ว่าที่ ร.ต. หญิง', N'ว่าที่ ร.ต.หญิง', 1)
*/


-- NEED TO ADD หญิง
/*

EXEC SaveMTitle N'ว่าที่ พล.อ.อ.', 2
EXEC SaveMTitle N'ว่าที่ พลอากาศเอก', 2
EXEC SaveMTitle N'ว่าที่.พล.อ.อ.', 2
EXEC SaveMTitle N'ว่าที่. พล.อ.อ.', 2

EXEC SaveMTitle N'ว่าที่ พล.อ.ท.', 2
EXEC SaveMTitle N'ว่าที่ พลอากาศโท', 2
EXEC SaveMTitle N'ว่าที่.พล.อ.ท.', 2
EXEC SaveMTitle N'ว่าที่. พล.อ.ท.', 2

EXEC SaveMTitle N'ว่าที่ พล.อ.ต.', 2
EXEC SaveMTitle N'ว่าที่ พลอากาศตรี', 2
EXEC SaveMTitle N'ว่าที่.พล.อ.ต.',2
EXEC SaveMTitle N'ว่าที่. พล.อ.ต.', 2

-- to be continue...
EXEC SaveMTitle N'ว่าที่ สิบเอก', N'ว่าที่ ส.อ.', 1)
EXEC SaveMTitle N'ว่าที่.ส.อ.', N'ว่าที่ ส.อ.', 1)
EXEC SaveMTitle N'ว่าที่. ส.อ.', N'ว่าที่ ส.อ.', 1)
EXEC SaveMTitle N'ว่าที่สิบโท', N'ว่าที่ ส.ท.', 1)
EXEC SaveMTitle N'ว่าที่ สิบโท', N'ว่าที่ ส.ท.', 1)
EXEC SaveMTitle N'ว่าที่.ส.ท.', N'ว่าที่ ส.ท.', 1)
EXEC SaveMTitle N'ว่าที่. ส.ท.', N'ว่าที่ ส.ท.', 1)
EXEC SaveMTitle N'ว่าที่สิบตรี', N'ว่าที่ ส.ต.', 1)
EXEC SaveMTitle N'ว่าที่ สิบตรี', N'ว่าที่ ส.ต.', 1)
EXEC SaveMTitle N'ว่าที่.ส.ต.', N'ว่าที่ ส.ต.', 1)
EXEC SaveMTitle N'ว่าที่. ส.ต.', N'ว่าที่ ส.ต.', 1)
EXEC SaveMTitle N'ว่าที่ พลเอก', N'ว่าที่ พล.อ.', 1)
EXEC SaveMTitle N'ว่าที่พลโท', N'ว่าที่ พล.ท.', 1)
EXEC SaveMTitle N'ว่าที่ พลโท', N'ว่าที่ พล.ท.', 1)
EXEC SaveMTitle N'ว่าที่ พลตรี', N'ว่าที่ พล.ต.', 1)
EXEC SaveMTitle N'ว่าที่ พันเอก', N'ว่าที่ พ.อ.', 1)
EXEC SaveMTitle N'ว่าที่ พันโท', N'ว่าที่ พ.ท.', 1)
EXEC SaveMTitle N'ว่าที่ พันตรี', N'ว่าที่ พ.ต.', 1)
EXEC SaveMTitle N'ว่าที่ ร้อยเอก', N'ว่าที่ ร.อ.', 1)
EXEC SaveMTitle N'ว่าที่ ร้อยโท', N'ว่าที่ ร.ท.', 1)

EXEC SaveMTitle N'ว่าที่ พันตำรวจเอก (พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ พันตำรวจเอก(พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ พ.ต.อ. (พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ พ.ต.อ.(พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ พ.ต.อ. พิเศษ', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ พ.ต.อ.พิเศษ', N'ว่าที่ พ.ต.อ.พิเศษ', 1)

EXEC SaveMTitle N'ว่าที่ ร้อยตำรวจเอก', N'ว่าที่ ร.ต.อ.', 1)
EXEC SaveMTitle N'ว่าที่ ร.ต.อ.', N'ว่าที่ ร.ต.อ.', 1)
EXEC SaveMTitle N'ว่าที่.ร.ต.อ.', N'ว่าที่ ร.ต.อ.', 1)
EXEC SaveMTitle N'ว่าที่. ร.ต.อ.', N'ว่าที่ ร.ต.อ.', 1)
EXEC SaveMTitle N'ว่าที่ ร้อยตำรวจโท', N'ว่าที่ ร.ต.ท.', 1)
EXEC SaveMTitle N'ว่าที่ ร.ต.ท.', N'ว่าที่ ร.ต.ท.', 1)
EXEC SaveMTitle N'ว่าที่.ร.ต.ท.', N'ว่าที่ ร.ต.ท.', 1)
EXEC SaveMTitle N'ว่าที่. ร.ต.ท.', N'ว่าที่ ร.ต.ท.', 1)
EXEC SaveMTitle N'ว่าที่ ร้อยตำรวจตรี', N'ว่าที่ ร.ต.ต.', 1)
EXEC SaveMTitle N'ว่าที่ ร.ต.ต.', N'ว่าที่ ร.ต.ต.', 1)
EXEC SaveMTitle N'ว่าที่.ร.ต.ต.', N'ว่าที่ ร.ต.ต.', 1)
EXEC SaveMTitle N'ว่าที่. ร.ต.ต.', N'ว่าที่ ร.ต.ต.', 1)
EXEC SaveMTitle N'ว่าที่ นาวาอากาศเอกพิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ น.อ.พิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่. น.อ.พิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่.น.อ.พิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ นาวาอากาศเอก(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ นาวาอากาศเอก (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ น.อ.(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ น.อ. (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่. น.อ.(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่. น.อ. (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่.น.อ.(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่.น.อ. (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ นาวาอากาศเอก', N'ว่าที่ น.อ.', 1)
EXEC SaveMTitle N'ว่าที่ น.อ.', N'ว่าที่ น.อ.', 1)
EXEC SaveMTitle N'ว่าที่. น.อ.', N'ว่าที่ น.อ.', 1)
EXEC SaveMTitle N'ว่าที่.น.อ.', N'ว่าที่ น.อ.', 1)
EXEC SaveMTitle N'ว่าที่ นาวาอากาศโท', N'ว่าที่ น.ท.', 1)
EXEC SaveMTitle N'ว่าที่ น.ท.', N'ว่าที่ น.ท.', 1)
EXEC SaveMTitle N'ว่าที่. น.ท.', N'ว่าที่ น.ท.', 1)
EXEC SaveMTitle N'ว่าที่.น.ท.', N'ว่าที่ น.ท.', 1)
EXEC SaveMTitle N'ว่าที่ นาวาอากาศตรี', N'ว่าที่ น.ต.', 1)
EXEC SaveMTitle N'ว่าที่ น.ต.', N'ว่าที่ น.ต.', 1)
EXEC SaveMTitle N'ว่าที่.น.ต.', N'ว่าที่ น.ต.', 1)
EXEC SaveMTitle N'ว่าที่. น.ต.', N'ว่าที่ น.ต.', 1)
EXEC SaveMTitle N'ว่าที่ เรืออากาศเอก', N'ว่าที่ ร.อ.', 1)
EXEC SaveMTitle N'ว่าที่.เรืออากาศเอก', N'ว่าที่ ร.อ.', 1)
EXEC SaveMTitle N'ว่าที่.ร.อ.', N'ว่าที่ ร.อ.', 1)
EXEC SaveMTitle N'ว่าที่. ร.อ.', N'ว่าที่ ร.อ.', 1)
EXEC SaveMTitle N'ว่าที่ เรืออากาศโท', N'ว่าที่ ร.ท.', 1)
EXEC SaveMTitle N'ว่าที่.เรืออากาศโท', N'ว่าที่ ร.ท.', 1)
EXEC SaveMTitle N'ว่าที่.ร.ท.', N'ว่าที่ ร.ท.', 1)
EXEC SaveMTitle N'ว่าที่. ร.ท.', N'ว่าที่ ร.ท.', 1)
EXEC SaveMTitle N'ว่าที่ เรืออากาศตรี', N'ว่าที่ ร.ต.', 1)
EXEC SaveMTitle N'ว่าที่.เรืออากาศตรี', N'ว่าที่ ร.ต.', 1)
EXEC SaveMTitle N'ว่าที่.ร.ต.', N'ว่าที่ ร.ต.', 1)
EXEC SaveMTitle N'ว่าที่ .ร.ต.', N'ว่าที่ ร.ต.', 1)
EXEC SaveMTitle N'ว่าที่ พลเรือเอก', N'ว่าที่ พล.ร.อ.', 1)
EXEC SaveMTitle N'ว่าที่. พล.ร.อ.', N'ว่าที่ พล.ร.อ.', 1)
EXEC SaveMTitle N'ว่าที่.พล.ร.อ.', N'ว่าที่ พล.ร.อ.', 1)
EXEC SaveMTitle N'ว่าที่ พลเรือโท', N'ว่าที่ พล.ร.ท.', 1)
EXEC SaveMTitle N'ว่าที่. พล.ร.ท.', N'ว่าที่ พล.ร.ท.', 1)
EXEC SaveMTitle N'ว่าที่.พล.ร.ท.', N'ว่าที่ พล.ร.ท.', 1)
EXEC SaveMTitle N'ว่าที่ พลเรือตรี', N'ว่าที่ พล.ร.ต.', 1)
EXEC SaveMTitle N'ว่าที่. พล.ร.ต.', N'ว่าที่ พล.ร.ต.', 1)
EXEC SaveMTitle N'ว่าที่.พล.ร.ต.', N'ว่าที่ พล.ร.ต.', 1)
EXEC SaveMTitle N'ว่าที่ นาวาเอกพิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่  น.อ.(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่  น.อ. (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
EXEC SaveMTitle N'ว่าที่ นาวาเอก', N'ว่าที่ น.อ.', 1)
EXEC SaveMTitle N'ว่าที่ นาวาโท', N'ว่าที่ น.ท.', 1)
EXEC SaveMTitle N'ว่าที่ นาวาตรี', N'ว่าที่ น.ต.', 1)
EXEC SaveMTitle N'ว่าที่ เรือเอก', N'ว่าที่ ร.อ.', 1)
EXEC SaveMTitle N'ว่าที่ เรือโท', N'ว่าที่ ร.ท.', 1)
EXEC SaveMTitle N'ว่าที่ เรือตรี', N'ว่าที่ ร.ต.', 1)
EXEC SaveMTitle N'ว่าที่. ร.ต.', N'ว่าที่ ร.ต.', 1)

EXEC SaveMTitle N'พันเอก พิเศษ', N'พ.อ.(พิเศษ)', 1)
EXEC SaveMTitle N'พันเอก(พิเศษ)', N'พ.อ.(พิเศษ)', 1)
EXEC SaveMTitle N'พันเอก (พิเศษ)', N'พ.อ.(พิเศษ)', 1)
EXEC SaveMTitle N'ว่าที่ พันเอก พิเศษ', N'ว่าที่ พ.อ.(พิเศษ)', 1)
EXEC SaveMTitle N'ว่าที่ พันเอก(พิเศษ)', N'ว่าที่ พ.อ.(พิเศษ)', 1)
EXEC SaveMTitle N'ว่าที่ พันเอก (พิเศษ)', N'ว่าที่ พ.อ.(พิเศษ)', 1)
EXEC SaveMTitle N'ว่าที่พ.อ.(พิเศษ)', N'ว่าที่ พ.อ.(พิเศษ)', 1)
EXEC SaveMTitle N'ว่าที่ พ.อ. (พิเศษ)', N'ว่าที่ พ.อ.(พิเศษ)', 1)

EXEC SaveMTitle N'พลจัตวาหลวง', N'พล.จ.หลวง', 1)
EXEC SaveMTitle N'พลตรีหม่อมราชวงศ์', N'พล.ต.ม.ร.ว.', 1)

EXEC SaveMTitle N'พันตำรวจเอกหม่อมหลวง', N'พ.ต.อ.ม.ล.', 1)
EXEC SaveMTitle N'พันตำรวจโทหม่อมหลวง', N'พ.ต.ท.ม.ล.', 1)

EXEC SaveMTitle N'พลเอกหม่อมหลวง', N'พล.อ.มล.', 1)
EXEC SaveMTitle N'พลโทหม่อมหลวง', N'พล.ท.ม.ล.', 1)
EXEC SaveMTitle N'พันตรีหม่อมหลวง', N'พ.ต.ม.ล.', 1)

EXEC SaveMTitle N'พันเอกหม่อมหลวง', N'พ.อ.ม.ล.', 1)
EXEC SaveMTitle N'พันโทหม่อมหลวง', N'พ.ท.ม.ล.', 1)
EXEC SaveMTitle N'พลตรีหม่อมหลวง', N'พล.ต.ม.ล.', 1)

EXEC SaveMTitle N'ร้อยเอกหม่อมหลวง', N'ร.อ.ม.ล.', 1)
EXEC SaveMTitle N'ร้อยโทหม่อมหลวง', N'ร.ท.ม.ล.', 1)
EXEC SaveMTitle N'ร้อยตรีหม่อมหลวง', N'ร.ต.ม.ล.', 1)

EXEC SaveMTitle N'ว่าที่ร้อยตรีหม่อมหลวง', N'ว่าที่ร.ต.ม.ล.', 1)

EXEC SaveMTitle N'นักเรียนนายร้อยหม่อมหลวง', N'นนร.ม.ล.', 1)

EXEC SaveMTitle N'จ่าสิบเอกหม่อมหลวง', N'จ.ส.อ.ม.ล.', 1)
EXEC SaveMTitle N'จ่าสิบตรีหม่อมหลวง', N'จ.ส.ต.ม.ล.', 1)

EXEC SaveMTitle N'สิบเอกหม่อมหลวง', N'ส.อ.ม.ล.', 1)
EXEC SaveMTitle N'สิบโทหม่อมหลวง', N'ส.ท.ม.ล.', 1)

EXEC SaveMTitle N'พลฯหม่อมหลวง', N'พลฯม.ล.', 1)

EXEC SaveMTitle N'นาวาอากาศเอกหม่อมหลวง', N'น.อ.ม.ล.', 1)

EXEC SaveMTitle N'นาวาโทหม่อมหลวง', N'น.ท.ม.ล.', 1)
EXEC SaveMTitle N'นาวาตรีหม่อมหลวง', N'น.ต.ม.ล.', 1)

EXEC SaveMTitle N'พลเรือตรีหม่อมหลวง', N'พล.ร.ต.ม.ล.', 1)

EXEC SaveMTitle N'พันจ่าเอกหม่อมหลวง', N'พ.จ.อ.ม.ล.', 1)

EXEC SaveMTitle N'พันตำรวจตรีหม่อมหลวง', N'พ.ต.ต.ม.ล.', 1)

EXEC SaveMTitle N'ร้อยตำรวจเอกหม่อมหลวง', N'ร.ต.อ.ม.ล.', 1)
EXEC SaveMTitle N'ร้อยตำรวจโทหม่อมหลวง', N'ร.ต.ท.ม.ล.', 1)

EXEC SaveMTitle N'พลตำรวจตรีหม่อมหลวง', N'พล.ต.ต.ม.ล.', 1)

EXEC SaveMTitle N'พันจ่าอากาศเอกหม่อมหลวง', N'พ.อ.อ.ม.ล.', 1)

EXEC SaveMTitle N'พลอากาศโทหม่อมหลวง', N'พล.อ.ท.ม.ล.', 1)
EXEC SaveMTitle N'พลอากาศตรีหม่อมหลวง', N'พล.อ.ต.ม.ล.', 1)

EXEC SaveMTitle N'สิบตำรวจเอกหม่อมหลวง', N'ส.ต.อ.ม.ล.', 1)
EXEC SaveMTitle N'นายดาบตำรวจหม่อมหลวง', N'ด.ต.ม.ล.', 1)
EXEC SaveMTitle N'นักเรียนนายร้อยตำรวจหม่อมหลวง', N'นรต.ม.ล.', 1)

EXEC SaveMTitle N'นาวาเอกหม่อมเจ้า', N'น.อ.ม.จ.', 1)
EXEC SaveMTitle N'นาวาโทหม่อมเจ้า', N'น.ท.ม.จ.', 1)
EXEC SaveMTitle N'นาวาตรีหม่อมเจ้า', N'น.ต.ม.จ.', 1)

EXEC SaveMTitle N'พันตำรวจเอกหม่อมเจ้า', N'พ.ต.อ.ม.จ.', 1)
EXEC SaveMTitle N'พันตำรวจโทหม่อมเจ้า', N'พ.ต.ท.ม.จ.', 1)
EXEC SaveMTitle N'พลเรือตรีหม่อมเจ้า', N'พล.ร.ต.ม.จ.', 1)

EXEC SaveMTitle N'นักเรียนนายร้อยตำรวจหม่อมเจ้า', N'นรต.ม.จ.', 1)

EXEC SaveMTitle N'นาวาอากาศเอกหลวง', N'น.อ.หลวง', 1)
EXEC SaveMTitle N'พันตำรวจตรีหลวง', N'พ.ต.ต.หลวง', 1)
