SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SearchPersonImage
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[SearchPersonImage]
(
  @FullName nvarchar(200)
)
AS
BEGIN
	SELECT *
	  FROM PersonImage
	 WHERE FullName = @FullName
	    OR UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(@FullName)))
		OR UPPER(LTRIM(RTRIM(@FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(FullName)))

END

GO
