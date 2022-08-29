/****** Object:  StoredProcedure [dbo].[GetPersonImage]    Script Date: 8/30/2022 6:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetPersonImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonImage]
(
  @FullName nvarchar(200)
)
AS
BEGIN
	SELECT *
	  FROM PersonImage
	 WHERE FullName = @FullName
END

GO
