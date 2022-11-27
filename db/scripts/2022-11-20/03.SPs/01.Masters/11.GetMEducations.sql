/****** Object:  StoredProcedure [dbo].[GetMEducations]    Script Date: 11/27/2022 9:58:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMEducations
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMEducations NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMEducations]
(
  @active int = 1
)
AS
BEGIN
	SELECT *
	  FROM MEducation
	 WHERE Active = COALESCE(@active, Active)
END

GO
