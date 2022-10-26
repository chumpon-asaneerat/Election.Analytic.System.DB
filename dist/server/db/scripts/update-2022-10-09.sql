/*********** Script Update Date: 2022-10-09  ***********/
CREATE VIEW MPD2562VoteSummaryView
AS
    SELECT ROW_NUMBER() OVER
		   (
			   ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC
		   ) AS RowNo
		 , ROW_NUMBER() OVER
		   (
		       PARTITION BY ProvinceName, PollingUnitNo
			   ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC
		   ) AS RankNo
         , * 
      FROM MPD2562VoteSummary

GO


/*********** Script Update Date: 2022-10-09  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDC2566FullSummaries]    Script Date: 10/26/2022 10:57:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566FullSummaries
-- [== History ==]
-- <2022-10-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDC2566FullSummaries]
(
  @ProvinceName nvarchar(100) = NULL
)
AS
BEGIN
    SELECT * 
      FROM MPDC2566
     WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
     ORDER BY ProvinceName, PollingUnitNo, CandidateNo
END

GO


/*********** Script Update Date: 2022-10-09  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SearchPersonImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[SearchPersonImage]
(
  @FullName nvarchar(200)
)
AS
BEGIN
	SELECT *
	  FROM PersonImage
	 WHERE FullName = @FullName
	    OR UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(@FullName)))
		OR UPPER(LTRIM(RTRIM(@FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(FullName)))

END

GO


/*********** Script Update Date: 2022-10-09  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPD2562VoteSummaries]    Script Date: 10/26/2022 12:33:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPD2562VoteSummaries
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
-- <2022-10-09> :
--	- Add PartyNamne parameter.
--	- Add FullNamne parameter.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[GetMPD2562VoteSummaries]
(
  @ProvinceName nvarchar(100) = NULL
, @PartyName nvarchar(100) = NULL
, @FullName nvarchar(200) = NULL
)
AS
BEGIN
    ;WITH MPD2562VoteSum62
    AS
    -- Define the Vote Summary by Province and PollingUnit query.
    (
        SELECT * 
          FROM MPD2562VoteSummaryView
         WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
		   AND UPPER(LTRIM(RTRIM(PartyName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@PartyName, PartyName)))) + '%'
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
    )
    SELECT * 
      FROM MPD2562VoteSum62 
     ORDER BY ProvinceName, PollingUnitNo, VoteCount DESC

END

GO


/*********** Script Update Date: 2022-10-09  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDC2566s]    Script Date: 10/26/2022 1:44:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566s
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
-- <2022-10-07> :
--	- Supports Paging.
-- <2022-10-09> :
--	- Add FullNamne parameter.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[GetMPDC2566s]
(
  @ProvinceName nvarchar(100) = NULL
, @FullName nvarchar(200) = NULL
, @pageNum as int = 1 out
, @pollingUnitPerPage as int = 4 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iTotalUnits int;
DECLARE @sFullName nvarchar(200)
	BEGIN TRY
		-- calculate total polling units and max pages
		SELECT @iTotalUnits = COUNT(*) 
		  FROM MPDPollingUnitSummary
		 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceNameTH))))

		SELECT @maxPage = 
			CASE WHEN (@iTotalUnits % @pollingUnitPerPage > 0) THEN 
				(@iTotalUnits / @pollingUnitPerPage) + 1
			ELSE 
				(@iTotalUnits / @pollingUnitPerPage)
			END;

		;WITH PollUnits AS
		(
			SELECT DISTINCT 
			       ProvinceName
			     , PollingUnitNo 
			  FROM MPDC2566
		), SQLPaging AS
		(
			SELECT TOP(@pollingUnitPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY A.ProvinceName, A.PollingUnitNo) AS RowNo
			     , A.ProvinceName
				 , A.PollingUnitNo
			  FROM PollUnits A 
			 WHERE UPPER(LTRIM(RTRIM(A.ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, A.ProvinceName))))
		)

		SELECT A.ProvinceName
			 , A.PollingUnitNo
			 , A.CandidateNo
			 , A.FullName
			 , A.PrevPartyName
			 , A.EducationLevel
			 , A.Remark
			 , A.SubGroup
			 , IMG.FullName AS ImageFullName
			 , IMG.Data
             , A.ProvinceName AS ProvinceNameOri
             , A.PollingUnitNo AS PollingUnitNoOri
             , A.CandidateNo AS CandidateNoOri
             , A.FullName AS FullNameOri
		  FROM SQLPaging M WITH (NOLOCK)
		     , MPDC2566 A 
			   LEFT OUTER JOIN PersonImage IMG
               ON 
               (   
                   (IMG.FullName = A.FullName)
                OR (IMG.FullName LIKE '%' + A.FullName + '%')
                OR (A.FullName LIKE '%' + IMG.FullName + '%')
               )
		 WHERE RowNo > ((@pageNum - 1) * @pollingUnitPerPage)
		   AND A.ProvinceName = M.ProvinceName
		   AND A.PollingUnitNo = M.PollingUnitNo

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-10-09  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDC2566FullSummaries]    Script Date: 10/26/2022 1:48:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566FullSummaries
-- [== History ==]
-- <2022-10-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[GetMPDC2566FullSummaries]
(
  @ProvinceName nvarchar(100) = NULL
, @FullName nvarchar(200) = NULL
)
AS
BEGIN
    SELECT * 
      FROM MPDC2566
     WHERE UPPER(LTRIM(RTRIM(ProvinceName))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceName, ProvinceName))))
       AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@FullName, FullName)))) + '%'
     ORDER BY ProvinceName, PollingUnitNo, CandidateNo
END

GO


/*********** Script Update Date: 2022-10-09  ***********/
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

