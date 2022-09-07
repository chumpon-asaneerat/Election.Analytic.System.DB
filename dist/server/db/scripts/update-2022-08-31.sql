/*********** Script Update Date: 2022-08-31  ***********/
/****** Object:  Index [IX_MTitle_ShortName]    Script Date: 9/1/2022 5:42:10 PM ******/
DROP INDEX [IX_MTitle_ShortName] ON [dbo].[MTitle]
GO

/****** Object:  Index [IX_MTitle_ShortName]    Script Date: 9/1/2022 5:45:17 PM ******/
CREATE NONCLUSTERED INDEX [IX_MTitle_ShortName] ON [dbo].[MTitle]
(
	[ShortName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/*********** Script Update Date: 2022-08-31  ***********/
ALTER TABLE MPDC2566 
  ADD SubGroup NVARCHAR(200) NULL;
GO


/*********** Script Update Date: 2022-08-31  ***********/
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


/*********** Script Update Date: 2022-08-31  ***********/
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


/*********** Script Update Date: 2022-08-31  ***********/
/****** Object:  UserDefinedFunction [dbo].[SplitStringT]    Script Date: 9/1/2022 9:03:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SplitStringT.
-- Description:	Split String into substring (Remove empty elements).
-- [== History ==]
-- <2022-08-31> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--SELECT dbo.SplitStringT(N'Test  XXX  ', N' ')
--
-- =============================================
CREATE FUNCTION [dbo].[SplitStringT] 
( 
  @string nvarchar(4000)
, @delim nvarchar(100)
)
RETURNS
@result TABLE 
( 
  [RowId] int  NOT NULL
, [Item] nvarchar(4000) NOT NULL
, [Index] int NOT NULL 
, [Length] int  NOT NULL
)
AS
BEGIN
DECLARE   @str nvarchar(4000)
		, @pos int 
		, @length int
		, @max int = LEN(@string)
		, @prv int = 1
		, @rowId int = 1

	SELECT @pos = CHARINDEX(@delim, @string)
	WHILE @pos > 0
	BEGIN
		SELECT @str = SUBSTRING(@string, @prv, @pos - @prv)
		SET @length = @pos - @prv;

		IF (LEN(LTRIM(RTRIM(@str))) > 0)
		BEGIN
			INSERT INTO @result SELECT @rowId
									 , LTRIM(RTRIM(@str))
									 , @prv
									 , @length
			SET @rowId = @rowId + 1 -- SET ROW ID AFTER INSERT
		END

		SELECT @prv = @pos + LEN(@delim)
		     , @pos = CHARINDEX(@delim, @string, @pos + 1)
	END

	SET @length = @max - @prv;
	SET @str = SUBSTRING(@string, @prv, @max)
	IF (LEN(LTRIM(RTRIM(@str))) > 0)
	BEGIN
		INSERT INTO @result SELECT @rowId
								 , LTRIM(RTRIM(@str))
								 , @prv
								 , @length
	END

	RETURN
END

GO


/*********** Script Update Date: 2022-08-31  ***********/
/****** Object:  StoredProcedure [dbo].[Parse_FullName_Lv1]    Script Date: 9/1/2022 9:12:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Parse FullName level 1
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[Parse_FullName_Lv1] (
  @fullName nvarchar(4000)
, @el nvarchar(100)
, @prefix nvarchar(100) = NULL out
, @firstName nvarchar(100) = NULL out
, @lastName nvarchar(100) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @fullTitle nvarchar(100);
DECLARE @shotTitle nvarchar(100);
DECLARE @title nvarchar(100);
DECLARE @matchTitle nvarchar(100);
	-- EXTRACT Prefix/FirstName from element
	BEGIN TRY
		-- CHECK PARAMETERS
		IF (    (@fullName IS NULL OR LEN(@fullName) = 0)
		     OR (@el IS NULL OR LEN(@el) = 0)
		   )
		BEGIN
			SET @errNum = 100;
			SET @errMsg = N'Parameter(s) is null.';
		END

		-- Find Match Description.
		SELECT TOP 1 @fullTitle = [Description]
		  FROM MTitleView
		 WHERE @el LIKE [Description] + '%' 
		 ORDER BY DLen DESC

		IF (@fullTitle IS NULL)
		BEGIN
			-- No Match Description so try with Short Name.
			SELECT TOP 1 @fullTitle = [Description], @shotTitle = ShortName
			  FROM MTitleView
			 WHERE @el LIKE ShortName + '%'
			 ORDER BY SLen DESC
			IF (@shotTitle IS NOT NULL)
			BEGIN
				-- MATCH SHORT TITLE
				SET @title = @fullTitle
				-- Keep it to used later for substring function
				SET @matchTitle = @shotTitle
			END
		END
		ELSE
		BEGIN
			-- Match Description
			SET @title = @fullTitle
			-- Keep it to used later for substring function
			SET @matchTitle = @fullTitle
		END

		IF (@title IS NULL)
		BEGIN
			-- NO TITLE MATCH SO IT SEEM TO BE ONLY FIRSTNAME + LASTNAME WITHOUT SEPERATE SPACE
			SET @firstName = @el
		END
		ELSE
		BEGIN
			-- TITLE MATCH SO IT SPLIT PREFIX, FIRSTNAME + LASTNAME WITHOUT SEPERATE SPACE
			SET @prefix = @title
			SET @firstName = SUBSTRING(@el, 1 + LEN(@matchTitle), LEN(@fullName) - LEN(@matchTitle))
		END

		IF (@firstName IS NOT NULL AND LEN(@firstName) = 0) 
			SET @firstName = NULL;

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-08-31  ***********/
/****** Object:  StoredProcedure [dbo].[Parse_FullName_Lv2]    Script Date: 9/1/2022 4:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Parse FullName level 2
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[Parse_FullName_Lv2] (
  @fullName nvarchar(4000)
, @el1 nvarchar(100)
, @el2 nvarchar(100)
, @prefix nvarchar(100) = NULL out
, @firstName nvarchar(100) = NULL out
, @lastName nvarchar(100) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		-- EXTRACT Prefix/FirstName from element
		EXEC Parse_FullName_Lv1 @fullName, @el1
							  , @prefix out, @firstName out, @lastName out
							  , @errNum out, @errMsg out
		
		IF (@errNum <> 0) RETURN; -- EXECUTE ERROR

		-- in this case we not need to consider prefix 
		-- because the el2 must be only first or last name
		IF (@firstName IS NULL)
		BEGIN
			-- Not found first name in previous level so need to check next element (el2)
			IF (@el2 IS NOT NULL)
			BEGIN
				SET @firstName = @el2
			END
		END
		ELSE
		BEGIN
			-- Found first name in previous level so next element (el2) must be Last Name
			IF (@el2 IS NOT NULL)
			BEGIN
				SET @lastName = @el2
			END
		END

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-08-31  ***********/
/****** Object:  StoredProcedure [dbo].[Parse_FullName_Lv3]    Script Date: 9/1/2022 4:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Parse FullName level 3
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[Parse_FullName_Lv3] (
  @fullName nvarchar(4000)
, @el1 nvarchar(100)
, @el2 nvarchar(100)
, @el3 nvarchar(100)
, @prefix nvarchar(100) = NULL out
, @firstName nvarchar(100) = NULL out
, @lastName nvarchar(100) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-08-31  ***********/
/****** Object:  StoredProcedure [dbo].[Parse_FullName_Lv4]    Script Date: 9/1/2022 4:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Parse FullName level 4
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[Parse_FullName_Lv4] (
  @fullName nvarchar(4000)
, @el1 nvarchar(100)
, @el2 nvarchar(100)
, @el3 nvarchar(100)
, @el4 nvarchar(100)
, @prefix nvarchar(100) = NULL out
, @firstName nvarchar(100) = NULL out
, @lastName nvarchar(100) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-08-31  ***********/
/****** Object:  StoredProcedure [dbo].[Parse_FullName_Lv5]    Script Date: 9/1/2022 4:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Parse FullName level 5
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[Parse_FullName_Lv5] (
  @fullName nvarchar(4000)
, @el1 nvarchar(100)
, @el2 nvarchar(100)
, @el3 nvarchar(100)
, @el4 nvarchar(100)
, @el5 nvarchar(100)
, @prefix nvarchar(100) = NULL out
, @firstName nvarchar(100) = NULL out
, @lastName nvarchar(100) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2022-08-31  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPDC2566]    Script Date: 9/7/2022 8:18:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPDC2566
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-07> :
--	- Add SubGroup parameter.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SaveMPDC2566] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @CandidateNo int
, @FullName nvarchar(200)
, @PrevPartyName nvarchar(100) = NULL
, @EducationLevel nvarchar(100) = NULL
, @SubGroup nvarchar(200) = NULL
, @Remark nvarchar(200) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL 
		 OR @CandidateNo IS NULL
		 OR @FullName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
			RETURN
		END

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPDC2566
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
				   AND CandidateNo = @CandidateNo
				   AND FullName = @FullName
			)
		   )
		BEGIN
			INSERT INTO MPDC2566
			(
				  ProvinceName
				, PollingUnitNo
				, CandidateNo 
				, FullName
				, PrevPartyName
				, EducationLevel
				, SubGroup
				, [Remark]
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @CandidateNo
				, @FullName
				, @PrevPartyName
				, @EducationLevel
				, @SubGroup
				, @Remark
			);
		END
		ELSE
		BEGIN
			UPDATE MPDC2566
			   SET PrevPartyName = @PrevPartyName
				 , EducationLevel = @EducationLevel
				 , [Remark] = @Remark
				 , SubGroup = @SubGroup
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
			   AND CandidateNo = @CandidateNo
			   AND FullName = @FullName
		END
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


/*********** Script Update Date: 2022-08-31  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2562x350UnitSummary
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[SaveMPD2562x350UnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @RightCount int = 0
, @ExerciseCount int = 0
, @InvalidCount int = 0
, @NoVoteCount int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
			RETURN
		END
		IF (@RightCount IS NULL) SET @RightCount = 0;
		IF (@ExerciseCount IS NULL) SET @ExerciseCount = 0;
		IF (@InvalidCount IS NULL) SET @InvalidCount = 0;
		IF (@NoVoteCount IS NULL) SET @NoVoteCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562x350UnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2562x350UnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, RightCount
				, ExerciseCount 
				, InvalidCount
				, NoVoteCount
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @RightCount
				, @ExerciseCount 
				, @InvalidCount
				, @NoVoteCount
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562x350UnitSummary
			   SET RightCount = @RightCount
				 , ExerciseCount = @ExerciseCount
				 , InvalidCount = @InvalidCount
				 , NoVoteCount = @NoVoteCount
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		END
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


/*********** Script Update Date: 2022-08-31  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2562PollingUnitSummary
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[SaveMPD2562PollingUnitSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @PollingUnitCount int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter RegionId or ProvinceId is null';
			RETURN
		END
		IF (@PollingUnitCount IS NULL) SET @PollingUnitCount = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562PollingUnitSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
			)
		   )
		BEGIN
			INSERT INTO MPD2562PollingUnitSummary
			(
				  ProvinceName
				, PollingUnitNo
				, PollingUnitCount
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @PollingUnitCount
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562PollingUnitSummary
			   SET PollingUnitCount = @PollingUnitCount
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		END
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


/*********** Script Update Date: 2022-08-31  ***********/
DELETE FROM [MTitle]
GO

INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (1, N'เด็กชาย', N'ด.ช.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2, N'เด็กหญิง', N'ด.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (3, N'นาย', N'นาย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (4, N'นางสาว', N'น.ส.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (5, N'นาง', N'นาง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (6, N'นักโทษชายหม่อมหลวง', N'น.ช.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (7, N'นักโทษชาย', N'น.ช.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (8, N'นักโทษหญิง', N'น.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (9, N'นักโทษชายจ่าสิบเอก', N'น.ช.จ.ส.อ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (10, N'นักโทษชายจ่าเอก', N'น.ช.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (11, N'นักโทษชายพลทหาร', N'น.ช.พลฯ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (12, N'นักโทษชายร้อยตรี', N'น.ช.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (99, N'พระเจ้าหลานเธอ พระองค์เจ้า', N'พระเจ้าหลานเธอ พระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (100, N'พระบาทสมเด็จพระเจ้าอยู่หัว', N'พระบาทสมเด็จพระเจ้าอยู่หัว', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (101, N'สมเด็จพระนางเจ้า', N'สมเด็จพระนางเจ้า', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (102, N'สมเด็จพระศรีนครินทราบรมราชชนนี', N'สมเด็จพระศรีนครินทราบรมราชชนนี', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (103, N'พลโทสมเด็จพระบรมโอรสาธิราช', N'พลโทสมเด็จพระบรมโอรสาธิราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (104, N'พลตรีสมเด็จพระเทพรัตนราชสุดา', N'พลตรีสมเด็จพระเทพรัตนราชสุดา', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (105, N'พระเจ้าวรวงศ์เธอพระองค์หญิง', N'พระเจ้าวรวงศ์เธอพระองค์หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (106, N'พระเจ้าวรวงศ์เธอ พระองค์เจ้า', N'พระเจ้าวรวงศ์เธอ พระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (107, N'สมเด็จพระราชชนนี', N'สมเด็จพระราชชนนี', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (108, N'สมเด็จพระเจ้าพี่นางเธอเจ้าฟ้า', N'สมเด็จพระเจ้าพี่นางเธอเจ้าฟ้า', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (109, N'สมเด็จพระ', N'สมเด็จพระ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (110, N'สมเด็จพระเจ้าลูกเธอ', N'สมเด็จพระเจ้าลูกเธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (111, N'สมเด็จพระเจ้าลูกยาเธอ', N'สมเด็จพระเจ้าลูกยาเธอ', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (112, N'สมเด็จเจ้าฟ้า', N'สมเด็จเจ้าฟ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (113, N'พระเจ้าบรมวงศ์เธอ', N'พระเจ้าบรมวงศ์เธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (114, N'พระเจ้าวรวงศ์เธอ', N'พระเจ้าวรวงศ์เธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (115, N'พระเจ้าหลานเธอ', N'พระเจ้าหลานเธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (116, N'พระเจ้าหลานยาเธอ', N'พระเจ้าหลานยาเธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (117, N'พระวรวงศ์เธอ', N'พระวรวงศ์เธอ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (118, N'สมเด็จพระเจ้าภคินีเธอ', N'สมเด็จพระเจ้าภคินีเธอ', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (119, N'พระองค์เจ้า', N'พระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (120, N'หม่อมเจ้า', N'ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (121, N'หม่อมราชวงศ์', N'ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (122, N'หม่อมหลวง', N'ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (123, N'พระยา', N'พระยา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (124, N'หลวง', N'หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (125, N'ขุน', N'ขุน', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (126, N'หมื่น', N'หมื่น', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (127, N'เจ้าคุณ', N'เจ้าคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (128, N'พระวรวงศ์เธอพระองค์เจ้า', N'พระวรวงศ์เธอพระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (129, N'คุณ', N'คุณ', 0)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (130, N'คุณหญิง', N'คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (131, N'ท่านผู้หญิงหม่อมหลวง', N'ท่านผู้หญิง ม.ล.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (132, N'ศาสตราจารย์นายแพทย์', N'ศจ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (133, N'แพทย์หญิงคุณหญิง', N'พ.ญ.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (134, N'นายแพทย์', N'น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (135, N'แพทย์หญิง', N'พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (136, N'ทัณตแพทย์', N'ท.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (137, N'ทัณตแพทย์หญิง', N'ท.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (138, N'สัตวแพทย์', N'สพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (139, N'สัตวแพทย์หญิง', N'สญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (140, N'ดอกเตอร์', N'ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (141, N'ผู้ช่วยศาสตราจารย์', N'ผศ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (142, N'รองศาสตราจารย์', N'รศ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (143, N'ศาสตราจารย์', N'ศจ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (144, N'เภสัชกรชาย', N'ภก.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (145, N'เภสัชกรหญิง', N'ภญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (146, N'หม่อม', N'หม่อม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (147, N'รองอำมาตย์เอก', N'รองอำมาตย์เอก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (148, N'ท้าว', N'ท้าว', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (149, N'เจ้า', N'เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (150, N'ท่านผู้หญิง', N'ท่านผู้หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (151, N'คุณพระ', N'คุณพระ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (152, N'ศาสตราจารย์คุณหญิง', N'ศจ.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (153, N'ซิสเตอร์', N'ซิสเตอร์', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (154, N'เจ้าชาย', N'เจ้าชาย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (155, N'เจ้าหญิง', N'เจ้าหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (156, N'รองเสวกตรี', N'รองเสวกตรี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (157, N'เสด็จเจ้า', N'เสด็จเจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (158, N'เอกอัครราชฑูต', N'เอกอัครราชฑูต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (159, N'พลสารวัตร', N'พลสารวัตร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (160, N'สมเด็จเจ้า', N'สมเด็จเจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (161, N'เจ้าฟ้า', N'เจ้าฟ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (162, N'รองอำมาตย์ตรี', N'รองอำมาตย์ตรี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (163, N'หม่อมเจ้าหญิง', N'ม.จ.หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (164, N'ทูลกระหม่อม', N'ทูลกระหม่อม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (165, N'ศาสตราจารย์ดอกเตอร์', N'ศ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (166, N'เจ้านาง', N'เจ้านาง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (167, N'จ่าสำรอง', N'จ่าสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (200, N'พลเอก', N'พล.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (201, N'ว่าที่พลเอก', N'ว่าที่ พล.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (202, N'พลโท', N'พล.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (204, N'พลตรี', N'พล.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (205, N'ว่าที่พลตรี', N'ว่าที่ พล.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (206, N'พันเอกพิเศษ', N'พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (207, N'ว่าที่พันเอกพิเศษ', N'ว่าที่ พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (208, N'พันเอก', N'พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (209, N'ว่าที่พันเอก', N'ว่าที่ พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (210, N'พันโท', N'พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (211, N'ว่าที่พันโท', N'ว่าที่ พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (212, N'พันตรี', N'พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (213, N'ว่าที่พันตรี', N'ว่าที่ พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (214, N'ร้อยเอก', N'ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (215, N'ว่าที่ร้อยเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (216, N'ร้อยโท', N'ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (217, N'ว่าที่ร้อยโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (218, N'ร้อยตรี', N'ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (219, N'ว่าที่ร้อยตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (220, N'จ่าสิบเอก', N'จ.ส.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (221, N'จ่าสิบโท', N'จ.ส.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (222, N'จ่าสิบตรี', N'จ.ส.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (223, N'สิบเอก', N'ส.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (224, N'สิบโท', N'ส.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (225, N'สิบตรี', N'ส.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (226, N'พลทหาร', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (227, N'นักเรียนนายร้อย', N'นนร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (228, N'นักเรียนนายสิบ', N'นนส.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (229, N'พลจัตวา', N'พล.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (230, N'พลฯ อาสาสมัคร', N'พลฯ อาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (231, N'ร้อยเอกหม่อมเจ้า', N'ร.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (232, N'พลโทหม่อมเจ้า', N'พล.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (233, N'ร้อยตรีหม่อมเจ้า', N'ร.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (234, N'ร้อยโทหม่อมเจ้า', N'ร.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (235, N'พันโทหม่อมเจ้า', N'พ.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (236, N'พันเอกหม่อมเจ้า', N'พ.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (237, N'พันตรีหม่อมราชวงศ์', N'พ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (238, N'พันโทหม่อมราชวงศ์', N'พ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (239, N'สิบตรีหม่อมราชวงศ์', N'ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (240, N'พันเอกหม่อมราชวงศ์', N'พ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (241, N'จ่าสิบเอกหม่อมราชวงศ์', N'จ.ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (242, N'ร้อยเอกหม่อมราชวงศ์', N'ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (243, N'ร้อยตรีหม่อมราชวงศ์', N'ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (244, N'สิบเอกหม่อมราชวงศ์', N'ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (245, N'ร้อยโทหม่อมราชวงศ์', N'ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (246, N'พันเอก(พิเศษ)หม่อมราชวงศ์', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (247, N'พลฯหม่อมหลวง', N'พลฯม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (248, N'ร้อยเอกหม่อมหลวง', N'ร.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (249, N'สิบโทหม่อมหลวง', N'ส.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (250, N'พลโทหม่อมหลวง', N'พล.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (251, N'ร้อยโทหม่อมหลวง', N'ร.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (252, N'ร้อยตรีหม่อมหลวง', N'ร.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (253, N'สิบเอกหม่อมหลวง', N'ส.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (254, N'พลตรีหม่อมหลวง', N'พล.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (255, N'พันตรีหม่อมหลวง', N'พ.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (256, N'พันเอกหม่อมหลวง', N'พ.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (257, N'พันโทหม่อมหลวง', N'พ.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (258, N'จ่าสิบตรีหม่อมหลวง', N'จ.ส.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (259, N'นักเรียนนายร้อยหม่อมหลวง', N'นนร.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (260, N'ว่าที่ร้อยตรีหม่อมหลวง', N'ว่าที่ร.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (261, N'จ่าสิบเอกหม่อมหลวง', N'จ.ส.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (262, N'ร้อยเอกนายแพทย์', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (263, N'ร้อยเอกแพทย์หญิง', N'ร.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (264, N'ร้อยโทนายแพทย์', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (265, N'พันตรีนายแพทย์', N'พ.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (266, N'ว่าที่ร้อยโทนายแพทย์', N'ว่าที่ ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (267, N'พันเอกนายแพทย์', N'พ.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (268, N'ร้อยตรีนายแพทย์', N'ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (269, N'ร้อยโทแพทย์หญิง', N'ร.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (270, N'พลตรีนายแพทย์', N'พล.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (271, N'พันโทนายแพทย์', N'พ.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (272, N'จอมพล', N'จอมพล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (273, N'พันโทหลวง', N'พ.ท.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (274, N'พันตรีพระเจ้าวรวงศ์เธอพระองค์เจ้า', N'พ.ต.พระเจ้าวรวงศ์เธอพระองค์เจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (275, N'ศาสตราจารย์พันเอก', N'ศจ.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (276, N'พันตรีหลวง', N'พ.ต.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (277, N'พลโทหลวง', N'พล.ท.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (278, N'ร้อยโทดอกเตอร์', N'ร.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (279, N'ร้อยเอกดอกเตอร์', N'ร.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (280, N'สารวัตรทหาร', N'ส.ห.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (281, N'ร้อยตรีดอกเตอร์', N'ร.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (282, N'พันตรีคุณหญิง', N'พ.ต.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (283, N'จ่าสิบตรีหม่อมราชวงศ์', N'จ.ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (284, N'พลจัตวาหลวง', N'พล.จ.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (285, N'พลตรีหม่อมราชวงศ์', N'พล.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (286, N'พันตรีพระเจ้าวรวงศ์เธอพระองค์', N'พ.ต.พระเจ้าวรวงศ์เธอพระองค์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (287, N'ท่านผู้หญิงหม่อมราชวงศ์', N'ท่านผู้หญิง ม.ร.ว.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (288, N'ศาสตราจารย์ร้อยเอก', N'ศจ.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (289, N'พันโทคุณหญิง', N'พ.ท.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (290, N'ร้อยตรีแพทย์หญิง', N'ร.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (291, N'พลเอกหม่อมหลวง', N'พล.อ.มล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (292, N'ว่าที่ร้อยตรีหม่อมราชวงศ์', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (293, N'พันเอกหญิงคุณหญิง', N'พ.อ.หญิง คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (294, N'จ่าสิบเอกพิเศษ', N'จ.ส.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (351, N'พลเรือเอก', N'พล.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (352, N'ว่าที่พลเรือเอก', N'ว่าที่ พล.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (353, N'พลเรือโท', N'พล.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (354, N'ว่าที่พลเรือโท', N'ว่าที่ พล.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (355, N'พลเรือตรี', N'พล.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (356, N'ว่าที่พลเรือตรี', N'ว่าที่ พล.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (357, N'นาวาเอกพิเศษ', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (358, N'ว่าที่นาวาเอกพิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (359, N'นาวาเอก', N'น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (360, N'ว่าที่นาวาเอก', N'ว่าที่ น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (361, N'นาวาโท', N'น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (362, N'ว่าที่นาวาโท', N'ว่าที่ น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (363, N'นาวาตรี', N'น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (364, N'ว่าที่นาวาตรี', N'ว่าที่ น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (365, N'เรือเอก', N'ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (366, N'ว่าที่เรือเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (367, N'เรือโท', N'ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (368, N'ว่าที่เรือโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (369, N'เรือตรี', N'ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (370, N'ว่าที่เรือตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (371, N'พันจ่าเอก', N'พ.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (372, N'พันจ่าโท', N'พ.จ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (373, N'พันจ่าตรี', N'พ.จ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (374, N'จ่าเอก', N'จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (375, N'จ่าโท', N'จ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (376, N'จ่าตรี', N'จ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (377, N'พลฯทหารเรือ', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (378, N'นักเรียนนายเรือ', N'นนร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (379, N'นักเรียนจ่าทหารเรือ', N'นรจ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (380, N'พลเรือจัตวา', N'พล.ร.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (381, N'นาวาโทหม่อมเจ้า', N'น.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (382, N'นาวาเอกหม่อมเจ้า', N'น.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (383, N'นาวาตรีหม่อมเจ้า', N'น.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (384, N'พลเรือตรีหม่อมราชวงศ์', N'พล.ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (385, N'นาวาเอกหม่อมราชวงศ์', N'น.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (386, N'นาวาโทหม่อมราชวงศ์', N'น.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (387, N'นาวาตรีหม่อมราชวงศ์', N'น.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (388, N'นาวาโทหม่อมหลวง', N'น.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (389, N'นาวาตรีหม่อมหลวง', N'น.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (390, N'พันจ่าเอกหม่อมหลวง', N'พ.จ.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (391, N'นาวาตรีแพทย์หญิง', N'น.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (392, N'นาวาอากาศเอกหลวง', N'น.อ.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (393, N'พลเรือตรีหม่อมเจ้า', N'พล.ร.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (395, N'นาวาตรีนายแพทย์', N'น.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (396, N'พลเรือตรีหม่อมหลวง', N'พล.ร.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (500, N'พลอากาศเอก', N'พล.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (501, N'ว่าที่พลอากาศเอก', N'ว่าที่ พล.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (502, N'พลอากาศโท', N'พล.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (503, N'ว่าที่พลอากาศโท', N'ว่าที่ พล.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (504, N'พลอากาศตรี', N'พล.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (505, N'ว่าที่พลอากาศตรี', N'ว่าที่ พล.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (506, N'นาวาอากาศเอกพิเศษ', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (507, N'ว่าที่นาวาอากาศเอกพิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (508, N'นาวาอากาศเอก', N'น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (509, N'ว่าที่นาวาอากาศเอก', N'ว่าที่ น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (510, N'นาวาอากาศโท', N'น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (511, N'ว่าที่นาวาอากาศโท', N'ว่าที่ น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (512, N'นาวาอากาศตรี', N'น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (513, N'ว่าที่นาวาอากาศตรี', N'ว่าที่ น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (514, N'เรืออากาศเอก', N'ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (515, N'ว่าที่เรืออากาศเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (516, N'เรืออากาศโท', N'ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (517, N'ว่าที่เรืออากาศโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (518, N'เรืออากาศตรี', N'ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (519, N'ว่าที่เรืออากาศตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (520, N'พันจ่าอากาศเอก', N'พ.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (521, N'พันจ่าอากาศโท', N'พ.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (522, N'พันจ่าอากาศตรี', N'พ.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (523, N'จ่าอากาศเอก', N'จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (524, N'จ่าอากาศโท', N'จ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (525, N'จ่าอากาศตรี', N'จ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (526, N'พลฯทหารอากาศ', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (527, N'นักเรียนนายเรืออากาศ', N'นนอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (528, N'นักเรียนจ่าอากาศ', N'นจอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (529, N'นักเรียนพยาบาลทหารอากาศ', N'น.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (530, N'พันอากาศเอกหม่อมราชวงศ์', N'พ.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (531, N'พลอากาศตรีหม่อมราชวงศ์', N'พล.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (532, N'พลอากาศโทหม่อมหลวง', N'พล.อ.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (533, N'เรืออากาศโทขุน', N'ร.ท.ขุน', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (534, N'พันจ่าอากาศเอกหม่อมหลวง', N'พ.อ.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (535, N'เรืออากาศเอกนายแพทย์', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (536, N'พลอากาศเอกหม่อมราชวงศ์', N'พล.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (537, N'พลอากาศตรีหม่อมหลวง', N'พล.อ.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (538, N'พลอากาศจัตวา', N'พล.อ.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (539, N'พลอากาศโทหม่อมราชวงศ์', N'พล.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (540, N'นาวาอากาศเอกหม่อมหลวง', N'น.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (606, N'พระครูพิบูลสมณธรรม', N'พระครูพิบูลสมณธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (651, N'พลตำรวจเอก', N'พล.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (652, N'ว่าที่พลตำรวจเอก', N'ว่าที่ พล.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (653, N'พลตำรวจโท', N'พล.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (654, N'ว่าที่พลตำรวจโท', N'ว่าที่ พล.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (655, N'พลตำรวจตรี', N'พล.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (656, N'ว่าที่พลตำรวจตรี', N'ว่าที่ พล.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (657, N'พลตำรวจจัตวา', N'พล.ต.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (658, N'ว่าที่พลตำรวจจัตวา', N'ว่าที่พล.ต.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (659, N'พันตำรวจเอก (พิเศษ)', N'พ.ต.อ. (พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (660, N'ว่าที่พันตำรวจเอก(พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (661, N'พันตำรวจเอก', N'พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (662, N'ว่าที่พันตำรวจเอก', N'ว่าที่ พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (663, N'พันตำรวจโท', N'พ.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (664, N'ว่าที่พันตำรวจโท', N'ว่าที่ พ.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (665, N'พันตำรวจตรี', N'พ.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (666, N'ว่าที่พันตำรวจตรี', N'ว่าที่ พ.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (667, N'ร้อยตำรวจเอก', N'ร.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (668, N'ว่าที่ร้อยตำรวจเอก', N'ว่าที่ ร.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (669, N'ร้อยตำรวจโท', N'ร.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (670, N'ว่าที่ร้อยตำรวจโท', N'ว่าที่ ร.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (671, N'ร้อยตำรวจตรี', N'ร.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (672, N'ว่าที่ร้อยตำรวจตรี', N'ว่าที่ ร.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (673, N'นายดาบตำรวจ', N'ด.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (674, N'จ่าสิบตำรวจ', N'จ.ส.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (675, N'สิบตำรวจเอก', N'ส.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (676, N'สิบตำรวจโท', N'ส.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (677, N'สิบตำรวจตรี', N'ส.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (678, N'นักเรียนนายร้อยตำรวจ', N'นรต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (679, N'นักเรียนนายสิบตำรวจ', N'นสต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (680, N'นักเรียนพลตำรวจ', N'นพต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (681, N'พลตำรวจ', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (682, N'พลตำรวจพิเศษ', N'พลฯพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (683, N'พลตำรวจอาสาสมัคร', N'พลฯอาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (684, N'พลตำรวจสำรอง', N'พลฯสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (685, N'พลตำรวจสำรองพิเศษ', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (686, N'พลตำรวจสมัคร', N'พลฯสมัคร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (687, N'สมาชิกอาสารักษาดินแดน', N'อส.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (688, N'นายกองใหญ่', N'ก.ญ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (689, N'นายกองเอก', N'ก.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (690, N'นายกองโท', N'ก.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (691, N'นายกองตรี', N'ก.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (692, N'นายหมวดเอก', N'มว.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (693, N'นายหมวดโท', N'มว.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (694, N'นายหมวดตรี', N'มว.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (695, N'นายหมู่ใหญ่', N'ม.ญ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (696, N'นายหมู่เอก', N'ม.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (697, N'นายหมู่โท', N'ม.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (698, N'นายหมู่ตรี', N'ม.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (699, N'สมาชิกเอก', N'สมาชิกเอก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (700, N'สมาชิกโท', N'สมาชิกโท', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (701, N'สมาชิกตรี', N'สมาชิกตรี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (702, N'อาสาสมัครทหารพราน', N'อส.ทพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (703, N'พันตำรวจโทหม่อมเจ้า', N'พ.ต.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (704, N'พันตำรวจเอกหม่อมเจ้า', N'พ.ต.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (705, N'นักเรียนนายร้อยตำรวจหม่อมเจ้า', N'นรต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (706, N'พลตำรวจตรีหม่อมราชวงศ์', N'พล.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (707, N'พันตำรวจตรีหม่อมราชวงศ์', N'พ.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (708, N'พันตำรวจโทหม่อมราชวงศ์', N'พ.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (709, N'พันตำรวจเอกหม่อมราชวงศ์', N'พ.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (710, N'ร้อยตำรวจเอกหม่อมราชวงศ์', N'ร.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (711, N'สิบตำรวจเอกหม่อมหลวง', N'ส.ต.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (712, N'พันตำรวจเอกหม่อมหลวง', N'พ.ต.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (713, N'พันตำรวจโทหม่อมหลวง', N'พ.ต.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (714, N'นักเรียนนายร้อยตำรวจหม่อมหลวง', N'นรต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (715, N'ร้อยตำรวจโทหม่อมหลวง', N'ร.ต.ท.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (716, N'นายดาบตำรวจหม่อมหลวง', N'ด.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (717, N'พันตำรวจตรีหม่อมหลวง', N'พ.ต.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (718, N'ศาสตราจารย์นายแพทย์พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (719, N'พันตำรวจโทนายแพทย์', N'พ.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (720, N'ร้อยตำรวจโทนายแพทย์', N'ร.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (721, N'ร้อยตำรวจเอกนายแพทย์', N'ร.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (722, N'พันตำรวจตรีนายแพทย์', N'พ.ต.ต.นพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (723, N'พันตำรวจเอกนายแพทย์', N'พ.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (724, N'พันตำรวจตรีหลวง', N'พ.ต.ต.หลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (725, N'ร้อยตำรวจโทดอกเตอร์', N'ร.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (726, N'พันตำรวจเอกดอกเตอร์', N'พ.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (727, N'ร้อยตำรวจเอกหม่อมหลวง', N'ร.ต.อ.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (729, N'พันตำรวจเอกหญิง ท่านผู้หญิง', N'พ.ต.อ.หญิง ท่านผู้หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (730, N'พลตำรวจตรีหม่อมหลวง', N'พล.ต.ต.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (731, N'พลตรีหญิง คุณหญิง', N'พล.ต.หญิง คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (732, N'ว่าที่สิบเอก', N'ว่าที่ ส.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (733, N'พลตำรวจเอกดอกเตอร์', N'พล.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (800, N'สมเด็จพระสังฆราชเจ้า', N'สมเด็จพระสังฆราชเจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (801, N'สมเด็จพระสังฆราช', N'สมเด็จพระสังฆราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (802, N'สมเด็จพระราชาคณะ', N'สมเด็จพระราชาคณะ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (803, N'รองสมเด็จพระราชาคณะ', N'รองสมเด็จพระราชาคณะ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (804, N'พระราชาคณะ', N'พระราชาคณะ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (805, N'พระเปรียญธรรม', N'พระเปรียญธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (806, N'พระหิรัญยบัฏ', N'พระหิรัญยบัฏ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (807, N'พระสัญญาบัตร', N'พระสัญญาบัตร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (808, N'พระราช', N'พระราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (809, N'พระเทพ', N'พระเทพ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (810, N'พระปลัดขวา', N'พระปลัดขวา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (811, N'พระปลัดซ้าย', N'พระปลัดซ้าย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (812, N'พระครูปลัด', N'พระครูปลัด', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (813, N'พระครูปลัดสุวัฒนญาณคุณ', N'พระครูปลัดสุวัฒนญาณคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (814, N'พระครูปลัดอาจารย์วัฒน์', N'พระครูปลัดอาจารย์วัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (815, N'พระครูวิมลสิริวัฒน์', N'พระครูปลัดวิมลสิริวัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (816, N'พระสมุห์', N'พระสมุห์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (817, N'พระครูสมุห์', N'พระครูสมุห์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (818, N'พระครู', N'พระครู', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (819, N'พระครูใบฎีกา', N'พระครูใบฎีกา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (820, N'พระครูธรรมธร', N'พระครูธรรมธร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (821, N'พระครูวิมลภาณ', N'พระครูวิมลภาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (822, N'พระครูศัพทมงคล', N'พระครูศัพทมงคล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (823, N'พระครูสังฆภารวิชัย', N'พระครูสังฆภารวิชัย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (824, N'พระครูสังฆรักษ์', N'พระครูสังฆรักษ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (825, N'พระครูสังฆวิชัย', N'พระครูสังฆวิชัย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (826, N'พระครูสังฆวิชิต', N'พระครูสังฆวิชิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (827, N'พระปิฎก', N'พระปิฎก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (828, N'พระปริยัติ', N'พระปริยัติ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (829, N'เจ้าอธิการ', N'เจ้าอธิการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (830, N'พระอธิการ', N'พระอธิการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (831, N'พระ', N'พระ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (832, N'สามเณร', N'ส.ณ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (833, N'พระปลัด', N'พระปลัด', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (834, N'สมเด็จพระอริยวงศาคตญาณ', N'สมเด็จพระอริยวงศาคตญาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (835, N'พระคาร์ดินัล', N'พระคาร์ดินัล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (836, N'พระสังฆราช', N'พระสังฆราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (837, N'พระคุณเจ้า', N'พระคุณเจ้า', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (838, N'บาทหลวง', N'บาทหลวง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (839, N'พระมหา', N'พระมหา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (840, N'พระราชปัญญา', N'พระราชปัญญา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (841, N'ภาราดา', N'ภาราดา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (842, N'พระศรีปริยัติธาดา', N'พระศรีปริยัติธาดา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (843, N'พระญาณโศภณ', N'พระญาณโศภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (844, N'สมเด็จพระมหาวีรวงศ์', N'สมเด็จพระมหาวีรวงศ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (845, N'พระโสภณธรรมาภรณ์', N'พระโสภณธรรมาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (846, N'พระวิริวัฒน์วิสุทธิ์', N'พระวิริวัฒน์วิสุทธิ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (847, N'พระญาณ', N'พระญาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (848, N'พระอัครสังฆราช', N'พระอัครสังฆราช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (849, N'พระธรรม', N'พระธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (850, N'พระสาสนโสภณ', N'พระสาสนโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (851, N'พระธรรมโสภณ', N'พระธรรมโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (852, N'พระอุดมสารโสภณ', N'พระอุดมสารโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (853, N'พระครูวิมลญาณโสภณ', N'พระครูวิมลญาณโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (854, N'พระครูปัญญาภรณโสภณ', N'พระครูปัญญาภรณโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (855, N'พระครูโสภณปริยัติคุณ', N'พระครูโสภณปริยัติคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (856, N'พระอธิธรรม', N'พระอธิธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (857, N'พระราชญาณ', N'พระราชญาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (858, N'พระสุธีวัชโรดม', N'พระสุธีวัชโรดม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (859, N'รองเจ้าอธิการ', N'รองเจ้าอธิการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (860, N'พระครูวินัยธร', N'พระครูวินัยธร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (861, N'พระศรีวชิราภรณ์', N'พระศรีวชิราภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (862, N'พระราชบัณฑิต', N'พระราชบัณฑิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (863, N'แม่ชี', N'แม่ชี', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (864, N'นักบวช', N'นักบวช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (865, N'พระรัตน', N'พระรัตน', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (866, N'พระโสภณปริยัติธรรม', N'พระโสภณปริยัติธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (867, N'พระครูวิศาลปัญญาคุณ', N'พระครูวิศาลปัญญาคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (868, N'พระศรีปริยัติโมลี', N'พระศรีปริยัติโมลี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (869, N'พระครูวัชรสีลาภรณ์', N'พระครูวัชรสีลาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (870, N'พระครูพิพัฒน์บรรณกิจ', N'พระครูพิพัฒน์บรรณกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (871, N'พระครูวิบูลธรรมกิจ', N'พระครูวิบูลธรรมกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (872, N'พระครูพัฒนสารคุณ', N'พระครูพัฒนสารคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (873, N'พระครูสุวรรณพัฒนคุณ', N'พระครูสุวรรณพัฒนคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (874, N'พระครูพรหมวีรสุนทร', N'พระครูพรหมวีรสุนทร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (875, N'พระครูอุปถัมภ์นันทกิจ', N'พระครูอุปถัมภ์นันทกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (876, N'พระครูวิจารณ์สังฆกิจ', N'พระครูวิจารณ์สังฆกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (877, N'พระครูวิมลสารวิสุทธิ์', N'พระครูวิมลสารวิสุทธิ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (878, N'พระครูไพศาลศุภกิจ', N'พระครูไพศาลศุภกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (879, N'พระครูโอภาสธรรมพิมล', N'พระครูโอภาสธรรมพิมล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (880, N'พระครูพิพิธวรคุณ', N'พระครูพิพิธวรคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (881, N'พระครูสุนทรปภากร', N'พระครูสุนทรปภากร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (882, N'พระครูสิริชัยสถิต', N'พระครูสิริชัยสถิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (883, N'พระครูเกษมธรรมานันท์', N'พระครูเกษมธรรมานันท์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (884, N'พระครูถาวรสันติคุณ', N'พระครูถาวรสันติคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (885, N'พระครูวิสุทธาจารวิมล', N'พระครูวิสุทธาจารวิมล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (886, N'พระครูปภัสสราธิคุณ', N'พระครูปภัสสราธิคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (887, N'พระครูวรสังฆกิจ', N'พระครูวรสังฆกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (888, N'พระครูไพบูลชัยสิทธิ์', N'พระครูไพบูลชัยสิทธิ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (889, N'พระครูโกวิทธรรมโสภณ', N'พระครูโกวิทธรรมโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (890, N'พระครูสุพจน์วราภรณ์', N'พระครูสุพจน์วราภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (891, N'พระครูไพโรจน์อริญชัย', N'พระครูไพโรจน์อริญชัย', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (892, N'พระครูสุนทรคณาภิรักษ์', N'พระครูสุนทรคณาภิรักษ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (893, N'พระสรภาณโกศล', N'พระสรภาณโกศล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (894, N'พระครูประโชติธรรมรัตน์', N'พระครูประโชติธรรมรัตน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (895, N'พระครูจารุธรรมกิตติ์', N'พระครูจารุธรรมกิตติ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (896, N'พระครูพิทักษ์พรหมรังษี', N'พระครูพิทักษ์พรหมรังษี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (897, N'พระศรีปริยัติบัณฑิต', N'พระศรีปริยัติบัณฑิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (898, N'พระครูพุทธิธรรมานุศาสน์', N'พระครูพุทธิธรรมานุศาสน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (899, N'พระธรรมเมธาจารย์', N'พระธรรมเมธาจารย์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (900, N'พระครูกิตติกาญจนวงศ์', N'พระครูกิตติกาญจนวงศ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (901, N'พระครูปลัดสัมพิพัฒนวิริยาจารย์', N'พระครูปลัดสัมพิพัฒนวิริยาจารย์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (902, N'พระครูศีลกันตาภรณ์', N'พระครูศีลกันตาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (903, N'พระครูประกาศพุทธพากย์', N'พระครูประกาศพุทธพากย์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (904, N'พระครูอมรวิสุทธิคุณ', N'พระครูอมรวิสุทธิคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (905, N'พระครูสุทัศน์ธรรมาภิรม', N'พระครูสุทัศน์ธรรมาภิรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (906, N'พระครูอุปถัมภ์วชิโรภาส', N'พระครูอุปถัมภ์วชิโรภาส', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (907, N'พระครูสุนทรสมณคุณ', N'พระครูสุนทรสมณคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (908, N'พระพรหมมุนี', N'พระพรหมมุนี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (909, N'พระครูสิริคุณารักษ์', N'พระครูสิริคุณารักษ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (910, N'พระครูวิชิตพัฒนคุณ', N'พระครูวิชิตพัฒนคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (911, N'พระครูพิบูลโชติธรรม', N'พระครูพิบูลโชติธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (912, N'พระพิศาลสารคุณ', N'พระพิศาลสารคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (913, N'พระรัตนมงคลวิสุทธ์', N'พระรัตนมงคลวิสุทธ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (914, N'พระครูโสภณคุณานุกูล', N'พระครูโสภณคุณานุกูล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (915, N'พระครูผาสุกวิหารการ', N'พระครูผาสุกวิหารการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (916, N'พระครูวชิรวุฒิกร', N'พระครูวชิรวุฒิกร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (917, N'พระครูกาญจนยติกิจ', N'พระครูกาญจนยติกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (918, N'พระครูบวรรัตนวงศ์', N'พระครูบวรรัตนวงศ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (919, N'พระราชพัชราภรณ์', N'พระราชพัชราภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (920, N'พระครูพิพิธอุดมคุณ', N'พระครูพิพิธอุดมคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (921, N'องสุตบทบวร', N'องสุตบทบวร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (922, N'พระครูจันทเขมคุณ', N'พระครูจันทเขมคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (923, N'พระครูศีลสารวิสุทธิ์', N'พระครูศีลสารวิสุทธิ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (924, N'พระครูสุธรรมโสภิต', N'พระครูสุธรรมโสภิต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (925, N'พระครูอุเทศธรรมนิวิฐ', N'พระครูอุเทศธรรมนิวิฐ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (926, N'พระครูบรรณวัตร', N'พระครูบรรณวัตร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (927, N'พระครูวิสุทธาจาร', N'พระครูวิสุทธาจาร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (928, N'พระครูสุนทรวรวัฒน์', N'พระครูสุนทรวรวัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (929, N'พระเทพชลธารมุนี ศรีชลบุราจารย์', N'พระเทพชลธารมุนี ศรีชลบุราจารย์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (930, N'พระครูโสภณสมุทรคุณ', N'พระครูโสภณสมุทรคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (931, N'พระราชเมธาภรณ์', N'พระราชเมธาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (932, N'พระครูศรัทธาธรรมโสภณ', N'พระครูศรัทธาธรรมโสภณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (933, N'พระครูสังฆบริรักษ์', N'พระครูสังฆบริรักษ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (934, N'พระมหานายก', N'พระมหานายก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (935, N'พระครูโอภาสสมาจาร', N'พระครูโอภาสสมาจาร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (936, N'พระครูศรีธวัชคุณาภรณ์', N'พระครูศรีธวัชคุณาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (937, N'พระครูโสภิตวัชรกิจ', N'พระครูโสภิตวัชรกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (938, N'พระราชวชิราภรณ์', N'พระราชวชิราภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (939, N'พระครูสุนทรวรธัช', N'พระครูสุนทรวรธัช', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (940, N'พระครูอาทรโพธิกิจ', N'พระครูอาทรโพธิกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (941, N'พระครูวิบูลกาญจนกิจ', N'พระครูวิบูลกาญจนกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (942, N'พระพรหมวชิรญาณ', N'พระพรหมวชิรญาณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (943, N'พระครูสุพจน์วรคุณ', N'พระครูสุพจน์วรคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (944, N'พระราชาวิมลโมลี', N'พระราชวิมลโมลี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (945, N'พระครูอมรธรรมนายก', N'พระครูอมรธรรมนายก', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (946, N'พระครูพิศิษฎ์ศาสนการ', N'พระครูพิศิษฎ์ศาสนการ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (947, N'พระครูเมธีธรรมานุยุต', N'พระครูเมธีธรรมานุยุต', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (948, N'พระครูปิยสีลสาร', N'พระครูปิยสีลสาร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (949, N'พระครูสถิตบุญวัฒน์', N'พระครูสถิตบุญวัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (950, N'พระครูนิเทศปิยธรรม', N'พระครูนิเทศปิยธรรม', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (951, N'พระครูวิสุทธิ์กิจจานุกูล', N'พระครูวิสุทธิ์กิจจานุกูล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (952, N'พระครูสถิตย์บุญวัฒน์', N'พระครูสถิตย์บุญวัฒน์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (953, N'พระครูประโชติธรรมานุกูล', N'พระครูประโชติธรรมานุกูล', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (954, N'พระเทพญาณกวี', N'พระเทพญาณกวี', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (955, N'พระครูพิพัฒน์ชินวงศ์', N'พระครูพิพัฒน์ชินวงศ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (956, N'พระครูสมุทรขันตยาภรณ์', N'พระครูสมุทรขันตยาภรณ์', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (957, N'พระครูภาวนาวรกิจ', N'พระครูภาวนาวรกิจ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (958, N'พระครูศรีศาสนคุณ', N'พระครูศรีศาสนคุณ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (959, N'พระครูวิบูลย์ธรรมศาสก์', N'พระครูวิบูลย์ธรรมศาสก์', 1)
GO


/*********** Script Update Date: 2022-08-31  ***********/
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2001, N'นักโทษชาย หม่อมหลวง', N'น.ช.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2002, N'น.ช. หม่อมหลวง', N'น.ช.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2003, N'น.ช. ม.ล.', N'น.ช.ม.ล.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2004, N'นักโทษ ชาย', N'น.ช.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2005, N'นักโทษ หญิง', N'น.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2006, N'นักโทษชาย จ่าสิบเอก', N'น.ช.จ.ส.อ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2007, N'นักโทษชาย จ.ส.อ.', N'น.ช.จ.ส.อ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2008, N'น.ช.จ่าสิบเอก', N'น.ช.จ.ส.อ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2009, N'น.ช. จ่าสิบเอก', N'น.ช.จ.ส.อ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2010, N'น.ช. จ.ส.อ.', N'น.ช.จ.ส.อ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2011, N'นักโทษชาย จ่าเอก', N'น.ช.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2012, N'นักโทษชาย จ.อ.', N'น.ช.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2013, N'นักโทษ ชาย จ่าเอก', N'น.ช.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2014, N'นักโทษ ชาย จ.อ.', N'น.ช.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2015, N'น.ช.จ่าเอก', N'น.ช.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2016, N'น.ช. จ่าเอก', N'น.ช.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2017, N'น.ช. จ.อ.', N'น.ช.จ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2018, N'นักโทษชาย พลทหาร', N'น.ช.พลฯ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2019, N'นักโทษ ชาย พลทหาร', N'น.ช.พลฯ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2020, N'นักโทษชาย พลฯ', N'น.ช.พลฯ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2021, N'นักโทษ ชาย พลฯ', N'น.ช.พลฯ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2022, N'น.ช. พลทหาร', N'น.ช.พลฯ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2023, N'น.ช. พลฯ', N'น.ช.พลฯ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2024, N'นักโทษชาย ร.ต.', N'น.ช.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2025, N'นักโทษ ชาย ร.ต.', N'น.ช.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2026, N'น.ช. ร้อยตรี', N'น.ช.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2027, N'น.ช. ร.ต.', N'น.ช.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2028, N'ศาสตราจารย์ นายแพทย์', N'ศจ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2029, N'ศาสตราจารย์ น.พ.', N'ศจ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2030, N'ศจ. นายแพทย์', N'ศจ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2031, N'ศจ. น.พ.', N'ศจ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2032, N'แพทย์หญิง คุณหญิง', N'พ.ญ.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2033, N'พ.ญ. คุณหญิง', N'พ.ญ.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2034, N'ทัณตแพทย์ หญิง', N'ท.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2035, N'สัตวแพทย์ หญิง', N'สญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2036, N'ศาสตราจารย์ คุณหญิง', N'ศจ.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2037, N'ศจ. คุณหญิง', N'ศจ.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2038, N'ศ.ดอกเตอร์', N'ศ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2039, N'ศ. ดอกเตอร์', N'ศ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2040, N'ศ. ดร.', N'ศ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2041, N'ว่าที่ พลเอก', N'ว่าที่ พล.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2042, N'ว่าที่พลโท', N'ว่าที่ พล.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2043, N'ว่าที่ พลโท', N'ว่าที่ พล.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2044, N'ว่าที่ พลตรี', N'ว่าที่ พล.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2045, N'พันเอก พิเศษ', N'พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2046, N'พันเอก(พิเศษ)', N'พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2047, N'พันเอก (พิเศษ)', N'พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2048, N'ว่าที่ พันเอก พิเศษ', N'ว่าที่ พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2049, N'ว่าที่ พันเอก(พิเศษ)', N'ว่าที่ พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2050, N'ว่าที่ พันเอก (พิเศษ)', N'ว่าที่ พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2051, N'ว่าที่พ.อ.(พิเศษ)', N'ว่าที่ พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2052, N'ว่าที่ พ.อ. (พิเศษ)', N'ว่าที่ พ.อ.(พิเศษ)', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2053, N'ว่าที่ พันเอก', N'ว่าที่ พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2054, N'ว่าที่ พันโท', N'ว่าที่ พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2055, N'ว่าที่ พันตรี', N'ว่าที่ พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2056, N'ว่าที่ ร้อยเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2057, N'ว่าที่ ร้อยโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2058, N'ว่าที่ ร้อยตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2059, N'พลฯอาสา', N'พลฯ อาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2060, N'พลฯอาสาสมัคร', N'พลฯ อาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2061, N'ร้อยเอก หม่อมเจ้า', N'ร.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2062, N'ร้อยเอก ม.จ.', N'ร.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2063, N'ร.อ. หม่อมเจ้า', N'ร.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2064, N'ร.อ. ม.จ.', N'ร.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2065, N'พลเอกหม่อมเจ้า', N'พล.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2066, N'พล.อ. หม่อมเจ้า', N'พล.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2067, N'พลเอก ม.จ', N'พล.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2069, N'พล.อ.หม่อมเจ้า', N'พล.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2070, N'พล.อ. ม.จ', N'พล.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2071, N'พลโท หม่อมเจ้า', N'พล.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2072, N'พลโท ม.จ.', N'พล.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2073, N'พล.ท. หม่อมเจ้า', N'พล.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2074, N'พล.ท.หม่อมเจ้า', N'พล.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2075, N'พล.ท. ม.จ.', N'พล.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2076, N'พลตรีหม่อมเจ้า', N'พล.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2077, N'พลตรี หม่อมเจ้า', N'พล.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2078, N'พลตรี ม.จ', N'พล.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2079, N'พล.ต. หม่อมเจ้า', N'พล.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2080, N'พล.ต.หม่อมเจ้า', N'พล.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2081, N'พล.ต. ม.จ', N'พล.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2082, N'ร้อยตรี หม่อมเจ้า', N'ร.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2083, N'ร้อยตรี ม.จ.', N'ร.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2084, N'ร.ต. หม่อมเจ้า', N'ร.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2085, N'ร.ต.หม่อมเจ้า', N'ร.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2086, N'ร.ต. ม.จ.', N'ร.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2087, N'ร้อยโท หม่อมเจ้า', N'ร.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2088, N'ร้อยโท ม.จ.', N'ร.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2089, N'ร.ท. หม่อมเจ้า', N'ร.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2090, N'ร.ท.หม่อมเจ้า', N'ร.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2091, N'ร.ท. ม.จ.', N'ร.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2092, N'พันเอก หม่อมเจ้า', N'พ.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2093, N'พันเอก ม.จ.', N'พ.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2094, N'พ.อ. หม่อมเจ้า', N'พ.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2095, N'พ.อ.หม่อมเจ้า', N'พ.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2096, N'พ.อ. ม.จ.', N'พ.อ.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2097, N'พันโท หม่อมเจ้า', N'พ.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2098, N'พันโท ม.จ.', N'พ.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2099, N'พ.ท. หม่อมเจ้า', N'พ.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2100, N'พ.ท.หม่อมเจ้า', N'พ.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2101, N'พ.ท. ม.จ.', N'พ.ท.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2102, N'พันตรีหม่อมเจ้า', N'พ.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2103, N'พันตรี หม่อมเจ้า', N'พ.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2104, N'พันตรี ม.จ.', N'พ.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2105, N'พ.ต. หม่อมเจ้า', N'พ.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2106, N'พ.ต.หม่อมเจ้า', N'พ.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2107, N'พ.ต. ม.จ.', N'พ.ต.ม.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2108, N'พันเอก หม่อมราชวงศ์', N'พ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2109, N'พันเอก ม.ร.ว.', N'พ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2110, N'พ.อ.หม่อมราชวงศ์', N'พ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2111, N'พ.อ. ม.ร.ว.', N'พ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2112, N'พันโท หม่อมราชวงศ์', N'พ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2113, N'พันโท ม.ร.ว.', N'พ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2114, N'พ.ท.หม่อมราชวงศ์', N'พ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2115, N'พ.ท. ม.ร.ว.', N'พ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2116, N'พันตรี หม่อมราชวงศ์', N'พ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2117, N'พันตรี ม.ร.ว.', N'พ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2118, N'พ.ต.หม่อมราชวงศ์', N'พ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2119, N'พ.ต. ม.ร.ว.', N'พ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2120, N'สิบเอก ม.ร.ว.', N'ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2121, N'สิบเอก หม่อมราชวงศ์', N'ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2122, N'ส.อ.หม่อมราชวงศ์', N'ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2123, N'ส.อ. ม.ร.ว.', N'ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2124, N'สิบโทหม่อมราชวงศ์', N'ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2125, N'สิบโท หม่อมราชวงศ์', N'ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2126, N'สิบโท ม.ร.ว.', N'ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2127, N'ส.ท. หม่อมราชวงศ์', N'ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2128, N'ส.ท. ม.ร.ว.', N'ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2129, N'สิบตรี หม่อมราชวงศ์', N'ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2130, N'สิบตรี ม.ร.ว.', N'ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2131, N'ส.ต.หม่อมราชวงศ์', N'ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2132, N'ส.ต. ม.ร.ว.', N'ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2133, N'จ่าสิบเอก หม่อมราชวงศ์', N'จ.ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2134, N'จ่าสิบเอก ม.ร.ว.', N'จ.ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2135, N'จ.ส.อ.หม่อมราชวงศ์', N'จ.ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2136, N'จ.ส.อ. ม.ร.ว.', N'จ.ส.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2137, N'จ่าสิบโทหม่อมราชวงศ์', N'จ.ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2138, N'จ่าสิบโท หม่อมราชวงศ์', N'จ.ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2139, N'จ่าสิบโท ม.ร.ว.', N'จ.ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2140, N'จ.ส.ท.หม่อมราชวงศ์', N'จ.ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2141, N'จ.ส.ท. ม.ร.ว.', N'จ.ส.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2142, N'จ่าสิบตรี หม่อมราชวงศ์', N'จ.ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2143, N'จ่าสิบตรี ม.ร.ว.', N'จ.ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2144, N'จ.ส.ต.หม่อมราชวงศ์', N'จ.ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2145, N'จ.ส.ต. ม.ร.ว.', N'จ.ส.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2146, N'ร้อยเอก หม่อมราชวงศ์', N'ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2147, N'ร้อยเอก ม.ร.ว.', N'ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2148, N'ร.อ.หม่อมราชวงศ์', N'ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2149, N'ร.อ. ม.ร.ว.', N'ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2150, N'ร้อยโท หม่อมราชวงศ์', N'ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2151, N'ร้อยโท ม.ร.ว.', N'ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2152, N'ร.ท.หม่อมราชวงศ์', N'ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2153, N'ร.ท. ม.ร.ว.', N'ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2154, N'ร้อยตรี หม่อมราชวงศ์', N'ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2155, N'ร้อยตรี ม.ร.ว.', N'ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2156, N'ร.ต.หม่อมราชวงศ์', N'ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2157, N'ร.ต. ม.ร.ว.', N'ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2244, N'ว่าที่ร้อยตรี หม่อมราชวงศ์', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2245, N'ว่าที่ ร้อยตรี หม่อมราชวงศ์', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2246, N'ว่าที่ร้อยตรี ม.ร.ว.', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2247, N'ว่าที่ ร้อยตรี ม.ร.ว.', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2248, N'ว่าที่ ร.ต. หม่อมราชวงศ์', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2249, N'ว่าที่ ร.ต.หม่อมราชวงศ์', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2251, N'ว่าที่ร.ต.หม่อมราชวงศ์', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2252, N'ว่าที่ร.ต. หม่อมราชวงศ์', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2253, N'ว่าที่ ร.ต. ม.ร.ว.', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2254, N'ว่าที่ร.ต. ม.ร.ว.', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2255, N'ว่าที่ร.ต.ม.ร.ว.', N'ว่าที่ ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2256, N'พันเอก (พิเศษ)หม่อมราชวงศ์', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2257, N'พันเอก (พิเศษ) หม่อมราชวงศ์', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2258, N'พันเอก(พิเศษ) หม่อมราชวงศ์', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2259, N'พ.อ.(พิเศษ) หม่อมราชวงศ์', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2260, N'พ.อ. (พิเศษ) หม่อมราชวงศ์', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2261, N'พ.อ. (พิเศษ)หม่อมราชวงศ์', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2262, N'พ.อ.(พิเศษ) ม.ร.ว.', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2263, N'พ.อ. (พิเศษ) ม.ร.ว.', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2264, N'พ.อ. (พิเศษ)ม.ร.ว.', N'พ.อ.(พิเศษ)ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2265, N'ท่านผู้หญิง หม่อมราชวงศ์', N'ท่านผู้หญิง ม.ร.ว.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2266, N'ท่านผู้หญิงม.ร.ว.', N'ท่านผู้หญิง ม.ร.ว.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2267, N'พลเรือเอกหม่อมราชวงศ์', N'พล.ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2268, N'พลเรือเอก หม่อมราชวงศ์', N'พล.ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2269, N'พลเรือเอก ม.ร.ว.', N'พล.ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2270, N'พล.ร.อ. ม.ร.ว.', N'พล.ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2271, N'พล.ร.อ.หม่อมราชวงศ์', N'พล.ร.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2272, N'พลเรือโทหม่อมราชวงศ์', N'พล.ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2273, N'พลเรือโท หม่อมราชวงศ์', N'พล.ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2274, N'พลเรือโท ม.ร.ว.', N'พล.ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2275, N'พล.ร.ท. หม่อมราชวงศ์', N'พล.ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2276, N'พล.ร.ท. ม.ร.ว.', N'พล.ร.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2277, N'พลเรือตรี หม่อมราชวงศ์', N'พล.ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2278, N'พลเรือตรี ม.ร.ว.', N'พล.ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2279, N'พล.ร.ต.หม่อมราชวงศ์', N'พล.ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2280, N'พล.ร.ต. ม.ร.ว.', N'พล.ร.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2281, N'นาวาเอก หม่อมราชวงศ์', N'น.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2282, N'นาวาเอก ม.ร.ว.', N'น.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2283, N'น.อ.หม่อมราชวงศ์', N'น.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2284, N'น.อ. ม.ร.ว.', N'น.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2285, N'นาวาโท หม่อมราชวงศ์', N'น.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2286, N'นาวาโท ม.ร.ว.', N'น.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2287, N'น.ท.หม่อมราชวงศ์', N'น.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2288, N'น.ท. ม.ร.ว.', N'น.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2289, N'นาวาตรี หม่อมราชวงศ์', N'น.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2290, N'นาวาตรี ม.ร.ว.', N'น.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2291, N'น.ต.หม่อมราชวงศ์', N'น.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2292, N'น.ต. ม.ร.ว.', N'น.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2293, N'พันอากาศเอก หม่อมราชวงศ์', N'พ.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2294, N'พันอากาศเอก ม.ร.ว.', N'พ.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2295, N'พ.อ.อ.หม่อมราชวงศ์', N'พ.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2296, N'พ.อ.อ. ม.ร.ว.', N'พ.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2297, N'พันอากาศโทหม่อมราชวงศ์', N'พ.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2298, N'พันอากาศโท หม่อมราชวงศ์', N'พ.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2299, N'พันอากาศโท ม.ร.ว.', N'พ.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2300, N'พ.อ.ท.หม่อมราชวงศ์', N'พ.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2301, N'พ.อ.ท. ม.ร.ว.', N'พ.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2302, N'พันอากาศตรีหม่อมราชวงศ์', N'พ.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2303, N'พันอากาศตรี หม่อมราชวงศ์', N'พ.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2304, N'พันอากาศตรี ม.ร.ว.', N'พ.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2305, N'พ.อ.ต.หม่อมราชวงศ์', N'พ.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2306, N'พ.อ.ต. ม.ร.ว.', N'พ.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2307, N'พลอากาศเอก หม่อมราชวงศ์', N'พล.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2308, N'พลอากาศเอก ม.ร.ว.', N'พล.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2309, N'พล.อ.อ.หม่อมราชวงศ์', N'พล.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2310, N'พล.อ.อ. ม.ร.ว.', N'พล.อ.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2311, N'พลอากาศโท หม่อมราชวงศ์', N'พล.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2312, N'พลอากาศโท ม.ร.ว.', N'พล.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2313, N'พล.อ.ท.หม่อมราชวงศ์', N'พล.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2314, N'พล.อ.ท. ม.ร.ว.', N'พล.อ.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2315, N'พลอากาศตรี หม่อมราชวงศ์', N'พล.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2316, N'พลอากาศตรี ม.ร.ว.', N'พล.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2317, N'พล.อ.ต.หม่อมราชวงศ์', N'พล.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2318, N'พล.อ.ต. ม.ร.ว.', N'พล.อ.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2319, N'พันตำรวจตรี หม่อมราชวงศ์', N'พ.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2320, N'พันตำรวจตรี ม.ร.ว.', N'พ.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2321, N'พ.ต.ต.หม่อมราชวงศ์', N'พ.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2322, N'พ.ต.ต. ม.ร.ว.', N'พ.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2323, N'พันตำรวจโท หม่อมราชวงศ์', N'พ.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2324, N'พันตำรวจโท ม.ร.ว.', N'พ.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2325, N'พ.ต.ท.หม่อมราชวงศ์', N'พ.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2326, N'พ.ต.ท. ม.ร.ว.', N'พ.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2327, N'พันตำรวจเอก หม่อมราชวงศ์', N'พ.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2328, N'พันตำรวจเอก ม.ร.ว.', N'พ.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2329, N'พ.ต.อ.หม่อมราชวงศ์', N'พ.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2330, N'พ.ต.อ. ม.ร.ว.', N'พ.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2331, N'ร้อยตำรวจเอก หม่อมราชวงศ์', N'ร.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2332, N'ร้อยตำรวจเอก ม.ร.ว.', N'ร.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2333, N'ร.ต.อ.หม่อมราชวงศ์', N'ร.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2334, N'ร.ต.อ. ม.ร.ว.', N'ร.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2335, N'ร้อยตำรวจโทหม่อมราชวงศ์', N'ร.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2336, N'ร้อยตำรวจโท หม่อมราชวงศ์', N'ร.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2337, N'ร้อยตำรวจโท ม.ร.ว.', N'ร.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2338, N'ร.ต.ท.หม่อมราชวงศ์', N'ร.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2339, N'ร.ต.ท. ม.ร.ว.', N'ร.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2340, N'ร้อยตำรวจตรีหม่อมราชวงศ์', N'ร.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2341, N'ร้อยตำรวจตรี หม่อมราชวงศ์', N'ร.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2342, N'ร้อยตำรวจตรี ม.ร.ว.', N'ร.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2343, N'ร.ต.ต.หม่อมราชวงศ์', N'ร.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2344, N'ร.ต.ต. ม.ร.ว.', N'ร.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2345, N'พลตำรวจเอกหม่อมราชวงศ์', N'พล.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2346, N'พลตำรวจเอก หม่อมราชวงศ์', N'พล.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2347, N'พลตำรวจเอก ม.ร.ว.', N'พล.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2348, N'พล.ต.อ.หม่อมราชวงศ์', N'พล.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2349, N'พล.ต.อ. ม.ร.ว.', N'พล.ต.อ.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2350, N'พลตำรวจโทหม่อมราชวงศ์', N'พล.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2351, N'พลตำรวจโท หม่อมราชวงศ์', N'พล.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2352, N'พลตำรวจโท ม.ร.ว.', N'พล.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2353, N'พล.ต.ท.หม่อมราชวงศ์', N'พล.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2354, N'พล.ต.ท. ม.ร.ว.', N'พล.ต.ท.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2355, N'พลตำรวจตรี หม่อมราชวงศ์', N'พล.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2356, N'พลตำรวจตรี ม.ร.ว.', N'พล.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2357, N'พล.ต.ต.หม่อมราชวงศ์', N'พล.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2358, N'พล.ต.ต. ม.ร.ว.', N'พล.ต.ต.ม.ร.ว.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2359, N'พันเอก นายแพทย์', N'พ.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2360, N'พันเอก น.พ.', N'พ.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2361, N'พ.อ.นายแพทย์', N'พ.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2362, N'พ.อ. น.พ.', N'พ.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2363, N'พันโท นายแพทย์', N'พ.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2364, N'พันโท น.พ.', N'พ.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2365, N'พ.ท.นายแพทย์', N'พ.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2366, N'พ.ท. น.พ.', N'พ.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2367, N'พันตรี นายแพทย์', N'พ.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2368, N'พันตรี น.พ.', N'พ.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2369, N'พ.ต.นายแพทย์', N'พ.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2370, N'พ.ต. น.พ.', N'พ.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2371, N'ร้อยตำรวจเอก นายแพทย์', N'ร.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2372, N'ร้อยตำรวจเอก น.พ.', N'ร.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2373, N'ร.ต.อ.นายแพทย์', N'ร.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2374, N'ร.ต.อ. น.พ.', N'ร.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2375, N'ร้อยตำรวจโท นายแพทย์', N'ร.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2376, N'ร้อยตำรวจโท น.พ.', N'ร.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2377, N'ร.ต.ท.นายแพทย์', N'ร.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2378, N'ร.ต.ท. น.พ.', N'ร.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2379, N'ร้อยตำรวจตรีนายแพทย์', N'ร.ต.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2380, N'ร้อยตำรวจตรี นายแพทย์', N'ร.ต.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2381, N'ร้อยตำรวจตรี น.พ.', N'ร.ต.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2382, N'ร.ต.ต.นายแพทย์', N'ร.ต.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2383, N'ร.ต.ต. น.พ.', N'ร.ต.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2384, N'ร้อยเอก นายแพทย์', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2385, N'ร้อยเอก น.พ.', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2386, N'ร.อ.นายแพทย์', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2387, N'ร.อ. น.พ.', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2388, N'ร้อยโท นายแพทย์', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2389, N'ร้อยโท น.พ.', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2390, N'ร.ท.นายแพทย์', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2391, N'ร.ท. น.พ.', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2392, N'ร้อยตรี นายแพทย์', N'ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2393, N'ร้อยตรี น.พ.', N'ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2394, N'ร.ต.นายแพทย์', N'ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2395, N'ร.ต. น.พ.', N'ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2396, N'ร้อยเอก แพทย์หญิง', N'ร.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2397, N'ร้อยเอก พ.ญ.', N'ร.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2398, N'ร.อ.แพทย์หญิง', N'ร.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2399, N'ร.อ. พ.ญ.', N'ร.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2400, N'ร้อยโท แพทย์หญิง', N'ร.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2401, N'ร้อยโท พ.ญ.', N'ร.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2402, N'ร.ท.แพทย์หญิง', N'ร.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2403, N'ร.ท. พ.ญ.', N'ร.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2404, N'ร้อยตรี แพทย์หญิง', N'ร.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2405, N'ร้อยตรี พ.ญ.', N'ร.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2406, N'ร.ต.แพทย์หญิง', N'ร.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2407, N'ร.ต. พ.ญ.', N'ร.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2408, N'พันตำรวจเอก นายแพทย์', N'พ.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2409, N'พันตำรวจเอก นพ.', N'พ.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2410, N'พ.ต.อ.นายแพทย์', N'พ.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2411, N'พ.ต.อ. นพ.', N'พ.ต.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2412, N'พันตำรวจโท นายแพทย์', N'พ.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2413, N'พันตำรวจโท นพ.', N'พ.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2414, N'พ.ต.ท.นายแพทย์', N'พ.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2415, N'พ.ต.ท. นพ.', N'พ.ต.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2416, N'พันตำรวจตรี นายแพทย์', N'พ.ต.ต.นพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2417, N'พันตำรวจตรี นพ.', N'พ.ต.ต.นพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2418, N'พ.ต.ต.นายแพทย์', N'พ.ต.ต.นพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2419, N'พ.ต.ต. นพ.', N'พ.ต.ต.นพ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2420, N'ว่าที่ร้อยเอกนายแพทย์', N'ว่าที่ ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2421, N'ว่าที่ร้อยเอก นายแพทย์', N'ว่าที่ ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2422, N'ว่าที่ร้อยเอก น.พ.', N'ว่าที่ ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2423, N'ว่าที่ ร.อ.นายแพทย์', N'ว่าที่ ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2424, N'ว่าที่ ร.อ. น.พ.', N'ว่าที่ ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2425, N'ว่าที่ร้อยโท นายแพทย์', N'ว่าที่ ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2426, N'ว่าที่ร้อยโท น.พ.', N'ว่าที่ ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2427, N'ว่าที่ ร.ท.นายแพทย์', N'ว่าที่ ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2428, N'ว่าที่ ร.ท. น.พ.', N'ว่าที่ ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2429, N'ว่าที่ร้อยตรีนายแพทย์', N'ว่าที่ ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2430, N'ว่าที่ร้อยตรี นายแพทย์', N'ว่าที่ ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2431, N'ว่าที่ร้อยตรี น.พ.', N'ว่าที่ ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2432, N'ว่าที่ ร.ต.นายแพทย์', N'ว่าที่ ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2433, N'ว่าที่ ร.ต. น.พ.', N'ว่าที่ ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2434, N'พลเอกนายแพทย์', N'พล.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2435, N'พลเอก นายแพทย์', N'พล.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2436, N'พลเอก น.พ.', N'พล.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2437, N'พล.อ.นายแพทย์', N'พล.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2438, N'พล.อ. น.พ.', N'พล.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2439, N'พลโทนายแพทย์', N'พล.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2440, N'พลโท นายแพทย์', N'พล.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2441, N'พลโท น.พ.', N'พล.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2442, N'พล.ท.นายแพทย์', N'พล.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2443, N'พล.ท. น.พ.', N'พล.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2444, N'พลตรี นายแพทย์', N'พล.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2445, N'พลตรี น.พ.', N'พล.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2446, N'พล.ต.นายแพทย์', N'พล.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2447, N'พล.ต. น.พ.', N'พล.ต.น.พ.', 1)
-- ALL ABOVE DATA IS OK

GO


/*********** Script Update Date: 2022-08-31  ***********/

