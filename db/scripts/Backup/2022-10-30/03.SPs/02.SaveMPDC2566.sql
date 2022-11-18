/****** Object:  StoredProcedure [dbo].[SaveMPDC2566]    Script Date: 30/10/2565 14:30:47 ******/
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
            ))
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

				-- เพิ่ม เรียงข้อมูล กรณีมีข้อมูลมากกว่า @CandidateNo
				IF (@CandidateNo <
				(
					SELECT COUNT(CandidateNo) 
					  FROM MPDC2566
					  WHERE ProvinceName = @ProvinceName
					   AND PollingUnitNo = @PollingUnitNo
				))
			    BEGIN
                    -- REORDER PREVIOUS PROVINCE + POLLING UNIT
                    EXEC ReorderMPDC2566 @ProvinceNameOri, @PollingUnitNoOri
                    -- REORDER NEW PROVINCE + POLLING UNIT WITH ALLOCATE SLOT FOR NEW CANDIDATE NO
                    EXEC ReorderMPDC2566 @ProvinceName, @PollingUnitNo, 0
				END
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
