/****** Object:  StoredProcedure [dbo].[DeleteMPDC2566]    Script Date: 30/10/2565 15:24:15 ******/
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
ALTER PROCEDURE [dbo].[DeleteMPDC2566] (
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

        -- เพิ่ม เรียงข้อมูล กรณีมีข้อมูลมากกว่า 0
        IF (0 <
        (
            SELECT COUNT(CandidateNo) 
                FROM MPDC2566
                WHERE ProvinceName = @ProvinceName
                AND PollingUnitNo = @PollingUnitNo
        ))
        BEGIN
            -- REORDER NEW PROVINCE + POLLING UNIT WITH ALLOCATE SLOT FOR NEW CANDIDATE NO
            EXEC ReorderMPDC2566 @ProvinceName, @PollingUnitNo, 0
        END

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
