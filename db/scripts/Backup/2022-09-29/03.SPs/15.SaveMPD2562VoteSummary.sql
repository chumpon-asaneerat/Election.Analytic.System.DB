/****** Object:  StoredProcedure [dbo].[SaveMPD2562VoteSummary]    Script Date: 9/30/2022 6:52:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPD2562VoteSummary
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SaveMPD2562VoteSummary] (
  @ProvinceName nvarchar(100)
, @PollingUnitNo int
, @FullName nvarchar(200)
, @VoteNo int
, @PartyName nvarchar(200)
, @VoteCount int = 0
, @RevoteNo int = 0
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (@ProvinceName IS NULL 
		 OR @PollingUnitNo IS NULL 
		 OR @FullName IS NULL 
		 OR @VoteNo IS NULL
		 OR @PartyName IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Some parameter(s) is null';
			RETURN
		END
		IF (@VoteCount IS NULL) SET @VoteCount = 0;
		IF (@RevoteNo IS NULL) SET @RevoteNo = 0;

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM MPD2562VoteSummary
				 WHERE ProvinceName = @ProvinceName
				   AND PollingUnitNo = @PollingUnitNo
				   AND FullName = @FullName
				   AND VoteNo = @VoteNo
				   AND PartyName = @PartyName
			)
		   )
		BEGIN
			INSERT INTO MPD2562VoteSummary
			(
				  ProvinceName
				, PollingUnitNo
				, FullName
				, VoteNo 
				, PartyName
				, VoteCount
				, RevoteNo
			)
			VALUES
			(
				  @ProvinceName
				, @PollingUnitNo
				, @FullName
				, @VoteNo
				, @PartyName
				, @VoteCount
				, @RevoteNo
			);
		END
		ELSE
		BEGIN
			UPDATE MPD2562VoteSummary
			   SET VoteCount = @VoteCount
				 , RevoteNo = @RevoteNo
			 WHERE ProvinceName = @ProvinceName
			   AND PollingUnitNo = @PollingUnitNo
			   AND FullName = @FullName
			   AND VoteNo = @VoteNo
			   AND PartyName = @PartyName
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
