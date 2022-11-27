/****** Object:  StoredProcedure [dbo].[GetUserRoles]    Script Date: 11/27/2022 10:08:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUserRoles
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetUserRoles NULL, NULL      -- Gets all
-- EXEC GetUserRoles 1, NULL         -- Get RoleId 1
-- EXEC GetUserRoles NULL, N'adm'    -- Gets all person images
-- =============================================
CREATE PROCEDURE [dbo].[GetUserRoles]
(
  @RoleId int = NULL
, @RoleName nvarchar(100) = NULL
)
AS
BEGIN
	SELECT *
	  FROM UserRole
	 WHERE RoleId = COALESCE(@RoleId, RoleId)
       AND UPPER(LTRIM(RTRIM(RoleName))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RoleName, RoleName)))) + '%'
END

GO
