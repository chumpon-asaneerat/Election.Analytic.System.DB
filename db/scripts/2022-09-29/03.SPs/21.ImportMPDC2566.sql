/****** Object:  StoredProcedure [dbo].[ImportMPDC2566]    Script Date: 9/30/2022 9:05:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	ImportMPDC2566
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[ImportMPDC2566] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @CandidateNo int
, @FullName nvarchar(200)
, @PrevPartyName nvarchar(100) = NULL
, @EducationLevel nvarchar(100) = NULL
, @SubGroup nvarchar(200) = NULL
, @Remark nvarchar(4000) = NULL
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
