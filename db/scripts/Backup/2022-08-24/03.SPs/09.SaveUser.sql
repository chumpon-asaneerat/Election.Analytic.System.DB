SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveUser
-- [== History ==]
-- <2022-08-22> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveUser 20, N'User 6', N'user6', N'123';     -- Save User with RoleId = 20 (user)
-- =============================================
CREATE PROCEDURE SaveUser (
  @RoleId int
, @FullName nvarchar(100)
, @UserName nvarchar(50)
, @Password nvarchar(50)
, @UserId int = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @LastUpdated datetime;
	BEGIN TRY
        -- Gets Current DateTime
        SET @LastUpdated = GETDATE();

		IF ((@UserId IS NULL)
            OR
            NOT EXISTS 
			(
				SELECT * 
				  FROM UserInfo
				 WHERE UserId = @UserId
			)
		   )
		BEGIN
			INSERT INTO UserInfo
			(
				  RoleId 
				, FullName 
				, UserName 
				, [Password] 
				, Active
                , LastUpdated 
			)
			VALUES
			(
				  @RoleId 
				, @FullName 
				, @UserName 
				, @Password
                , 1
                , @LastUpdated
			);

            SET @UserId = @@IDENTITY;
		END
		ELSE
		BEGIN
			UPDATE UserInfo
			   SET FullName = @FullName
                 , RoleId = @RoleId
                 , UserName = @UserName
                 , [Password] = @Password
                 , LastUpdated = @LastUpdated
			 WHERE UserId = @UserId
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
