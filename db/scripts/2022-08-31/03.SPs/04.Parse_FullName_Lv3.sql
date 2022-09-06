/****** Object:  StoredProcedure [dbo].[Parse_FullName_Lv3]    Script Date: 9/1/2022 4:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Parse FullName level 3
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[Parse_FullName_Lv3] (
  @fullName nvarchar(4000)
, @el1 nvarchar(100)
, @el2 nvarchar(100)
, @el3 nvarchar(100)
, @prefix nvarchar(100) = NULL out
, @firstName nvarchar(100) = NULL out
, @lastName nvarchar(100) = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY

		SET @errNum = 0;
		SET @errMsg = N'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
