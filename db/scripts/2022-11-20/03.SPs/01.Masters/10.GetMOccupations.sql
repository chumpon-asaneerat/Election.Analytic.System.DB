/****** Object:  StoredProcedure [dbo].[GetMOccupations]    Script Date: 11/27/2022 9:58:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMOccupations
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GetMOccupations NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMOccupations]
(
  @active int = 1
)
AS
BEGIN
	SELECT *
	  FROM MOccupation
	 WHERE Active = COALESCE(@active, Active)
END

GO
