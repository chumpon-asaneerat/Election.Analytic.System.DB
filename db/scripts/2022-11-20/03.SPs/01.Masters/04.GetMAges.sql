/****** Object:  StoredProcedure [dbo].[GetMAges]    Script Date: 11/27/2022 9:58:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMAges
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMContents NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMAges]
(
  @active int = 1
)
AS
BEGIN
	SELECT *
	  FROM MAge
	 WHERE Active = COALESCE(@active, Active)
END

GO
