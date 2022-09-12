/*********** Script Update Date: 2022-09-07  ***********/
ALTER TABLE MProvince 
  ADD AreaM2 decimal(16, 3) NULL;
GO

ALTER TABLE MProvince 
  ADD ContentId uniqueidentifier NULL;
GO


/*********** Script Update Date: 2022-09-07  ***********/
ALTER TABLE MDistrict 
  ADD AreaM2 decimal(16, 3) NULL;
GO

ALTER TABLE MDistrict 
  ADD ContentId uniqueidentifier NULL;
GO


/*********** Script Update Date: 2022-09-07  ***********/
ALTER TABLE MSubdistrict 
  ADD AreaM2 decimal(16, 3) NULL;
GO

ALTER TABLE MSubdistrict 
  ADD ContentId uniqueidentifier NULL;
GO


/*********** Script Update Date: 2022-09-07  ***********/
/****** Object:  View [dbo].[MProvinceView]    Script Date: 9/12/2022 8:50:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MProvinceView]
AS
	SELECT A.ProvinceId
	     , A.ProvinceNameTH
	     , A.ProvinceNameEN
	     , A.ADM1Code
		 , A.AreaM2 AS ProvinceAreaM2
	     , B.RegionId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
         , A.ContentId AS ProvinceContentId
	  FROM MProvince A
	     , MRegion B
	 WHERE A.RegionId = B.RegionId


GO


/*********** Script Update Date: 2022-09-07  ***********/
/****** Object:  View [dbo].[MDistrictView]    Script Date: 9/12/2022 8:50:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MDistrictView]
AS
	SELECT A.RegionId
		 , A.ProvinceId
		 , A.DistrictId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ProvinceNameTH
		 , A.DistrictNameTH
		 , C.ProvinceNameEN
		 , A.DistrictNameEN
		 , C.ADM1Code
		 , C.AreaM2 AS ProvinceAreaM2
         , C.ContentId AS ProvinceContentId
		 , A.ADM2Code
		 , A.AreaM2 AS DistrictAreaM2
         , A.ContentId AS DistrictContentId
	  FROM MDistrict A
		 , MRegion B
		 , MProvince C
	 WHERE A.RegionId = B.RegionId
	   AND C.RegionId = B.RegionId
	   AND A.ProvinceId = C.ProvinceId


GO


/*********** Script Update Date: 2022-09-07  ***********/
/****** Object:  View [dbo].[MSubdistrictView]    Script Date: 9/12/2022 8:50:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[MSubdistrictView]
AS
	SELECT A.RegionId
		 , A.ProvinceId
		 , A.DistrictId
		 , A.SubdistrictId
		 , B.RegionName
		 , B.GeoGroup
		 , B.GeoSubGroup
		 , C.ProvinceNameTH
		 , D.DistrictNameTH
		 , A.SubdistrictNameTH
		 , C.ProvinceNameEN
		 , D.DistrictNameEN
		 , A.SubdistrictNameEN
		 , C.AreaM2 AS ProvinceAreaM2
		 , D.AreaM2 AS DistrictAreaM2
		 , A.AreaM2 AS SubdistrictAreaM2
		 , C.ContentId AS ProvinceContentId
		 , D.ContentId AS DistrictContentId
		 , A.ContentId AS SubdistrictContentId
		 , C.ADM1Code
		 , D.ADM2Code
		 , A.ADM3Code
	  FROM MSubdistrict A
		 , MRegion B
		 , MProvince C
		 , MDistrict D
	 WHERE A.RegionId = B.RegionId
	   AND C.RegionId = B.RegionId
	   AND D.RegionId = B.RegionId
	   AND A.ProvinceId = C.ProvinceId
	   AND D.ProvinceId = C.ProvinceId
	   AND A.DistrictId = D.DistrictId


GO


/*********** Script Update Date: 2022-09-07  ***********/
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
ALTER PROCEDURE [dbo].[Parse_FullName_Lv3] (
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


/*********** Script Update Date: 2022-09-07  ***********/
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
ALTER PROCEDURE [dbo].[Parse_FullName_Lv4] (
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


/*********** Script Update Date: 2022-09-07  ***********/
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
ALTER PROCEDURE [dbo].[Parse_FullName_Lv5] (
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


/*********** Script Update Date: 2022-09-07  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMProvinceADM1]    Script Date: 9/11/2022 5:08:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMProvinceADM1
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC SaveMProvinceADM1 N'กรุงเทพมหานคร', N'Bangkok', N'TH10'
-- =============================================
CREATE PROCEDURE [dbo].[SaveMProvinceADM1] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @ADM1Code nvarchar(20)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceNameTH IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter some parameter(s) is null';
			RETURN
		END

		IF ((@ProvinceNameTH IS NOT NULL) 
		    AND
		    (@ProvinceNameEN IS NOT NULL)
		    AND
		    (@ADM1Code IS NOT NULL)
            AND
            EXISTS 
			(
				SELECT * 
				  FROM MProvince
				 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
			)
		   )
		BEGIN
			UPDATE MProvince
			   SET ProvinceNameEN = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameEN, ProvinceNameEN))))
				 , ADM1Code = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
				 , AreaM2 = @AreaM2
			 WHERE UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
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


/*********** Script Update Date: 2022-09-07  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMDistrictADM2]    Script Date: 9/11/2022 8:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMDistrictADM2
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- SaveMDistrictADM2 N'สกลนคร', N'Sakon Nakhon', N'อากาศอำนวย', N'Akat Amnuai', N'TH4711', 661338974.564
-- =============================================
CREATE PROCEDURE [dbo].[SaveMDistrictADM2] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100)
, @ADM2Code nvarchar(20)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
		    OR @ProvinceNameEN IS NULL 
			OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL
			OR @ADM2Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter some parameter(s) is null';
			RETURN
		END

		IF ((@DistrictNameEN IS NOT NULL)
		    AND 
			(@ADM2Code IS NOT NULL)
		   )
		BEGIN
			UPDATE MM
			   SET MM.DistrictNameEN = UPPER(LTRIM(RTRIM(@DistrictNameEN)))
				 , MM.ADM2Code = UPPER(LTRIM(RTRIM(@ADM2Code)))
				 , MM.AreaM2 = @AreaM2
			  FROM MDistrict MM 
			  JOIN MDistrictView MV ON 
			       (    
					    MM.DistrictId = MV.DistrictId 
				    AND MM.ProvinceId = MV.ProvinceId
				   )
			 WHERE UPPER(LTRIM(RTRIM(MV.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
			   AND UPPER(LTRIM(RTRIM(MV.DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))
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


/*********** Script Update Date: 2022-09-07  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMSubdistrictADM3]    Script Date: 9/11/2022 8:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMSubdistrictADM3
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC SaveMSubdistrictADM3 N'ชลบุรี', N'Chon Buri', N'เมืองชลบุรี', N'Mueang Chon Buri', N'อ่างศิลา', N'Ang Sila', N'TH200117', 6568129.19107
-- =============================================
CREATE PROCEDURE [dbo].[SaveMSubdistrictADM3] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100)
, @SubdistrictNameTH nvarchar(100)
, @SubdistrictNameEN nvarchar(100) = NULL
, @ADM3Code nvarchar(20) = NULL
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
		    OR @ProvinceNameEN IS NULL 
			OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL
			OR @SubdistrictNameTH IS NULL 
			OR @SubdistrictNameEN IS NULL
			OR @ADM3Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter some parameter(s) is null';
			RETURN
		END

		IF ((@SubdistrictNameEN IS NOT NULL)
			AND
			(@ADM3Code IS NOT NULL)
		   )
		BEGIN
			UPDATE MM
			   SET SubdistrictNameEN = UPPER(LTRIM(RTRIM(@SubdistrictNameEN)))
				 , ADM3Code = UPPER(LTRIM(RTRIM(@ADM3Code)))
				 , AreaM2 = @AreaM2
		     FROM MSubdistrict MM
			 JOIN MSubdistrictView MV ON
				  (
					    MM.DistrictId = MV.DistrictId 
				    AND MM.ProvinceId = MV.ProvinceId
					AND MM.SubdistrictId = MV.SubdistrictId
				  )
			 WHERE UPPER(LTRIM(RTRIM(MV.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
			   AND UPPER(LTRIM(RTRIM(MV.DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))
			   AND UPPER(LTRIM(RTRIM(MV.SubdistrictNameTH))) = UPPER(LTRIM(RTRIM(@SubdistrictNameTH)))
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


/*********** Script Update Date: 2022-09-07  ***********/
/****** Object:  StoredProcedure [dbo].[GetMProvinces]    Script Date: 9/11/2022 5:49:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMProvinces
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMProvinces NULL, NULL, NULL, NULL, NULL, NULL		-- Gets all
-- EXEC GetMProvinces NULL, NULL, NULL, N'1', NULL, NULL		-- Search all that RegionName contains '1'
-- EXEC GetMProvinces NULL, N'ก', NULL, NULL, N'กลาง', NULL		-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
CREATE PROCEDURE [dbo].[GetMProvinces]
(
  @ProvinceId nvarchar(10) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
, @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , ProvinceAreaM2
		 , ProvinceContentId
	  FROM MProvinceView
	 WHERE UPPER(LTRIM(RTRIM(ProvinceId))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceId, ProvinceId))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-09-07  ***********/
/****** Object:  StoredProcedure [dbo].[GetMDistricts]    Script Date: 9/11/2022 8:02:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMDistricts
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMDistricts NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL	-- Gets all
-- EXEC GetMDistricts NULL, NULL, NULL, NULL, NULL, N'1', NULL, NULL	-- Search all that RegionName contains '1'
-- EXEC GetMDistricts NULL, NULL, NULL, N'ก', NULL, NULL, N'กลาง', NULL	-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
CREATE PROCEDURE [dbo].[GetMDistricts]
(
  @DistrictId nvarchar(10) = NULL
, @DistrictNameTH nvarchar(100) = NULL
, @ProvinceId nvarchar(10) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
, @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT DistrictId
	     , DistrictNameTH
	     , DistrictNameEN
	     , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , ADM2Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , DistrictAreaM2
		 , DistrictContentId
	  FROM MDistrictView
	 WHERE UPPER(LTRIM(RTRIM(DistrictId))) = UPPER(LTRIM(RTRIM(COALESCE(@DistrictId, DistrictId))))
	   AND UPPER(LTRIM(RTRIM(DistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(ProvinceId))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceId, ProvinceId))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-09-07  ***********/
/****** Object:  StoredProcedure [dbo].[GetMSubdistricts]    Script Date: 9/11/2022 9:24:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMSubdistricts
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL		-- Gets all
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'1', NULL, NULL		-- Search all that RegionName contains '1'
-- EXEC GetMSubdistricts NULL, NULL, NULL, NULL, NULL, N'ก', NULL, NULL, N'กลาง', NULL	-- Search all that ProvinceNameTH contains 'ก' GeoGroup contains 'กลาง'
-- =============================================
CREATE PROCEDURE [dbo].[GetMSubdistricts]
(
  @SubdistrictId nvarchar(10) = NULL
, @SubdistrictNameTH nvarchar(100) = NULL
, @DistrictId nvarchar(10) = NULL
, @DistrictNameTH nvarchar(100) = NULL
, @ProvinceId nvarchar(10) = NULL
, @ProvinceNameTH nvarchar(100) = NULL
, @RegionId nvarchar(10) = NULL
, @RegionName nvarchar(100) = NULL
, @GeoGroup nvarchar(100) = NULL
, @GeoSubGroup nvarchar(100) = NULL
)
AS
BEGIN
	SELECT SubdistrictId
	     , SubdistrictNameTH
	     , SubdistrictNameEN
	     , DistrictId
	     , DistrictNameTH
	     , DistrictNameEN
	     , ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , ADM2Code
	     , ADM3Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , SubdistrictAreaM2
		 , SubdistrictContentId
	  FROM MSubdistrictView
	 WHERE UPPER(LTRIM(RTRIM(SubdistrictId))) = UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictId, SubdistrictId))))
	   AND UPPER(LTRIM(RTRIM(SubdistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@SubdistrictNameTH, SubdistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(DistrictId))) = UPPER(LTRIM(RTRIM(COALESCE(@DistrictId, DistrictId))))
	   AND UPPER(LTRIM(RTRIM(DistrictNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@DistrictNameTH, DistrictNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(ProvinceId))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceId, ProvinceId))))
	   AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH)))) + '%'
	   AND UPPER(LTRIM(RTRIM(RegionId))) = UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId))))
	   AND UPPER(LTRIM(RTRIM(RegionName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionName, RegionName)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoGroup, GeoGroup)))) + '%'
	   AND UPPER(LTRIM(RTRIM(GeoSubGroup))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@GeoSubGroup, GeoSubGroup)))) + '%'
	 ORDER BY ProvinceNameTH

END

GO


/*********** Script Update Date: 2022-09-07  ***********/
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2448, N'นาวาเอกแพทย์หญิง', N'น.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2449, N'นาวาเอก แพทย์หญิง', N'น.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2450, N'นาวาเอก พ.ญ.', N'น.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2451, N'น.อ. แพทย์หญิง', N'น.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2452, N'น.อ. พ.ญ.', N'น.อ.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2453, N'นาวาโทแพทย์หญิง', N'น.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2454, N'นาวาโท แพทย์หญิง', N'น.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2455, N'นาวาโท พ.ญ.', N'น.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2456, N'น.ท. แพทย์หญิง', N'น.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2457, N'น.ท. พ.ญ.', N'น.ท.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2458, N'นาวาตรี แพทย์หญิง', N'น.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2459, N'นาวาตรี พ.ญ.', N'น.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2460, N'น.ต. แพทย์หญิง', N'น.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2461, N'น.ต. พ.ญ.', N'น.ต.พ.ญ.', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2462, N'นาวาเอกนายแพทย์', N'น.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2463, N'นาวาเอก นายแพทย์', N'น.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2464, N'นาวาเอก น.พ.', N'น.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2465, N'น.อ. นายแพทย์', N'น.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2466, N'น.อ. น.พ.', N'น.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2467, N'นาวาโทนายแพทย์', N'น.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2468, N'นาวาโท นายแพทย์', N'น.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2469, N'นาวาโท น.พ.', N'น.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2470, N'น.ท. นายแพทย์', N'น.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2471, N'น.ท. น.พ.', N'น.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2472, N'นาวาตรี นายแพทย์', N'น.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2473, N'นาวาตรี น.พ.', N'น.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2474, N'น.ต. นายแพทย์', N'น.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2475, N'น.ต. น.พ.', N'น.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2476, N'ศาสตราจารย์ นายแพทย์พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2477, N'ศจ. นายแพทย์พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2478, N'ศจ. นายแพทย์ พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2479, N'ศจ.น.พ.พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2480, N'ศจ. น.พ.พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2481, N'ศจ. น.พ. พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2482, N'ศจ. น.พ.พ.ต.อ.', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2483, N'ศจ. น.พ. พ.ต.อ.', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2484, N'ศาสตราจารย์ น.พ.พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2485, N'ศาสตราจารย์ น.พ. พันตำรวจเอก', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2486, N'ศาสตราจารย์ น.พ.พ.ต.อ.', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2487, N'ศาสตราจารย์ น.พ. พ.ต.อ.', N'ศจ.น.พ.พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2488, N'ร้อยเอก ดอกเตอร์', N'ร.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2489, N'ร้อยเอก ดร.', N'ร.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2490, N'ร.อ. ดอกเตอร์', N'ร.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2491, N'ร.อ.ดอกเตอร์', N'ร.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2492, N'ร.อ. ดร.', N'ร.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2493, N'ร้อยโท ดอกเตอร์', N'ร.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2494, N'ร้อยโท ดร.', N'ร.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2495, N'ร.ท. ดอกเตอร์', N'ร.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2496, N'ร.ท.ดอกเตอร์', N'ร.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2497, N'ร.ท. ดร.', N'ร.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2498, N'ร้อยตรี ดอกเตอร์', N'ร.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2499, N'ร้อยตรี ดร.', N'ร.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2500, N'ร.ต. ดอกเตอร์', N'ร.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2501, N'ร.ต.ดอกเตอร์', N'ร.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2502, N'ร.ต. ดร.', N'ร.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2503, N'พันเอกหญิง คุณหญิง', N'พ.อ.หญิง คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2504, N'พ.อ.หญิง คุณหญิง', N'พ.อ.หญิง คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2505, N'พ.อ.หญิงคุณหญิง', N'พ.อ.หญิง คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2506, N'พันโท คุณหญิง', N'พ.ท.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2507, N'พ.ท. คุณหญิง', N'พ.ท.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2508, N'พ.ท.คุณหญิง', N'พ.ท.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2509, N'พันตรี คุณหญิง', N'พ.ต.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2510, N'พ.ต. คุณหญิง', N'พ.ต.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2511, N'พ.ต.คุณหญิง', N'พ.ต.คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2512, N'ว่าที่ พลตำรวจเอก', N'ว่าที่ พล.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2513, N'ว่าที่ พลตำรวจ เอก', N'ว่าที่ พล.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2514, N'ว่าที่ พล.ต.เอก', N'ว่าที่ พล.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2515, N'ว่าที่พล.ต.อ', N'ว่าที่ พล.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2516, N'ว่าที่ พลตำรวจโท', N'ว่าที่ พล.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2517, N'ว่าที่ พลตำรวจ โท', N'ว่าที่ พล.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2518, N'ว่าที่ พล.ต.โท', N'ว่าที่ พล.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2519, N'ว่าที่พล.ต.ท', N'ว่าที่ พล.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2520, N'ว่าที่ พลตำรวจตรี', N'ว่าที่ พล.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2521, N'ว่าที่ พลตำรวจ ตรี', N'ว่าที่ พล.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2522, N'ว่าที่ พล.ต.ตรี', N'ว่าที่ พล.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2523, N'ว่าที่พล.ต.ต', N'ว่าที่ พล.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2524, N'ว่าที่ พลตำรวจจัตวา', N'ว่าที่พล.ต.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2525, N'ว่าที่ พลตำรวจ จัตวา', N'ว่าที่พล.ต.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2526, N'ว่าที่ พล.ต.จัตวา', N'ว่าที่พล.ต.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2527, N'ว่าที่พล.ต.จ', N'ว่าที่พล.ต.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2528, N'ว่าที่ พันตำรวจเอก (พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2529, N'ว่าที่ พันตำรวจเอก(พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2530, N'ว่าที่ พ.ต.อ. (พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2531, N'ว่าที่ พ.ต.อ.(พิเศษ)', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2532, N'ว่าที่ พ.ต.อ. พิเศษ', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2533, N'ว่าที่ พ.ต.อ.พิเศษ', N'ว่าที่ พ.ต.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2534, N'ว่าที่ พันตำรวจเอก', N'ว่าที่ พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2535, N'ว่าที่.พ.ต.อ.', N'ว่าที่ พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2536, N'ว่าที่. พ.ต.อ.', N'ว่าที่ พ.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2537, N'ว่าที่ พันตำรวจโท', N'ว่าที่ พ.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2538, N'ว่าที่.พ.ต.ท.', N'ว่าที่ พ.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2539, N'ว่าที่. พ.ต.ท.', N'ว่าที่ พ.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2540, N'ว่าที่ พันตำรวจตรี', N'ว่าที่ พ.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2541, N'ว่าที่.พ.ต.ต.', N'ว่าที่ พ.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2542, N'ว่าที่. พ.ต.ต.', N'ว่าที่ พ.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2543, N'ว่าที่ ร้อยตำรวจเอก', N'ว่าที่ ร.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2544, N'ว่าที่ ร.ต.อ.', N'ว่าที่ ร.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2545, N'ว่าที่.ร.ต.อ.', N'ว่าที่ ร.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2546, N'ว่าที่. ร.ต.อ.', N'ว่าที่ ร.ต.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2547, N'ว่าที่ ร้อยตำรวจโท', N'ว่าที่ ร.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2548, N'ว่าที่ ร.ต.ท.', N'ว่าที่ ร.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2549, N'ว่าที่.ร.ต.ท.', N'ว่าที่ ร.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2550, N'ว่าที่. ร.ต.ท.', N'ว่าที่ ร.ต.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2551, N'ว่าที่ ร้อยตำรวจตรี', N'ว่าที่ ร.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2552, N'ว่าที่ ร.ต.ต.', N'ว่าที่ ร.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2553, N'ว่าที่.ร.ต.ต.', N'ว่าที่ ร.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2554, N'ว่าที่. ร.ต.ต.', N'ว่าที่ ร.ต.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2555, N'ว่าที่ นาวาอากาศเอกพิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2556, N'ว่าที่ น.อ.พิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2557, N'ว่าที่. น.อ.พิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2558, N'ว่าที่.น.อ.พิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2559, N'ว่าที่ นาวาอากาศเอก(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2560, N'ว่าที่ นาวาอากาศเอก (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2561, N'ว่าที่ น.อ.(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2562, N'ว่าที่ น.อ. (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2563, N'ว่าที่. น.อ.(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2564, N'ว่าที่. น.อ. (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2565, N'ว่าที่.น.อ.(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2566, N'ว่าที่.น.อ. (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2567, N'ว่าที่ นาวาอากาศเอก', N'ว่าที่ น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2568, N'ว่าที่ น.อ.', N'ว่าที่ น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2569, N'ว่าที่. น.อ.', N'ว่าที่ น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2570, N'ว่าที่.น.อ.', N'ว่าที่ น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2571, N'ว่าที่ นาวาอากาศโท', N'ว่าที่ น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2572, N'ว่าที่ น.ท.', N'ว่าที่ น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2573, N'ว่าที่. น.ท.', N'ว่าที่ น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2574, N'ว่าที่.น.ท.', N'ว่าที่ น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2575, N'ว่าที่ นาวาอากาศตรี', N'ว่าที่ น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2576, N'ว่าที่ น.ต.', N'ว่าที่ น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2577, N'ว่าที่.น.ต.', N'ว่าที่ น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2578, N'ว่าที่. น.ต.', N'ว่าที่ น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2579, N'พลตำรวจ.พิเศษ', N'พลฯพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2580, N'พลฯ.พิเศษ', N'พลฯพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2581, N'พลตำรวจ(พิเศษ)', N'พลฯพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2582, N'พลฯ(พิเศษ)', N'พลฯพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2583, N'พลตำรวจ (พิเศษ)', N'พลฯพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2584, N'พลฯ (พิเศษ)', N'พลฯพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2585, N'พลตำรวจ อาสาสมัคร', N'พลฯอาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2586, N'พลตำรวจ อาสา', N'พลฯอาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2587, N'พลตำรวจ(อาสา)', N'พลฯอาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2588, N'พลตำรวจ (อาสา)', N'พลฯอาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2590, N'พลฯ อาสา', N'พลฯอาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2591, N'พลฯ(อาสา)', N'พลฯอาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2592, N'พลฯ (อาสา)', N'พลฯอาสา', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2594, N'พลตำรวจ สำรอง', N'พลฯสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2595, N'พลตำรวจ (สำรอง)', N'พลฯสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2596, N'พลตำรวจ(สำรอง)', N'พลฯสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2597, N'พลฯ สำรอง', N'พลฯสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2598, N'พลฯ (สำรอง)', N'พลฯสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2599, N'พลฯ(สำรอง)', N'พลฯสำรอง', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2600, N'พลตำรวจ สำรองพิเศษ', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2601, N'พลตำรวจ สำรอง พิเศษ', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2602, N'พลตำรวจ สำรอง (พิเศษ)', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2603, N'พลตำรวจ สำรอง(พิเศษ)', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2604, N'พลฯ สำรองพิเศษ', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2605, N'พลฯ สำรอง พิเศษ', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2606, N'พลฯ สำรอง (พิเศษ)', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2607, N'พลฯ สำรอง(พิเศษ)', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2608, N'พลฯสำรองพิเศษ', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2609, N'พลฯสำรอง พิเศษ', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2610, N'พลฯสำรอง (พิเศษ)', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2611, N'พลฯสำรอง(พิเศษ)', N'พลฯสำรองพิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2612, N'พลตำรวจ (สมัคร)', N'พลฯสมัคร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2613, N'พลฯ (สมัคร)', N'พลฯสมัคร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2614, N'พลตำรวจ(สมัคร)', N'พลฯสมัคร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2615, N'พลฯ(สมัคร)', N'พลฯสมัคร', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2616, N'ว่าที่ เรืออากาศเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2617, N'ว่าที่.เรืออากาศเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2618, N'ว่าที่.ร.อ.', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2619, N'ว่าที่. ร.อ.', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2620, N'ว่าที่ เรืออากาศโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2621, N'ว่าที่.เรืออากาศโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2622, N'ว่าที่.ร.ท.', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2623, N'ว่าที่. ร.ท.', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2624, N'ว่าที่ เรืออากาศตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2625, N'ว่าที่.เรืออากาศตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2626, N'ว่าที่.ร.ต.', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2627, N'ว่าที่ .ร.ต.', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2628, N'ว่าที่ พลเรือเอก', N'ว่าที่ พล.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2629, N'ว่าที่. พล.ร.อ.', N'ว่าที่ พล.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2630, N'ว่าที่.พล.ร.อ.', N'ว่าที่ พล.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2631, N'ว่าที่ พลเรือโท', N'ว่าที่ พล.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2632, N'ว่าที่. พล.ร.ท.', N'ว่าที่ พล.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2633, N'ว่าที่.พล.ร.ท.', N'ว่าที่ พล.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2634, N'ว่าที่ พลเรือตรี', N'ว่าที่ พล.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2635, N'ว่าที่. พล.ร.ต.', N'ว่าที่ พล.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2636, N'ว่าที่.พล.ร.ต.', N'ว่าที่ พล.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2637, N'ว่าที่ นาวาเอกพิเศษ', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2640, N'ว่าที่  น.อ.(พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2643, N'ว่าที่  น.อ. (พิเศษ)', N'ว่าที่ น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2646, N'ว่าที่ นาวาเอก', N'ว่าที่ น.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2649, N'ว่าที่ นาวาโท', N'ว่าที่ น.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2652, N'ว่าที่ นาวาตรี', N'ว่าที่ น.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2653, N'ว่าที่ เรือเอก', N'ว่าที่ ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2656, N'ว่าที่ เรือโท', N'ว่าที่ ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2659, N'ว่าที่ เรือตรี', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2661, N'ว่าที่. ร.ต.', N'ว่าที่ ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2662, N'พล.อ.เอก', N'พล.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2664, N'พล.อ.โท', N'พล.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2666, N'พล.อ.ตรี', N'พล.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2667, N'ว่าที่ พลอากาศเอก', N'ว่าที่ พล.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2668, N'ว่าที่.พล.อ.อ.', N'ว่าที่ พล.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2669, N'ว่าที่. พล.อ.อ.', N'ว่าที่ พล.อ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2670, N'ว่าที่ พลอากาศโท', N'ว่าที่ พล.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2671, N'ว่าที่.พล.อ.ท.', N'ว่าที่ พล.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2672, N'ว่าที่. พล.อ.ท.', N'ว่าที่ พล.อ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2673, N'ว่าที่ พลอากาศตรี', N'ว่าที่ พล.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2674, N'ว่าที่.พล.อ.ต.', N'ว่าที่ พล.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2675, N'ว่าที่. พล.อ.ต.', N'ว่าที่ พล.อ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2676, N'ศาสตราจารย์ พันเอก', N'ศจ.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2677, N'ศาสตราจารย์ พ.อ.', N'ศจ.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2678, N'ศจ. พันเอก', N'ศจ.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2679, N'ศจ.พันเอก', N'ศจ.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2680, N'ศจ. พ.อ.', N'ศจ.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2681, N'ศาสตราจารย์พันโท', N'ศจ.พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2682, N'ศาสตราจารย์ พันโท', N'ศจ.พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2683, N'ศาสตราจารย์ พ.ท.', N'ศจ.พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2684, N'ศจ. พันโท', N'ศจ.พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2685, N'ศจ.พันโท', N'ศจ.พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2686, N'ศจ. พ.ท.', N'ศจ.พ.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2687, N'ศาสตราจารย์พันตรี', N'ศจ.พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2688, N'ศาสตราจารย์ พันตรี', N'ศจ.พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2689, N'ศาสตราจารย์ พ.ต.', N'ศจ.พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2690, N'ศจ. พันตรี', N'ศจ.พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2691, N'ศจ.พันตรี', N'ศจ.พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2692, N'ศจ. พ.ต.', N'ศจ.พ.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2693, N'ศาสตราจารย์ ร้อยเอก', N'ศจ.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2694, N'ศาสตราจารย์ ร.อ.', N'ศจ.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2695, N'ศจ. ร้อยเอก', N'ศจ.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2696, N'ศจ.ร้อยเอก', N'ศจ.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2697, N'ศจ. ร.อ.', N'ศจ.ร.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2698, N'ศาสตราจารย์ร้อยโท', N'ศจ.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2699, N'ศาสตราจารย์ ร้อยโท', N'ศจ.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2700, N'ศาสตราจารย์ ร.ท.', N'ศจ.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2701, N'ศจ. ร้อยโท', N'ศจ.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2702, N'ศจ.ร้อยโท', N'ศจ.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2703, N'ศจ. ร.ท.', N'ศจ.ร.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2704, N'ศาสตราจารย์ร้อยตรี', N'ศจ.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2705, N'ศาสตราจารย์ ร้อยตรี', N'ศจ.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2706, N'ศาสตราจารย์ ร.ต.', N'ศจ.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2707, N'ศจ. ร้อยตรี', N'ศจ.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2708, N'ศจ.ร้อยตรี', N'ศจ.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2709, N'ศจ. ร.ต.', N'ศจ.ร.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2710, N'ว่าที่ สิบเอก', N'ว่าที่ ส.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2711, N'ว่าที่.ส.อ.', N'ว่าที่ ส.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2712, N'ว่าที่. ส.อ.', N'ว่าที่ ส.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2713, N'ว่าที่สิบโท', N'ว่าที่ ส.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2714, N'ว่าที่ สิบโท', N'ว่าที่ ส.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2715, N'ว่าที่.ส.ท.', N'ว่าที่ ส.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2716, N'ว่าที่. ส.ท.', N'ว่าที่ ส.ท.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2717, N'ว่าที่สิบตรี', N'ว่าที่ ส.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2718, N'ว่าที่ สิบตรี', N'ว่าที่ ส.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2719, N'ว่าที่.ส.ต.', N'ว่าที่ ส.ต.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2720, N'ว่าที่. ส.ต.', N'ว่าที่ ส.ต.', 1)
GO


/*********** Script Update Date: 2022-09-07  ***********/
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2721, N'จ่าสิบเอก(พิเศษ)', N'จ.ส.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2722, N'จ่าสิบเอก (พิเศษ)', N'จ.ส.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2723, N'จ่าสิบเอก.(พิเศษ)', N'จ.ส.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2724, N'จ่าสิบเอก.พิเศษ', N'จ.ส.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2725, N'จ.ส.อ.(พิเศษ)', N'จ.ส.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2726, N'จ.ส.อ. (พิเศษ)', N'จ.ส.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2727, N'พลเรือ จัตวา', N'พล.ร.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2728, N'พล.ร จัตวา', N'พล.ร.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2729, N'พล.ร.จัตวา', N'พล.ร.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2730, N'พลเรือ จ.', N'พล.ร.จ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2731, N'พลฯ ทหารเรือ', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2732, N'พลฯ ทร', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2733, N'พลฯ.ทร', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2734, N'นาวาเอก(พิเศษ)', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2735, N'นาวาเอก (พิเศษ)', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2736, N'นาวาเอก.(พิเศษ)', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2737, N'น.อ. (พิเศษ)', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2738, N'น.อ.(พิเศษ)', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2739, N'นาวาอากาศเอก(พิเศษ)', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2740, N'นาวาอากาศเอก (พิเศษ)', N'น.อ.พิเศษ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2741, N'พันตำรวจโทหญิง ท่านผู้หญิง', N'พ.ต.ท.หญิง ท่านผู้หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2742, N'พันตำรวจตรีหญิง ท่านผู้หญิง', N'พ.ต.ต.หญิง ท่านผู้หญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2743, N'พลเอกหญิง คุณหญิง', N'พล.อ.หญิง คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2744, N'พลโทหญิง คุณหญิง', N'พล.ท.หญิง คุณหญิง', 2)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2746, N'พลฯ ทหารอากาศ', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2747, N'พลฯ.ทหารอากาศ', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2748, N'พลฯ ท.อ.', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2749, N'พลฯ.ท.อ.', N'พลฯ', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2750, N'น.ร.นายเรืออากาศ', N'นนอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2751, N'น.ร. นายเรืออากาศ', N'นนอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2752, N'น.ร. นอ.', N'นนอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2753, N'น.ร.นอ.', N'นนอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2754, N'น.ร. น.อ.', N'นนอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2755, N'น.ร.น.อ.', N'นนอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2756, N'น.ร.จ่าอากาศ', N'นจอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2757, N'น.ร. จ่าอากาศ', N'นจอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2758, N'น.ร. จอ', N'นจอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2759, N'น.ร.จอ', N'นจอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2760, N'น.ร. จ.อ.', N'นจอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2761, N'น.ร.จ.อ', N'นจอ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2762, N'ร้อยตำรวจเอกดอกเตอร์', N'ร.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2763, N'ร้อยตำรวจเอก ดอกเตอร์', N'ร.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2764, N'ร้อยตำรวจเอก ดร.', N'ร.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2765, N'ร.ต.อ. ดอกเตอร์', N'ร.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2766, N'ร.ต.อ.ดอกเตอร์', N'ร.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2767, N'ร.ต.อ. ดร.', N'ร.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2768, N'ร้อยตำรวจโท ดอกเตอร์', N'ร.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2769, N'ร้อยตำรวจโท ดร.', N'ร.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2770, N'ร.ต.ท. ดอกเตอร์', N'ร.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2771, N'ร.ต.ท.ดอกเตอร์', N'ร.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2772, N'ร.ต.ท. ดร.', N'ร.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2773, N'ร้อยตำรวจตรีดอกเตอร์', N'ร.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2774, N'ร้อยตำรวจตรี ดอกเตอร์', N'ร.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2775, N'ร้อยตำรวจตรี ดร.', N'ร.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2776, N'ร.ต.ต. ดอกเตอร์', N'ร.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2777, N'ร.ต.ต.ดอกเตอร์', N'ร.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2778, N'ร.ต.ต. ดร.', N'ร.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2779, N'พันตำรวจเอก ดอกเตอร์', N'พ.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2780, N'พันตำรวจเอก ดร.', N'พ.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2781, N'พ.ต.อ. ดอกเตอร์', N'พ.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2782, N'พ.ต.อ.ดอกเตอร์', N'พ.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2783, N'พ.ต.อ. ดร.', N'พ.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2784, N'พันตำรวจโทดอกเตอร์', N'พ.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2785, N'พันตำรวจโท ดอกเตอร์', N'พ.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2786, N'พันตำรวจโท ดร.', N'พ.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2787, N'พ.ต.ท. ดอกเตอร์', N'พ.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2788, N'พ.ต.ท.ดอกเตอร์', N'พ.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2789, N'พ.ต.ท. ดร.', N'พ.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2790, N'พันตำรวจตรีดอกเตอร์', N'พ.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2791, N'พันตำรวจตรี ดอกเตอร์', N'พ.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2792, N'พันตำรวจตรี ดร.', N'พ.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2793, N'พ.ต.ต. ดอกเตอร์', N'พ.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2794, N'พ.ต.ต.ดอกเตอร์', N'พ.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2795, N'พ.ต.ต. ดร.', N'พ.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2796, N'พลตำรวจเอก ดอกเตอร์', N'พล.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2797, N'พลตำรวจเอก ดร.', N'พล.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2798, N'พล.ต.อ. ดอกเตอร์', N'พล.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2799, N'พล.ต.อ.ดอกเตอร์', N'พล.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2800, N'พล.ต.อ. ดร.', N'พล.ต.อ.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2801, N'พลตำรวจโทดอกเตอร์', N'พล.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2802, N'พลตำรวจโท ดอกเตอร์', N'พล.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2803, N'พลตำรวจโท ดร.', N'พล.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2804, N'พล.ต.ท. ดอกเตอร์', N'พล.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2805, N'พล.ต.ท.ดอกเตอร์', N'พล.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2806, N'พล.ต.ท. ดร.', N'พล.ต.ท.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2807, N'พลตำรวจตรีดอกเตอร์', N'พล.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2808, N'พลตำรวจตรี ดอกเตอร์', N'พล.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2809, N'พลตำรวจตรี ดร.', N'พล.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2810, N'พล.ต.ต. ดอกเตอร์', N'พล.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2811, N'พล.ต.ต.ดอกเตอร์', N'พล.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2812, N'พล.ต.ต. ดร.', N'พล.ต.ต.ดร.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2813, N'นักเรียนพยาบาล ท.อ.', N'น.พ.อ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2814, N'สมาชิก อส.', N'อส.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2815, N'เรืออากาศเอก นายแพทย์', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2816, N'เรืออากาศเอก น.พ.', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2817, N'ร.อ. นายแพทย์', N'ร.อ.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2820, N'เรืออากาศโทนายแพทย์', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2821, N'เรืออากาศโท นายแพทย์', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2822, N'เรืออากาศโท น.พ.', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2823, N'ร.ท. นายแพทย์', N'ร.ท.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2826, N'เรืออากาศตรีนายแพทย์', N'ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2827, N'เรืออากาศตรี นายแพทย์', N'ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2828, N'เรืออากาศตรี น.พ.', N'ร.ต.น.พ.', 1)
INSERT [MTitle] ([TitleId], [Description], [ShortName], [GenderId]) VALUES (2829, N'ร.ต. นายแพทย์', N'ร.ต.น.พ.', 1)

GO


/*********** Script Update Date: 2022-09-07  ***********/
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

