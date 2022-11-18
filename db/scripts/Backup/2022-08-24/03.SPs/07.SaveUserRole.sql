SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveUserRole
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveUserRole 10, N'Exclusive';
--exec SaveUserRole 10, N'Supervisor';
--exec SaveUserRole 20, N'Normal User';
--exec SaveUserRole 20, N'User';
-- =============================================
CREATE PROCEDURE SaveUserRole (
  @RoleId int
, @RoleName nvarchar(100)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF ((@RoleId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM UserRole
				 WHERE RoleId = @RoleId
			)
		   )
		BEGIN
			INSERT INTO UserRole
			(
				  RoleId
				, RoleName 
			)
			VALUES
			(
				  @RoleId
				, @RoleName
			);
		END
		ELSE
		BEGIN
			UPDATE UserRole
			   SET RoleName = @RoleName
			 WHERE RoleId = @RoleId
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
