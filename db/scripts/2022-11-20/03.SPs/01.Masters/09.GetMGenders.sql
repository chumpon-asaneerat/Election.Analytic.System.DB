/****** Object:  StoredProcedure [dbo].[GetMGenders]    Script Date: 11/27/2022 10:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMGenders
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMGenders
-- =============================================
CREATE PROCEDURE [dbo].[GetMGenders]
AS
BEGIN
	SELECT GenderId
         , [Description]
	  FROM MGender
	 ORDER BY GenderId
END

GO
