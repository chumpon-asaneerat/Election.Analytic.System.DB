/****** Object:  StoredProcedure [dbo].[GetMPDCs]    Script Date: 12/13/2022 8:35:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCs
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
-- <2022-10-07> :
--	- Supports Paging.
-- <2022-10-09> :
--	- Add FullNamne parameter.
-- <2022-10-30> :
--	- Change logic.
--	- Remove Paging.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCs]
(
  @ThaiYear int
, @ProvinceNameTH nvarchar(100)
, @PollingUnitNo as int
, @FullName nvarchar(200) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @sFullName nvarchar(200)
	BEGIN TRY
	    IF (@FullName IS NULL)
		BEGIN
			SET @sFullName = N'';
		END
		ELSE 
		BEGIN
			SET @sFullName = @FullName;
		END

		SELECT ProvinceNameTH
			 , PollingUnitNo
			 , CandidateNo
             , PersonId
			 , FullName
             , PrevPartyId
			 , PartyName AS PrevPartyName
			 , EducationName
			 , CandidateRemark
			 , CandidateSubGroup
			 , PersonImageData
             , ProvinceNameTH AS ProvinceNameOri
             , PollingUnitNo AS PollingUnitNoOri
             , CandidateNo AS CandidateNoOri
             , FullName AS FullNameOri
		  FROM MPDCView 
		 WHERE ThaiYear = @ThaiYear
           AND ProvinceNameTH = @ProvinceNameTH
		   AND PollingUnitNo = @PollingUnitNo
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(@sFullName))) + '%'

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
