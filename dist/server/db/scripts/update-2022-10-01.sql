/*********** Script Update Date: 2022-10-01  ***********/
/****** Object:  StoredProcedure [dbo].[GetMPDC2566s]    Script Date: 10/7/2022 6:46:22 PM ******/
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
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[GetMPDC2566s]
(
  @ProvinceName nvarchar(100) = NULL
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


/*********** Script Update Date: 2022-10-01  ***********/
/****** Object:  StoredProcedure [dbo].[SaveMPDC2566]    Script Date: 10/8/2022 5:53:26 AM ******/
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
-- <2022-10-08> :
--	- Add Data parameter.
--	- Add ProvinceNameOri parameter.
--	- Add PollingUnitNoOri parameter.
--	- Add CandidateNoOri parameter.
--	- Add FullNameOri parameter.
--  - Add ImageFullNameOri parameter
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
, @Remark nvarchar(4000) = NULL
, @Data varbinary(MAX) = NULL
, @ProvinceNameOri nvarchar(100) = NULL
, @PollingUnitNoOri int = NULL
, @CandidateNoOri int = NULL
, @FullNameOri nvarchar(200) = NULL
, @ImageFullNameOri nvarchar(200) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL 
		 OR @PollingUnitNo < 1 
		 OR @CandidateNo IS NULL
		 OR @FullName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@ProvinceNameOri) = 1 AND
		    (@PollingUnitNoOri IS NULL OR @PollingUnitNoOri < 1) AND
			(@CandidateNoOri IS NULL OR @CandidateNoOri < 1) AND 
			dbo.IsNullOrEmpty(@FullNameOri) = 1)
		BEGIN
			-- NO PREVIOUS DATA
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
		END
		ELSE
		BEGIN
			IF (dbo.IsNullOrEmpty(@ProvinceNameOri) = 0 AND
			    @PollingUnitNoOri IS NOT NULL AND
				@PollingUnitNoOri >= 1 AND 
			    @CandidateNoOri IS NOT NULL AND 
				@CandidateNoOri >= 1 AND 
			    dbo.IsNullOrEmpty(@FullNameOri) = 0)
			BEGIN
				-- CANDIDATE ORDER CHANGE SO DELETE PREVIOUS
				DELETE FROM MPDC2566 
				 WHERE ProvinceName = @ProvinceNameOri
				   AND PollingUnitNo = @PollingUnitNoOri
				   AND CandidateNo = @CandidateNoOri
				   AND FullName = @FullNameOri
				-- REORDER PREVIOUS PROVINCE + POLLING UNIT
				EXEC ReorderMPDC2566 @ProvinceNameOri, @PollingUnitNoOri
				-- REORDER NEW PROVINCE + POLLING UNIT WITH ALLOCATE SLOT FOR NEW CANDIDATE NO
				EXEC ReorderMPDC2566 @ProvinceName, @PollingUnitNo, @CandidateNo
				-- INSERT DATA TO NEW PROVINCE + POLLING UNIT
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
				-- MISSING REQUIRED DATA
				SET @errNum = 200;
				SET @errMsg = 'Some previous parameter(s) is null.';
				RETURN
			END
		END

		-- Update Image
		IF ((@ImageFullNameOri IS NOT NULL)
		    AND
			(EXISTS (SELECT * FROM PersonImage WHERE FullName = @ImageFullNameOri)))
		BEGIN
			UPDATE PersonImage
			   SET FullName = @FullName
			     , Data = @Data
			 WHERE FullName = @ImageFullNameOri
		END
		ELSE
		BEGIN
			EXEC SavePersonImage @FullName, @Data
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


/*********** Script Update Date: 2022-10-01  ***********/
/****** Object:  StoredProcedure [dbo].[ReorderMPDC2566]    Script Date: 10/8/2022 5:53:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ReorderMPDC2566
-- [== History ==]
-- <2022-10-08> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ReorderMPDC2566] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @SkipCandidateNo int = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	CREATE TABLE #MPDC2566DATA
	(
		CandidateNo int,
		FullName nvarchar(200)
	)

	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END
		-- ADD DATA TO TEMP TABLE
		INSERT INTO #MPDC2566DATA 
		    SELECT CandidateNo
			     , FullName
			  FROM MPDC2566
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
		  ORDER BY CandidateNo;

		DECLARE @iCnt int = 1
		DECLARE @CandidateNo int
		DECLARE @FullName nvarchar(200)
		DECLARE MPDC2566_CURSOR CURSOR 
			LOCAL
			FORWARD_ONLY 
			READ_ONLY 
			FAST_FORWARD
		FOR  
			SELECT CandidateNo
			     , FullName
			  FROM #MPDC2566DATA
		  ORDER BY CandidateNo;

		OPEN MPDC2566_CURSOR  
		FETCH NEXT FROM MPDC2566_CURSOR INTO @CandidateNo, @FullName
		WHILE @@FETCH_STATUS = 0  
		BEGIN
			IF (@SkipCandidateNo IS NOT NULL)
			BEGIN
				IF (@iCnt = @SkipCandidateNo)
				BEGIN
					SET @iCnt = @iCnt + 1
				END
			END
			-- UPDATE RUNNING NO
			UPDATE MPDC2566
			   SET CandidateNo = @iCnt
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
			   AND CandidateNo = @CandidateNo
			   AND FullName = @FullName
			-- INCREASE RUNNING NO
			SET @iCnt = @iCnt + 1
			FETCH NEXT FROM MPDC2566_CURSOR INTO @CandidateNo, @FullName
		END

		CLOSE MPDC2566_CURSOR  
		DEALLOCATE MPDC2566_CURSOR 	

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH

	DROP TABLE #MPDC2566DATA
END

GO


/*********** Script Update Date: 2022-10-01  ***********/
/****** Object:  StoredProcedure [dbo].[DeleteMPDC2566]    Script Date: 10/8/2022 5:53:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	DeleteMPDC2566
-- [== History ==]
-- <2022-10-08> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMPDC2566] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @CandidateNo int
, @FullName nvarchar(200)
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
			SET @errMsg = 'Some parameter(s) is null.';
			RETURN
		END

		DELETE  
		  FROM MPDC2566
		 WHERE ProvinceName = @ProvinceName
		   AND PollingUnitNo = @PollingUnitNo
		   AND CandidateNo = @CandidateNo
		   AND FullName = @FullName

		-- Update Error Status/Message
		SET @errNum = 0;
		SET @errMsg = 'Success';

		EXEC ReorderMPDC2566 @ProvinceName, @PollingUnitNo, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

