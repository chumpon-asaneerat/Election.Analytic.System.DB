/****** Object:  StoredProcedure [dbo].[SavePersonImage]    Script Date: 9/29/2022 8:46:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SavePersonImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
ALTER PROCEDURE [dbo].[SavePersonImage] (
  @FullName nvarchar(200)
, @Data varbinary(MAX)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @LastUpdate datetime
	BEGIN TRY
        -- SET LAST UPDATE DATETIME
	    SET @LastUpdate = GETDATE();

		IF (NOT EXISTS 
			(
				SELECT * 
				  FROM PersonImage
				 WHERE FullName = @FullName 
			)
		   )
		BEGIN
			INSERT INTO PersonImage
			(
				  FullName
				, [Data] 
			)
			VALUES
			(
				  @FullName
				, @Data
			);
		END
		ELSE
		BEGIN
			UPDATE PersonImage
			   SET [Data] = @Data
			 WHERE FullName = @FullName
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
