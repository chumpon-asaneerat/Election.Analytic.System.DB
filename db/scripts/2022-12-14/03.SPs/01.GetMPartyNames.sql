/****** Object:  StoredProcedure [dbo].[GetMPartyNames]    Script Date: 12/23/2022 10:51:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPartyNames
-- [== History ==]
-- <2022-09-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPartyNames]
AS
BEGIN
	BEGIN TRY
		SELECT PartyId, PartyName 
		  FROM MParty
	END TRY
	BEGIN CATCH

	END CATCH
END

GO
